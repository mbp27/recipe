import 'package:flutter/material.dart';

class ImageError extends StatelessWidget {
  const ImageError({
    Key? key,
    this.size,
  }) : super(key: key);

  final double? size;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.error,
          size: size ?? MediaQuery.of(context).size.width / 12,
        ),
        const SizedBox(height: 4.0),
        const Text('Error'),
      ],
    );
  }
}
