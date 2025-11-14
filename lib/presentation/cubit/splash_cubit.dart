import 'package:bloc/bloc.dart';

enum SplashStatus { initial, home, login }

class SplashCubit extends Cubit<SplashStatus> {
  SplashCubit() : super(SplashStatus.initial);
  void start() async {
    await Future.delayed(const Duration(seconds: 2));
    emit(SplashStatus.home);
  }

  void finishIntro() {
    emit(SplashStatus.login);
  }
}
