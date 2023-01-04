import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late AnimationController _animationController;
  final int numberOfStars = 200;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 4000,
      ),
    )..repeat(
        reverse: true,
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ImageFiltered(
        imageFilter: ImageFilter.blur(
          sigmaX: 3,
          sigmaY: 3,
        ),
        enabled: false,
        child: Stack(
          children: [
            _buildBackground(),
            ..._buildStars(),
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

  List<Widget> _buildStars() {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final random = Random();
    List<Widget> stars = List.generate(
      numberOfStars,
      (index) {
        final xPosition = random.nextInt(width.toInt()).toDouble();
        final yPosition = random.nextInt(height.toInt()).toDouble();
        return AnimatedBuilder(
          animation: _animationController,
          builder: (
            context,
            child,
          ) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: Offset(10, height * 0.5),
                end: Offset(width, height * 0.5),
              ).animate(_animationController),
              child: Transform.scale(
                scale: _animationController.value,
                child: child!,
              ),
              // child: child!,
            );
          },
          child: Container(
            width: 5,
            height: 5,
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
}
