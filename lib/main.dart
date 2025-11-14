import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:product_bat/presentation/pages/cart/cart_page.dart';

import 'core/inject/depedency_injection.dart';
import 'core/utils/api_constant.dart';
import 'data/datasource/local/cart_item_adapter.dart';
import 'data/model/cart_item.dart';
import 'presentation/cubit/product_cubit.dart';
import 'presentation/cubit/splash_cubit.dart';
import 'presentation/pages/detail/detail_product_page.dart';
import 'presentation/pages/home/home_page.dart';
import 'presentation/pages/splashscreen/splashscreen_page.dart';

void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(CartItemAdapter());

  await Hive.openBox<CartItem>('cart');

  await init(ApiConstant.baseUrl);

  runApp(
    MultiBlocProvider(
      providers: [BlocProvider(create: (_) => SplashCubit()..start())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = GoRouter(
      initialLocation: '/home',

      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const SplashscreenPage(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => BlocProvider(
            create: (_) => sl<ProductCubit>()..getListProduct(),

            child: const HomePage(),
          ),
        ),
        GoRoute(
          path: '/detail-product',
          builder: (context, state) {
            final id = state.extra as int;
            return BlocProvider(
              create: (_) => sl<ProductCubit>()..detailProduct(id),
              child: DetailProductPage(),
            );
          },
        ),
        GoRoute(
          path: '/cart',
          builder: (context, state) {
            return CartPage();
          },
        ),
      ],
    );

    return MaterialApp.router(
      title: 'Shopp App',
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),

      routerConfig: appRouter,
    );
  }
}
