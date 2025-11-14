class LottieAssets {
  static const _base = 'assets/lotties';

  static String path(String name) {
    return '$_base/$name.json';
  }

  static final shoppChart = path('shopping cart');
  static final loading = path('loading');
}
