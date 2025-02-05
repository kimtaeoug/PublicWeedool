import 'dart:math';
import 'dart:developer' as developer;

import 'package:flutter/physics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weedool/components/wd_colors.dart';
import 'package:weedool/components/wd_text_style.dart';

// import 'package:weedool/models/chart/model_chart_daily.dart';
import 'package:weedool/models/chart/model_chart_monthly.dart';
import 'package:weedool/utils/logger.dart';

class CategoricalRadarChart extends StatefulWidget {
  final ChartMonthlyModel chartMonthlyModel;
  final bool lastStatus;
  final bool isDummy;

  // final Map<String, dynamic>? userCategoryData;

  const CategoricalRadarChart(
      {super.key,
      required this.chartMonthlyModel,
      required this.lastStatus,
      this.isDummy = false});

  @override
  State createState() => _CategoricalRadarChartState();
}

class _CategoricalRadarChartState extends State<CategoricalRadarChart> {
  final ChartMonthlyModel _dummy = ChartMonthlyModel(
      '',
      Data(
          1,
          '',
          [],
          0,
          0,
          [],
          MonthEmotionModel(0, 0, 0),
          MonthEmotionModel(0, 0, 0),
          CategoryModel(
              Random().nextInt(100),
              58,
              Random().nextInt(100),
              Random().nextInt(100),
              Random().nextInt(100),
              Random().nextInt(100)),
          CategoryModel(
              Random().nextInt(100),
              Random().nextInt(100),
              Random().nextInt(100),
              Random().nextInt(100),
              Random().nextInt(100),
              Random().nextInt(100)),
          CategoryModel(
              Random().nextInt(100),
              Random().nextInt(100),
              Random().nextInt(100),
              Random().nextInt(100),
              Random().nextInt(100),
              Random().nextInt(100))));

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
          height: 400,
          width: 400,
          child: Hexagon(
            screenWidth: screenWidth,
            chartMonthlyModel:
                widget.isDummy ? _dummy : widget.chartMonthlyModel,
            lastStatus: widget.lastStatus,
          )),
    );
  }
}

class Hexagon extends StatefulWidget {
  final double screenWidth;
  final ChartMonthlyModel chartMonthlyModel;
  final bool lastStatus;

  const Hexagon(
      {Key? key,
      required this.screenWidth,
      required this.chartMonthlyModel,
      required this.lastStatus})
      : super(key: key);

  @override
  State<Hexagon> createState() => _HexagonState();
}

class _HexagonState extends State<Hexagon> with SingleTickerProviderStateMixin {
  double get diameter => widget.screenWidth - 100;

  double get radius => diameter / 2.2;
  late AnimationController _controller;
  late Animation<double> _moderationAnimation,
      _cognitiveAnimation,
      _foodAnimation,
      _exerciseAnimation,
      _emotionAnimation,
      _practiceAnimation,
      _moderationAnimation2,
      _cognitiveAnimation2,
      _foodAnimation2,
      _exerciseAnimation2,
      _emotionAnimation2,
      _practiceAnimation2;

  // {절제: 2, 인지: 1, 정서: 2, 운동: 1, 음식: 1, 실천: 4}
  List<Rating> categories = [
    const Rating("음식", 39),
    const Rating("운동", 65),
    const Rating("정서", 88),
    const Rating("실천", 66),
    const Rating("절제", 43),
    const Rating("인지", 88)
  ];

  List<Rating> otherCategories = [
    const Rating("음식", 33),
    const Rating("운동", 50),
    const Rating("정서", 20),
    const Rating("실천", 44),
    const Rating("절제", 56),
    const Rating("인지", 67)
  ];

  // for monitoring list has 0 values
  bool listNullChecker(List listToCheck) {
    int result = listToCheck.reduce((a, b) => a + b);
    developer.log('$listToCheck');

    if (result == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool aastatus = false;

  @override
  void initState() {
    super.initState();
    // {"절제": 56,"인지": 12,"정서": 39,"운동": 33,"음식": 57,"실천": 83}

    /*
      절제 -> moderation
      인지 -> cognition
      정서 -> emotion
      운동 -> exercise
      음식 -> food
      실천 -> practice
    */

    setState(() {
      aastatus = widget.lastStatus;
      categories = [
        Rating("음식",
            widget.chartMonthlyModel.data.this_month_ba_category.food * 1),
        Rating("운동",
            widget.chartMonthlyModel.data.this_month_ba_category.exercise * 1),
        Rating("정서",
            widget.chartMonthlyModel.data.this_month_ba_category.emotion * 1),
        Rating("실천",
            widget.chartMonthlyModel.data.this_month_ba_category.practice * 1),
        Rating(
            "절제",
            widget.chartMonthlyModel.data.this_month_ba_category.moderation *
                1),
        Rating("인지",
            widget.chartMonthlyModel.data.this_month_ba_category.cognition * 1)
      ];

      otherCategories = [
        Rating(
            "음식",
            (widget.lastStatus
                    ? widget.chartMonthlyModel.data.last_month_ba_category.food
                    : widget.chartMonthlyModel.data.all_user_ba_category.food) *
                1),
        Rating(
            "운동",
            (widget.lastStatus
                    ? widget
                        .chartMonthlyModel.data.last_month_ba_category.exercise
                    : widget
                        .chartMonthlyModel.data.all_user_ba_category.exercise) *
                1),
        Rating(
            "정서",
            (widget.lastStatus
                    ? widget
                        .chartMonthlyModel.data.last_month_ba_category.emotion
                    : widget
                        .chartMonthlyModel.data.all_user_ba_category.emotion) *
                1),
        Rating(
            "실천",
            (widget.lastStatus
                    ? widget
                        .chartMonthlyModel.data.last_month_ba_category.practice
                    : widget
                        .chartMonthlyModel.data.all_user_ba_category.practice) *
                1),
        Rating(
            "절제",
            (widget.lastStatus
                    ? widget.chartMonthlyModel.data.last_month_ba_category
                        .moderation
                    : widget.chartMonthlyModel.data.all_user_ba_category
                        .moderation) *
                1),
        Rating(
            "인지",
            (widget.lastStatus
                    ? widget
                        .chartMonthlyModel.data.last_month_ba_category.cognition
                    : widget.chartMonthlyModel.data.all_user_ba_category
                        .cognition) *
                1)
      ];
    });

    print('this list : $categories');
    print('this last : $otherCategories');

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 750));
    _controller.forward();
    // {절제: 2, 인지: 1, 정서: 2, 운동: 1, 음식: 1, 실천: 4}

    // blue one
    _moderationAnimation =
        Tween<double>(begin: 0.0, end: categories[0].value / 100)
            .animate(_controller);
    _cognitiveAnimation =
        Tween<double>(begin: 0.0, end: categories[1].value / 100)
            .animate(_controller);
    _emotionAnimation =
        Tween<double>(begin: 0.0, end: categories[2].value / 100)
            .animate(_controller);
    _exerciseAnimation =
        Tween<double>(begin: 0.0, end: categories[3].value / 100)
            .animate(_controller);
    _foodAnimation = Tween<double>(begin: 0.0, end: categories[4].value / 100)
        .animate(_controller);
    _practiceAnimation =
        Tween<double>(begin: 0.0, end: categories[5].value / 100)
            .animate(_controller);

    // purple one
    _moderationAnimation2 =
        Tween<double>(begin: 0.0, end: otherCategories[0].value / 100)
            .animate(_controller);
    _cognitiveAnimation2 =
        Tween<double>(begin: 0.0, end: otherCategories[1].value / 100)
            .animate(_controller);
    _emotionAnimation2 =
        Tween<double>(begin: 0.0, end: otherCategories[2].value / 100)
            .animate(_controller);
    _exerciseAnimation2 =
        Tween<double>(begin: 0.0, end: otherCategories[3].value / 100)
            .animate(_controller);
    _foodAnimation2 =
        Tween<double>(begin: 0.0, end: otherCategories[4].value / 100)
            .animate(_controller);
    _practiceAnimation2 =
        Tween<double>(begin: 0.0, end: otherCategories[5].value / 100)
            .animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(fit: StackFit.expand, children: [
      Labels(radius: radius, diameter: diameter, rating: categories),
      Padding(
          padding: const EdgeInsets.all(50),
          child: CustomPaint(painter: HexagonPainter(radius: radius))),
      AnimatedBuilder(
        animation: _controller,
        builder: (context, widget) => ClipPath(
          clipper: HexagonClipper(radius: radius, multipliers: [
            _moderationAnimation.value,
            _cognitiveAnimation.value,
            _foodAnimation.value,
            _exerciseAnimation.value,
            _emotionAnimation.value,
            _practiceAnimation.value
          ]),
          child: SizedBox(
              width: diameter,
              height: diameter,
              child: ColoredBox(
                color: aastatus
                    ? const Color(0xFF599434).withOpacity(0.45)
                    : const Color(0xFF6C1CD3).withOpacity(0.45),
              )),
        ),
      ),
      AnimatedBuilder(
        animation: _controller,
        builder: (context, widget) => ClipPath(
          clipper: HexagonClipper(radius: radius, multipliers: [
            _moderationAnimation2.value,
            _cognitiveAnimation2.value,
            _foodAnimation2.value,
            _exerciseAnimation2.value,
            _emotionAnimation2.value,
            _practiceAnimation2.value
          ]),
          child: SizedBox(
              width: diameter,
              height: diameter,
              child: ColoredBox(
                color: const Color(0xFF41A7D7).withOpacity(0.4),
              )),
        ),
      ),
    ]);
  }
}

class HexagonClipper extends CustomClipper<Path> {
  final double radius;
  final List<double> multipliers;

  HexagonClipper({required this.radius, required this.multipliers});

  @override
  Path getClip(Size size) {
    final center = Offset(size.width / 2, size.width / 2);
    final Path path = Path();
    final angleMul = [1, 3, 5, 7, 9, 11];

    path.addPolygon([
      for (int i = 0; i < 6; i++)
        Offset(
          radius * multipliers[i] * cos(pi * 2 * (angleMul[i] * 30) / 360) +
              center.dx,
          radius * multipliers[i] * sin(pi * 2 * (angleMul[i] * 30) / 360) +
              center.dy,
        )
    ], true);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class Labels extends StatelessWidget {
  const Labels(
      {Key? key,
      required this.radius,
      required this.diameter,
      required this.rating})
      : super(key: key);

  final double radius, diameter;
  final List<Rating> rating;

  @override
  Widget build(BuildContext context) {
    // position value for labels
    final center = Offset(diameter / 1.60, diameter / 1.55);
    // style for labels
    // final style = Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w400, fontSize: 16);
    final style = AppTextStyles.body6(WDColors.black);
    const textAlign = TextAlign.center;

    return Stack(children: [
      Positioned.fromRect(
          rect: Rect.fromCenter(
            center: Offset(
              radius * cos(pi * 2 * 30 / 360) + center.dx + 30,
              radius * sin(pi * 2 * 30 / 360) + center.dy,
            ),
            width: 100,
            height: 40,
          ),
          child: Center(
              child: Column(children: [
            Text(rating[0].name, textAlign: textAlign, style: style),
//                   Text(rating[0].value.toString(),
//                        textAlign: textAlign,
//                        style: style),
          ]))),
      Positioned.fromRect(
          rect: Rect.fromCenter(
            center: Offset(
              radius * cos(pi * 2 * 90 / 360) + center.dx - 10,
              radius * sin(pi * 2 * 90 / 360) + center.dy + 30,
            ),
            width: 100,
            height: 40,
          ),
          child: Center(
              child: Column(children: [
            Text(rating[1].name, textAlign: textAlign, style: style),
          ]))),
      Positioned.fromRect(
          rect: Rect.fromCenter(
            center: Offset(
              radius * cos(pi * 2 * 150 / 360) + center.dx - 40,
              radius * sin(pi * 2 * 150 / 360) + center.dy,
            ),
            width: 100,
            height: 40,
          ),
          child: Center(
              child: Column(children: [
            Text(rating[2].name, textAlign: textAlign, style: style),
          ]))),
      Positioned.fromRect(
          rect: Rect.fromCenter(
            center: Offset(
              radius * cos(pi * 2 * 210 / 360) + center.dx - 40,
              radius * sin(pi * 2 * 210 / 360) + center.dy,
            ),
            width: 100,
            height: 40,
          ),
          child: Center(
              child: Column(children: [
            Text(rating[3].name, textAlign: textAlign, style: style),
          ]))),
      Positioned.fromRect(
          rect: Rect.fromCenter(
            center: Offset(
              radius * cos(pi * 2 * 270 / 360) + center.dx - 10,
              radius * sin(pi * 2 * 270 / 360) + center.dy - 30,
            ),
            width: 100,
            height: 40,
          ),
          child: Center(
              child: Column(children: [
            Text(rating[4].name, textAlign: textAlign, style: style),
          ]))),
      Positioned.fromRect(
          rect: Rect.fromCenter(
            center: Offset(radius * cos(pi * 2 * 330 / 360) + center.dx + 30,
                radius * sin(pi * 2 * 330 / 360) + center.dy),
            width: 100,
            height: 40,
          ),
          child: Center(
              child: Column(children: [
            Text(rating[5].name, textAlign: textAlign, style: style),
          ]))),
    ]);
  }
}

class HexagonPainter extends CustomPainter {
  HexagonPainter({required this.radius});

  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    // Define the radius of the circle
    final radius = min(size.width / 2, size.height / 2);

    // Calculate the angle between each line
    const angleBetweenLines = pi / 3; // 15 degrees in radians

    // Set the paint style for lines
    final Paint paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 0.3;

    Paint borderPaint = Paint()
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..color = Colors.grey.withOpacity(0.5)
      ..strokeWidth = 1.0;

    final center = Offset(size.width / 2, size.width / 2);
    final angleMul = [1, 3, 5, 7, 9, 11, 1];

    for (int i = 0; i < 24; i++) {
      final angle = i * angleBetweenLines - 10.992;
      final dx = center.dx + radius * cos(angle);
      final dy = center.dy + radius * sin(angle);
      final endPoint = Offset(dx, dy);
      canvas.drawLine(center, endPoint, paint);
    }

    for (int j = 1; j <= 4; j++) {
      for (int i = 0; i < 6; i++) {
        canvas.drawLine(
            Offset(
                j / 4 * radius * cos(pi * 2 * (angleMul[i] * 30 / 360)) +
                    center.dx,
                j / 4 * radius * sin(pi * 2 * (angleMul[i] * 30 / 360)) +
                    center.dy),
            Offset(
              j / 4 * radius * cos(pi * 2 * (angleMul[i + 1] * 30 / 360)) +
                  center.dx,
              j / 4 * radius * sin(pi * 2 * (angleMul[i + 1] * 30 / 360)) +
                  center.dy,
            ),
            borderPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class PhysicsCardDragDemo extends StatelessWidget {
  const PhysicsCardDragDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('A draggable card!'),
      ),
      body: const DraggableCard(
        child: FlutterLogo(
          size: 18,
        ),
      ),
    );
  }
}

class DraggableCard extends StatefulWidget {
  final Widget child;

  const DraggableCard({super.key, required this.child});

  @override
  State<DraggableCard> createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Alignment _dragAlignment = Alignment.center;
  Animation<Alignment>? _animation;

  void _runAnimation(Offset pixelsPerSecond, Size size) {
    _animation = _controller!.drive(
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment.center,
      ),
    );

    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);
    _controller!.animateWith(simulation);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller!.addListener(() {
      setState(() {
        _dragAlignment = _animation!.value;
      });
    });
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onPanDown: (details) {
        _controller!.stop();
      },
      onPanUpdate: (details) {
        setState(() {
          _dragAlignment += Alignment(
            details.delta.dx / (size.width / 2),
            details.delta.dy / (size.height / 2),
          );
        });
      },
      onPanEnd: (details) {
        _runAnimation(details.velocity.pixelsPerSecond, size);
      },
      child: Align(
        alignment: _dragAlignment,
        child: Card(
          child: widget.child,
        ),
      ),
    );
  }
}

class Rating {
  final String name;
  final int value;

  const Rating(this.name, this.value);
}
