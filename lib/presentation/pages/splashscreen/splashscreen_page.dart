import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:product_bat/core/config/assets.dart';

import '../../cubit/splash_cubit.dart';

class SplashscreenPage extends StatelessWidget {
  const SplashscreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashStatus>(
      listener: (context, state) {
        if (state == SplashStatus.home) {
          context.go('/home');
        } else if (state == SplashStatus.login) {
          context.go('/login');
        }
      },
      child: Scaffold(
        body: Center(
          child: LottieBuilder.asset(LottieAssets.shoppChart, width: 200),
        ),
      ),
    );
  }
}
