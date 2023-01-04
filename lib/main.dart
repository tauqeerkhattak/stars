import 'package:flutter/material.dart';

import 'screens/home/home.dart';

void main() {
  runApp(const StarsProject());
}

class StarsProject extends StatelessWidget {
  const StarsProject({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}
