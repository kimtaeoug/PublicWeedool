// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:weedool/component/wd_activity_item.dart';
// import 'package:weedool/components/wd_colors.dart';
// import 'package:weedool/controllers/activity/activity_controller.dart';
// import 'package:weedool/utils/logger.dart';
// import 'package:weedool/utils/text_style.dart';
// import 'package:weedool/views/activity/activity_time_slot.dart';
//
// class ActivityCoachMark extends StatelessWidget {
//   ActivityCoachMark({Key? key}) : super(key: key);
//
//   final ActivityController controller = ActivityController();
//
//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;
//     return Container(
//       width: size.width,
//       height: size.height,
//       color: Colors.black.withOpacity(0.7),
//       child: Stack(
//         children: [
//           ValueListenableBuilder(
//               valueListenable: controller.closeOffset,
//               builder: (_, value, child) {
//                 return Positioned(
//                     top: value.dy,
//                     left: value.dx,
//                     child: _closeBtn);
//                 // return Positioned(child: Padding(
//                 //     padding: EdgeInsets.only(top: value.dy, left: 33),
//                 //     // top: value.dy - 15,
//                 //     // left: 33,
//                 //     child: _closeBtn), top: 0, left: 0,);
//               }),
//           // ValueListenableBuilder(
//           //     valueListenable: controller.btnOffset,
//           //     builder: (_, value, child) {
//           //       return Positioned(
//           //           top: 0,
//           //           left: 0,
//           //           // top: value.dy-27,
//           //           // left: value.dx-15,
//           //           child: Padding(
//           //             padding: EdgeInsets.only(top: value.dy, left: value.dx),
//           //             child: _arrow,
//           //           ));
//           //     }),
//           // ValueListenableBuilder(
//           //     valueListenable: controller.timeSlotOffset,
//           //     builder: (_, value, child) {
//           //       return Positioned(child: ActivityTimeSlot());
//           //     }),
//           // ValueListenableBuilder(
//           //     valueListenable: controller.dailyOffset,
//           //     builder: (_, value, child) {
//           //       return Positioned(child: _dailyItem);
//           //     })
//         ],
//       ),
//     );
//
//     //ic_arrow_right
//     //ic_arrow_bottom_to_top
//     //ic_arrow_top_to_bottom
//     //ic_close_white
//   }
//
//   final TextStyle _style = const TextStyle(
//     fontFamily: 'GangwonEduSaeeum',
//     fontSize: 22,
//     color: Colors.white,
//     letterSpacing: -0.5,
//   );
//   final Widget _closeBtn = SizedBox(
//     height: 26,
//     child: Center(
//       child: SizedBox(
//         width: 16,
//         height: 16,
//         child: Image.asset('assets/images/ic_close_white.png'),
//       ),
//     ),
//   );
//   late final Widget _day = Column(
//     mainAxisAlignment: MainAxisAlignment.start,
//     crossAxisAlignment: CrossAxisAlignment.start,
//     mainAxisSize: MainAxisSize.min,
//     children: [
//       SizedBox(
//         width: 32,
//         child: Image.asset(
//           'assets/images/ic_arrow_bottom_to_top.png',
//           fit: BoxFit.fitWidth,
//         ),
//       ),
//       Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           SizedBox(
//             width: 32,
//             child: Image.asset(
//               'assets/images/ic_arrow_bottom_to_top.png',
//               fit: BoxFit.fitWidth,
//             ),
//           ),
//           Container(
//             width: 32,
//             height: 32,
//             decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(color: Colors.white),
//                 color: WDColors.primaryColor),
//             child: Center(
//               child: Text(
//                 '3',
//                 style: Styler.style(
//                   fontSize: 15,
//                   letterSpacing: -0.5,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           )
//         ],
//       )
//     ],
//   );
//   late final Widget _arrow = Column(
//     mainAxisAlignment: MainAxisAlignment.start,
//     crossAxisAlignment: CrossAxisAlignment.start,
//     mainAxisSize: MainAxisSize.min,
//     children: [            Container(
//         width: 40,
//         height: 40,
//         decoration: BoxDecoration(
//             shape: BoxShape.circle, color: WDColors.primaryColor),
//         child: Center(
//           child: SizedBox(
//             width: 13,
//             height: 18,
//             child: Image.asset(
//                 'assets/images/ic_activity_arrow_bottom.png'),
//           ),
//         )),
//
//       // SizedBox(
//       //   width: 32,
//       //   child: Image.asset(
//       //     'assets/images/ic_arrow_right.png',
//       //     fit: BoxFit.fitWidth,
//       //   ),
//       // ),
//       // SizedBox(
//       //   height: 40,
//       //   child: Row(
//       //     mainAxisAlignment: MainAxisAlignment.center,
//       //     crossAxisAlignment: CrossAxisAlignment.start,
//       //     children: [
//       //       Container(
//       //           width: 40,
//       //           height: 40,
//       //           decoration: BoxDecoration(
//       //               shape: BoxShape.circle, color: WDColors.primaryColor),
//       //           child: Center(
//       //             child: SizedBox(
//       //               width: 13,
//       //               height: 18,
//       //               child: Image.asset(
//       //                   'assets/images/ic_activity_arrow_bottom.png'),
//       //             ),
//       //           )),
//       //       const SizedBox(
//       //         width: 20,
//       //       ),
//       //       Text(
//       //         '밑으로 내려서 달력보기',
//       //         style: _style,
//       //       )
//       //     ],
//       //   ),
//       // )
//     ],
//   );
//
//   //F-3
//   final Widget _dailyItem = Column(
//     mainAxisAlignment: MainAxisAlignment.start,
//     crossAxisAlignment: CrossAxisAlignment.start,
//     mainAxisSize: MainAxisSize.min,
//     children: [
//       WDActivityItem(
//           isDone: false,
//           imgUrl:
//               'https://weedool-app-mvp.s3.ap-northeast-2.amazonaws.com/icon/ba/F-3.png',
//           timeTag: '무관',
//           category: '음식',
//           activity: '일어나자마자 물 마시기')
//     ],
//   );
// }
