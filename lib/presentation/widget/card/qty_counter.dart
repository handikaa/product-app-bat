import 'package:flutter/material.dart';

class QtyCounter extends StatelessWidget {
  final int value;
  final VoidCallback onAdd;
  final VoidCallback onMin;

  const QtyCounter({
    super.key,
    required this.value,
    required this.onAdd,
    required this.onMin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onMin,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Text(
                "-",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              "$value",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),

          GestureDetector(
            onTap: onAdd,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Text(
                "+",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
