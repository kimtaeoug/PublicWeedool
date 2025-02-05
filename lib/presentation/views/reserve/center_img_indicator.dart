import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class CenterImgIndicator extends StatelessWidget {
  final int length;
  final int selected;

  CenterImgIndicator({super.key, required this.length, required this.selected});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: 7,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(length + 1, (idx) => _item(idx)),
      ),
    );
  }

  Widget _item(int idx) {
    return Padding(
      padding: EdgeInsets.only(left: idx == 0 ? 0 : 8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: idx == selected ? 28 : 7,
        height: 7,
        decoration: idx == selected
            ? BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: const BorderRadius.all(Radius.circular(20)))
            : BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: const BorderRadius.all(Radius.circular(100))),
      ),
    );
  }
}
