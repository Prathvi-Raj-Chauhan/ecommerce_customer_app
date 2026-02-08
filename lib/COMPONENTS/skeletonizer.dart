import 'package:ecommerce_customer/MODELS/HomeProducts.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  HomeProducts prod = new HomeProducts.fromJson({
      "id" : "asdfasdfa",
      "brand": BoneMock.title,
      
      "discountedPrice":  100,
      "discountPercent": 50.0,
      "name": BoneMock.name,
      "price": 200,
      "rating": 5
  });
  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enableSwitchAnimation: true,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _section('title', prod),
            _section('title', prod),
            _section('title', prod),
            _section('title', prod),
          ],
        ),
      ),
    );
  }
   Widget _section(String title, HomeProducts homeprods) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children:
              [
                _productCard(homeprods),
                _productCard(homeprods),
                _productCard(homeprods),
                _productCard(homeprods),
                _productCard(homeprods),
              ]
            
          ),
        ),
      ],
    );
  }
  Widget _productCard(HomeProducts product) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        height: 300,
        width: 200,
        child: Column(
          children: [
            // 60% Image placeholder
            Expanded(
              flex: 6,
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: const Icon(Icons.image, size: 140, color: Colors.grey),
              ),
            ),

            // 40% Product details
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      product.name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      product.brand,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunito(
                        color: Colors.grey,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          '₹${product.price}',
                          style: GoogleFonts.nunito(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.red,
                          ),
                        ),
                        Text(
                          '-${product.discountPercent}',
                          style: GoogleFonts.nunito(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,

                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '₹${product.discountedPrice}',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}
