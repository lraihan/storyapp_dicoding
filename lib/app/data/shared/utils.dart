import 'package:flutter/material.dart';
class Layouter extends StatelessWidget {
  final double? height;
  final double? width;
  final Widget? child;
  const Layouter({super.key, this.height, this.width, this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all()),
      width: width,
      height: height,
      child: child,
    );
  }
}
