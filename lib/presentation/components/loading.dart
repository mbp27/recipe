import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum LoadingSize { verySmall, small, normal }

class Loading extends StatelessWidget {
  const Loading({
    Key? key,
    this.size = LoadingSize.normal,
    this.color,
  }) : super(key: key);

  final LoadingSize size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final sized = size == LoadingSize.verySmall
        ? 12.0
        : size == LoadingSize.small
            ? 24.0
            : null;

    return Platform.isIOS
        ? CupertinoActivityIndicator(color: color)
        : SizedBox(
            width: sized,
            height: sized,
            child: CircularProgressIndicator(color: color),
          );
  }
}
