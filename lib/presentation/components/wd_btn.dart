import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weedool/components/wd_colors.dart';
import 'package:weedool/utils/text_style.dart';

class WDBtn extends StatelessWidget {
  final String text;
  final double width;
  final double height;
  final Function() function;
  final Color color;
  final Color disabledColor;
  final double horizontalPadding;
  final double verticalPadding;
  final String? otherText;
  final Color? textColor;
  final Color? borderColor;

  WDBtn(
      {Key? key,
        required this.text,
        required this.width,
        required this.height,
        required this.function,
        this.color = WDColors.primaryColor,
        this.disabledColor = WDColors.assitive,
        this.horizontalPadding = 20,
        this.verticalPadding = 0,
        this.otherText,
        this.textColor,
        this.borderColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: key,
      padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding, vertical: verticalPadding),
      child: GestureDetector(
        onTap: function,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              border: borderColor != null
                  ? Border.all(color: borderColor ?? Colors.transparent)
                  : null),
          child: Center(
            child: Text(
              text,
              style: Styler.style(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                  color: textColor ?? WDColors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class WDDialogLeftBtn extends StatelessWidget {
  final double width;
  final String text;

  const WDDialogLeftBtn({
    Key? key,
    required this.width,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 52,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 0.2,
                blurRadius: 3)
          ]),
      child: Center(
        child: Text(
          text,
          style: Styler.style(
              fontSize: 16, fontWeight: FontWeight.w600, height: 1.5),
        ),
      ),
    );
  }
}

class WDDialogRightBtn extends StatelessWidget {
  final double width;
  final String text;

  const WDDialogRightBtn({
    Key? key,
    required this.width,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 52,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        color: WDColors.primaryColor,
      ),
      child: Center(
        child: Text(
          text,
          style: Styler.style(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.5,
              color: Colors.white),
        ),
      ),
    );
  }
}
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:weedool/components/wd_colors.dart';
// import 'package:weedool/utils/text_style.dart';
//
// class WDBtn extends StatefulWidget {
//   final String text;
//   final double width;
//   final double height;
//   final Function() function;
//   final Color color;
//   final Color disabledColor;
//   final double horizontalPadding;
//   final double verticalPadding;
//   final String? otherText;
//   final Color? textColor;
//   final Color? borderColor;
//
//   WDBtn(
//       {Key? key,
//       required this.text,
//       required this.width,
//       required this.height,
//       required this.function,
//       this.color = WDColors.primaryColor,
//       this.disabledColor = WDColors.assitive,
//       this.horizontalPadding = 20,
//       this.verticalPadding = 0,
//       this.otherText,
//       this.textColor,
//       this.borderColor})
//       : super(key: key);
//
//   @override
//   State<StatefulWidget> createState() => _WDBtn();
// }
//
// class _WDBtn extends State<WDBtn> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (mounted) {
//         setState(() {
//           _nowTapDown = false;
//         });
//       }
//     });
//   }
//
//   bool _nowTapDown = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: widget.width,
//       height: widget.height,
//       child: Center(
//         child: Padding(
//           padding: EdgeInsets.symmetric(
//               horizontal: _nowTapDown
//                   ? widget.horizontalPadding * 1.6
//                   : widget.horizontalPadding,
//               vertical: widget.verticalPadding),
//           child: GestureDetector(
//             onTap: widget.function,
//             onPanEnd: (_) {
//               setState(() {
//                 _nowTapDown = false;
//               });
//             },
//             onPanDown: (_) {
//               setState(() {
//                 _nowTapDown = true;
//               });
//             },
//             onTapDown: (_) {
//               setState(() {
//                 _nowTapDown = true;
//               });
//             },
//             onTapUp: (_) {
//               setState(() {
//                 _nowTapDown = true;
//               });
//             },
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 100),
//               width: _nowTapDown ? widget.width * 0.92 : widget.width,
//               height: _nowTapDown ? widget.height * 0.92 : widget.height,
//               decoration: BoxDecoration(
//                   color: widget.color,
//                   borderRadius: const BorderRadius.all(Radius.circular(12)),
//                   border: widget.borderColor != null
//                       ? Border.all(
//                           color: widget.borderColor ?? Colors.transparent)
//                       : null),
//               child: Center(
//                 child: Text(
//                   widget.text,
//                   style: Styler.style(
//                       fontSize: _nowTapDown ? 16 * 0.92 : 16,
//                       fontWeight: FontWeight.w600,
//                       height: 1.5,
//                       color: widget.textColor ?? WDColors.white),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class WDDialogLeftBtn extends StatelessWidget {
//   final double width;
//   final String text;
//
//   const WDDialogLeftBtn({
//     Key? key,
//     required this.width,
//     required this.text,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: width,
//       height: 52,
//       decoration: BoxDecoration(
//           borderRadius: const BorderRadius.all(Radius.circular(12)),
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 spreadRadius: 0.2,
//                 blurRadius: 3)
//           ]),
//       child: Center(
//         child: Text(
//           text,
//           style: Styler.style(
//               fontSize: 16, fontWeight: FontWeight.w600, height: 1.5),
//         ),
//       ),
//     );
//   }
// }
//
// class WDDialogRightBtn extends StatelessWidget {
//   final double width;
//   final String text;
//
//   const WDDialogRightBtn({
//     Key? key,
//     required this.width,
//     required this.text,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: width,
//       height: 52,
//       decoration: const BoxDecoration(
//         borderRadius: BorderRadius.all(Radius.circular(12)),
//         color: WDColors.primaryColor,
//       ),
//       child: Center(
//         child: Text(
//           text,
//           style: Styler.style(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               height: 1.5,
//               color: Colors.white),
//         ),
//       ),
//     );
//   }
// }
