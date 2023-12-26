import 'package:flutter/material.dart';

class DeathScreen extends StatelessWidget {
  const DeathScreen(this.changeGameState, {super.key});
  final void Function() changeGameState;

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.ltr,
        child: TextButton(
          onPressed: changeGameState,
          child: const Text("Restart"),
        ));
  }
}
