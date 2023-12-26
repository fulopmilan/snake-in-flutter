import 'package:flutter/material.dart';
import 'package:snake/death_screen.dart';
import 'game.dart';

void main() {
  runApp(const Manager());
}

class Manager extends StatefulWidget {
  const Manager({super.key});

  @override
  State<Manager> createState() => _ManagerState();
}

class _ManagerState extends State<Manager> {
  bool isPlaying = true;

  void changeGameState() {
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isPlaying ? Snake(changeGameState) : DeathScreen(changeGameState);
  }
}
