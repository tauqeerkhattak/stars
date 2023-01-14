import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stars/screens/game_start/game_start.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const StarsProject());
}

class StarsProject extends StatelessWidget {
  const StarsProject({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameStart(),
    );
  }
}
