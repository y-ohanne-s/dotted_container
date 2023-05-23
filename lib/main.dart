import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  bool show = false;

  final Color g1 = const Color.fromRGBO(98, 0, 234, 1);
  final Color g2 = const Color.fromRGBO(236, 64, 122, 1);
  final Color g3 = const Color.fromRGBO(253, 216, 53, 1);

  late AnimationController _controller;
  late Animation<List<double>> _animation;

  final List<double> _stops = [1, 0, 0, 0];

  void onTapped() {
    setState(() => show = !show);

    if (show) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _animation = ListDoubleTween(
      begin: _stops,
      end: [0.0, 0.5, 0.7, 0.9],
    ).animate(_controller)
      ..addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(10, 10, 10, 1),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            DottedBackgroundContainer(
              height: 600,
              width: 350,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                border: !show
                    ? const Border.fromBorderSide(
                        BorderSide(
                          color: Color.fromRGBO(3, 169, 244, 1),
                          width: 1,
                        ),
                      )
                    : null,
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                child: Text(
                  'I know exactly what I\'m doing',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: onTapped,
              onHover: (val) {
                onTapped();
              },
              child: Container(
                height: 620,
                width: 370,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.transparent,
                      g1.withOpacity(0.7),
                      g2.withOpacity(0.7),
                      g3.withOpacity(0.7),
                    ],
                    stops: _animation.value,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DottedBackgroundContainer extends StatelessWidget {
  final Widget? child;
  final Color dotColor;
  final AlignmentGeometry? alignment;
  final double? width;
  final double? height;
  final Color? color;
  final Decoration? decoration;
  final Decoration? foregroundDecoration;
  final BoxConstraints? constraints;
  final Matrix4? transform;
  final AlignmentGeometry? transformAlignment;
  final Clip clipBehavior;

  const DottedBackgroundContainer({
    super.key,
    this.child,
    this.dotColor = const Color.fromRGBO(255, 255, 255, 0.2),
    this.alignment,
    this.width,
    this.height,
    this.color,
    this.decoration,
    this.foregroundDecoration,
    this.constraints,
    this.transform,
    this.transformAlignment,
    this.clipBehavior = Clip.none,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      height: height,
      width: width,
      decoration: decoration,
      alignment: alignment,
      clipBehavior: clipBehavior,
      constraints: constraints,
      foregroundDecoration: foregroundDecoration,
      transform: transform,
      transformAlignment: transformAlignment,
      child: CustomPaint(
        size: MediaQuery.of(context).size,
        painter: DottedPainter(
          color: dotColor,
        ),
        child: child,
      ),
    );
  }
}

class DottedPainter extends CustomPainter {
  final Color color;
  DottedPainter({this.color = const Color.fromRGBO(3, 169, 244, 1)});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    const spacing = 20.0;
    for (var x = 6.0; x < size.width; x += spacing) {
      for (var y = 8.0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(DottedPainter oldDelegate) => false;
}

class ListDoubleTween extends Tween<List<double>> {
  ListDoubleTween({required List<double> begin, required List<double> end})
      : super(begin: begin, end: end);

  @override
  List<double> lerp(double t) {
    return List<double>.generate(
      begin!.length,
      (index) => lerpDouble(begin![index], end![index], t),
    );
  }

  double lerpDouble(double a, double b, double t) {
    return a + (b - a) * t;
  }
}
