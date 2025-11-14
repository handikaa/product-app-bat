import 'package:hive/hive.dart';

import '../../model/cart_item.dart';

class CartItemAdapter extends TypeAdapter<CartItem> {
  @override
  final int typeId = 1;

  @override
  CartItem read(BinaryReader reader) {
    return CartItem(
      id: reader.readInt(),
      title: reader.readString(),
      image: reader.readString(),
      price: reader.readDouble(),
      qty: reader.readInt(),
    );
  }

  @override
  void write(BinaryWriter writer, CartItem obj) {
    writer.writeInt(obj.id);
    writer.writeString(obj.title);
    writer.writeString(obj.image);
    writer.writeDouble(obj.price);
    writer.writeInt(obj.qty);
  }
}
