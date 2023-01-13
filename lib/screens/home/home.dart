import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _obstacleController;
  final random = Random();
  final int numberOfStars = kDebugMode ? 50 : 200;
  final _slideDuration = const Duration(
    seconds: 16,
  );
  final _scaleDuration = const Duration(
    milliseconds: 2000,
  );
  final Duration _obstacleDuration = const Duration(
    seconds: 5,
  );
  StreamController<Offset> controller = StreamController();
  double _obstacleYPosition = 0.0;

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
    _obstacleController = AnimationController(
      vsync: this,
      duration: _obstacleDuration,
    )..repeat(
        reverse: false,
        min: 0.0,
        max: 1.0,
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
            _buildObstacles(),
            _buildRocket(),
            // _buildNameCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildRocket() {
    return StreamBuilder(
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
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
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

  Widget _buildObstacles() {
    final size = MediaQuery.of(context).size;
    double top = random.nextInt(size.height.floor()).toDouble();
    final rockSize = size.width * 0.1;
    if (top > (size.width - rockSize)) {
      top -= rockSize;
    }
    return AnimatedBuilder(
      animation: _obstacleController,
      builder: (context, child) {
        return Positioned(
          left: _getObstacleXPosition(
            width: size.width,
          ),
          top: _getObstacleYPosition(
            height: size.height,
            width: size.width,
          ),
          child: Transform.rotate(
            angle: 2 * pi * _obstacleController.value,
            child: child!,
          ),
        );
      },
      child: Image.asset(
        'assets/images/rock.png',
        width: rockSize,
        height: rockSize,
      ),
    );
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

  double _getObstacleXPosition({required double width}) {
    final animationValue = _obstacleController.value;
    final position = 1.5 * width * animationValue;
    if (animationValue <= 0.0) {
      return 0;
    } else if (animationValue >= width) {
      return width;
    } else {
      return position;
    }
  }

  double _getObstacleYPosition(
      {required double height, required double width}) {
    final animationValue = _obstacleController.value;
    final rocketSize = width * 0.1;
    if (animationValue >= 0.99) {
      _obstacleYPosition = random.nextInt(height.floor()).toDouble();
      print(
          'CHANGE Y POSITION OF OBSTACLE: $_obstacleYPosition ${_obstacleController.duration?.inSeconds}');
    }
    if (_obstacleYPosition + rocketSize >= height) {
      return _obstacleYPosition - (width * 0.1);
    } else if (_obstacleYPosition + rocketSize <= 0.0) {
      return _obstacleYPosition + (width * 0.1);
    } else {
      return _obstacleYPosition;
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
