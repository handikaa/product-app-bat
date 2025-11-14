import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:product_bat/core/config/assets.dart';
import 'package:product_bat/domain/entities/product_entity.dart';
import 'package:product_bat/presentation/widget/card/qty_counter.dart';

import '../../../data/model/cart_item.dart';
import '../../cubit/product_cubit.dart';

class DetailProductPage extends StatefulWidget {
  const DetailProductPage({super.key});

  @override
  State<DetailProductPage> createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
  int countQty = 1;

  void addToCart(BuildContext context, CartItem item) {
    final box = Hive.box<CartItem>('cart');
    box.add(item);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          "Product successfully added to cart!",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double maxH = MediaQuery.of(context).size.height;
    double maxW = MediaQuery.of(context).size.width;
    return Scaffold(
      bottomNavigationBar: _buildAddtoCartButton(),
      body: SingleChildScrollView(
        child: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return SizedBox(
                height: maxH,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      LottieBuilder.asset(LottieAssets.loading, width: 150),
                      Text("Please Wait..."),
                    ],
                  ),
                ),
              );
            }

            if (state is ProductLoaded) {
              ProductEntity data = state.data;
              return Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: maxH * 0.5,
                        width: double.infinity,

                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(data.image),
                          ),
                        ),
                      ),

                      SafeArea(
                        child: Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () => context.pop(),
                                  child: Icon(Icons.arrow_back),
                                ),
                                Spacer(),
                                GestureDetector(
                                  onTap: () => context.push('/cart'),
                                  child: Icon(Icons.shopping_cart),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Container(
                    width: double.infinity,
                    transform: Matrix4.translationValues(0, -30, 0),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(32),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 6,
                          offset: const Offset(0, -3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),

                        const SizedBox(height: 8),
                        Text(
                          data.category,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        QtyCounter(
                          value: countQty,
                          onAdd: () {
                            setState(() {
                              countQty++;
                            });
                          },
                          onMin: () {
                            if (countQty > 1) {
                              setState(() {
                                countQty--;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            RatingBarIndicator(
                              rating: data.ratingEntity.rate,
                              itemCount: 5,
                              itemSize: 18,
                              itemBuilder: (_, __) =>
                                  const Icon(Icons.star, color: Colors.amber),
                            ),
                            SizedBox(width: 10),
                            Text("(${data.ratingEntity.count}) Reviews"),
                          ],
                        ),

                        const SizedBox(height: 20),

                        Text(
                          "Description",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          data.description,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 400),
                      ],
                    ),
                  ),
                ],
              );
            }

            return SizedBox.shrink();
          },
        ),
      ),
    );
  }

  BlocBuilder<ProductCubit, ProductState> _buildAddtoCartButton() {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        if (state is ProductLoaded) {
          ProductEntity data = state.data;
          return SafeArea(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      "\$${data.price}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 23,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),

                  Expanded(
                    flex: 4,
                    child: GestureDetector(
                      onTap: () {
                        double totalPrice = data.price * countQty;

                        CartItem item = CartItem(
                          id: data.id,
                          title: data.title,
                          image: data.image,
                          price: totalPrice,
                          qty: countQty,
                        );

                        addToCart(context, item);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.shopping_bag_outlined,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Add to cart",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
