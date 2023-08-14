import 'package:flutter/material.dart';

class NoImage extends StatelessWidget {
  const NoImage({
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
          Icons.image_not_supported_outlined,
          size: size ?? MediaQuery.of(context).size.width / 12,
        ),
        const SizedBox(height: 4.0),
        const Text('No Image'),
      ],
    );
  }
}
