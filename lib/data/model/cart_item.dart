class CartItem {
  final int id;
  final String title;
  final String image;
  final double price;
  int qty;

  CartItem({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    required this.qty,
  });
}
