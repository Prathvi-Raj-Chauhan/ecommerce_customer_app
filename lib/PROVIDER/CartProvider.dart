import 'package:ecommerce_customer/MODELS/DetailedProduct.dart';
import 'package:ecommerce_customer/MODELS/cartProduct.dart';
import 'package:ecommerce_customer/SERVICES/dioclient.dart';
import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  List<CartProduct> _cart = [];
  int _length = 0;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<CartProduct> get cart => _cart;
  int get length => _length;

  // add to cart
  Future<void> addItemToCart(String prodId) async {
    try {
      final re = await Dioclient.dio.post('/add-to-cart/$prodId');
      final data = re.data['cartItem'];

      final newItem = CartProduct.fromJson(data);

      final index = _cart.indexWhere((item) => item.product.id == prodId);

      if (index != -1) {
        // already exists
        _cart[index] = CartProduct(
          product: _cart[index].product,
          quantity: newItem.quantity,
        );
      } else {
        // new product
        _cart.add(newItem);
      }
      _length = _cart.length;
      notifyListeners(); // 🚀 instant UI update
    } catch (e) {
      debugPrint('ADD TO CART ERROR: $e');
    }
  }

  Future<void> delteItem(String prodId) async {
    try {
      final re = await Dioclient.dio.delete('/delete-from-cart/$prodId');

      final data = re.data['cartItem'];
      var newItem = null;
      if (data != null) {
        newItem = CartProduct.fromJson(data);
      }

      final index = _cart.indexWhere((item) => item.product.id == prodId);

      if (index == -1) return;

      if (re.data['removed'] == true) {
        // backend removed item
        _cart.removeAt(index);
      } else {
        _cart[index] = CartProduct(
          product: _cart[index].product,
          quantity: newItem.quantity,
        );
      }
      _length = _cart.length;
      notifyListeners();
    } catch (e) {
      debugPrint('DELETE CART ERROR: $e');
    }
  }

  int getCurrentCount(String prodId) {
    // get the count of current element in the cart
    
    final index = _cart.indexWhere((item) => item.product.id == prodId);

    if (index != -1) {
      return _cart[index].quantity;
    }

    return 0;
  }
  // get all elements from cart

  Future<void> fetchCartProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final re = await Dioclient.dio.get('/cart');
      final res = re.data;

      final List products = res['data'];
      _cart = products.map((item) => CartProduct.fromJson(item)).toList();
    } catch (e) {
      debugPrint('FETCH CART ERROR: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
