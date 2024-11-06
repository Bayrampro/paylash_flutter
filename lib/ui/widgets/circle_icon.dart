import 'package:flutter/material.dart';

class CircleIcon extends StatelessWidget {
  const CircleIcon({
    super.key,
    required this.imageUrl,
    required this.color,
    required this.size,
  });

  final String imageUrl;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: size,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(150),
            color: color,
          ),
          child: Image.asset(
            imageUrl,
            width: size,
            height: size,
          ),
        ),
      ),
    );
  }
}
