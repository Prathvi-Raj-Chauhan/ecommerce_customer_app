import 'package:ecommerce_customer/MODELS/HomeProducts.dart';
import 'package:ecommerce_customer/SERVICES/dioclient.dart';
import 'package:flutter/material.dart';

class HomeProductsProvider extends ChangeNotifier {
  bool _isLoading = false;

  List<HomeProducts> _newArrivals = [];
  List<HomeProducts> _hotProducts = [];
  List<HomeProducts> _topSellers = [];
  List<HomeProducts> _topDiscounts = [];

  // Getters
  bool get isLoading => _isLoading;
  List<HomeProducts> get newArrivals => _newArrivals;
  List<HomeProducts> get hotProducts => _hotProducts;
  List<HomeProducts> get topSellers => _topSellers;
  List<HomeProducts> get topDiscounts => _topDiscounts;

  Future<void> fetchProducts({bool forceRefresh = false}) async {
    // Prevent duplicate calls
    if (_isLoading) return;

    // Prevent refetch if data already exists
    if (!forceRefresh &&
        _newArrivals.isNotEmpty &&
        _hotProducts.isNotEmpty) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final re = await Dioclient.dio.get('/home/products');
      final res = re.data;

      if (re.statusCode == 200) {
        _newArrivals = (res['newArrivals'] as List)
            .map((item) => HomeProducts.fromJson(item))
            .toList();

        _hotProducts = (res['hotProducts'] as List)
            .map((item) => HomeProducts.fromJson(item))
            .toList();

        _topSellers = (res['topSellers'] as List)
            .map((item) => HomeProducts.fromJson(item))
            .toList();

        _topDiscounts = (res['topDiscounts'] as List)
            .map((item) => HomeProducts.fromJson(item))
            .toList();
      }
    } catch (e) {
      debugPrint("FetchProductsList error: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
