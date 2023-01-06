import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _scaleController;
  final int numberOfStars = kDebugMode ? 50 : 200;
  final _slideDuration = const Duration(
    seconds: 16,
  );
  final _scaleDuration = const Duration(
    milliseconds: 2000,
  );
  StreamController<Offset> controller = StreamController();

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: _slideDuration,
    )..repeat(
        reverse: false,
        min: 0.0,
        max: 1.0,
      );
    _scaleController = AnimationController(
      vsync: this,
      duration: _scaleDuration,
    )..repeat(
        reverse: true,
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MouseRegion(
        cursor: SystemMouseCursors.none,
        onHover: (event) {
          controller.add(event.position);
        },
        child: Stack(
          children: [
            _buildBackground(),
            ..._buildStars(context),
            StreamBuilder(
              stream: controller.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Positioned(
                    left: snapshot.data!.dx,
                    top: snapshot.data!.dy,
                    child: Transform.rotate(
                      angle: -pi / 2,
                      child: Lottie.asset(
                        'assets/lottie/rocket.json',
                        fit: BoxFit.fitWidth,
                        width: 60,
                        height: 60,
                        repeat: true,
                        reverse: true,
                      ),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
            // _buildNameCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.black,
    );
  }

  List<Widget> _buildStars(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final random = Random();
    List<Widget> stars = List.generate(
      numberOfStars,
      (index) {
        final xPosition = random.nextInt(width.toInt()).toDouble();
        final yPosition = random.nextInt(height.toInt()).toDouble();
        return AnimatedBuilder(
          animation: _slideController,
          builder: (
            context,
            child,
          ) {
            return Positioned(
              left: getLeftPosition(
                x: xPosition,
                width: width,
                animationValue: _slideController.value,
              ),
              top: yPosition,
              child: AnimatedBuilder(
                animation: _scaleController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: getScaleValue(index: index),
                    child: child!,
                  );
                },
                child: child!,
              ),
            );
          },
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: kElevationToShadow[1],
            ),
          ),
        );
      },
    );
    return stars;
  }

  double getLeftPosition({
    required double width,
    required double x,
    required double animationValue,
  }) {
    if (animationValue <= 0.0) {
      return x;
    } else {
      final position = x + (width * animationValue);
      if (position >= width) {
        return position - width;
      } else {
        return position;
      }
    }
  }

  double getScaleValue({
    required int index,
  }) {
    if (index % 2 == 0) {
      return _scaleController.value;
    } else {
      return 1 - _scaleController.value;
    }
  }
}
