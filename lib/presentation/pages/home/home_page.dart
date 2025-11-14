import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:product_bat/presentation/cubit/product_cubit.dart';

import '../../../core/config/assets.dart';
import '../../../domain/entities/product_entity.dart';
import '../../widget/card/product_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController searchController = TextEditingController();
  List<ProductEntity> displayedProducts = [];

  void _onSearch(String query, List<ProductEntity> allProducts) {
    if (query.isEmpty) {
      setState(() => displayedProducts = allProducts);
    } else {
      setState(() {
        displayedProducts = allProducts
            .where(
              (p) =>
                  p.title.toLowerCase().contains(query.toLowerCase()) ||
                  p.category.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(6),
              child: Row(
                children: [
                  Expanded(flex: 4, child: _buildSearchBox()),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () => context.push('/cart'),
                      child: Icon(Icons.shopping_cart),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: BlocConsumer<ProductCubit, ProductState>(
                listener: (context, state) {
                  if (state is ListProductLoaded) {
                    displayedProducts = state.products;
                  }
                },
                builder: (context, state) {
                  if (state is ListProductLoading) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LottieBuilder.asset(LottieAssets.loading, width: 150),
                          Text("Please Wait..."),
                        ],
                      ),
                    );
                  }

                  if (state is ListProductError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  if (state is ListProductLoaded) {
                    if (displayedProducts.isEmpty) {
                      return const Center(child: Text("No products found"));
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.only(top: 10),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisExtent: 250,

                            mainAxisSpacing: 12,
                          ),
                      itemCount: displayedProducts.length,
                      itemBuilder: (context, index) {
                        final product = displayedProducts[index];
                        return GestureDetector(
                          onTap: () {
                            context.push('/detail-product', extra: product.id);
                          },
                          child: Container(
                            margin: EdgeInsets.all(8),
                            child: ProductCard(product: product),
                          ),
                        );
                      },
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 48,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: searchController,
              onChanged: (q) {
                final cubit = context.read<ProductCubit>();
                if (cubit.state is ListProductLoaded) {
                  final data = (cubit.state as ListProductLoaded).products;
                  _onSearch(q, data);
                }
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Search...",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
