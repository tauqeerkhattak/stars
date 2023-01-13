import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/home/home.dart';

void main() {
  runApp(const StarsProject());
}

class StarsProject extends StatelessWidget {
  const StarsProject({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ProviderScope(
      child: MaterialApp(
        home: Home(),
      ),
    );
  }
}
