import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:snake/settings/game_settings.dart';

class Snake extends StatefulWidget {
  const Snake(this.changeGameState, {Key? key}) : super(key: key);

  final void Function() changeGameState;

  @override
  State<Snake> createState() => _SnakeState();
}

class _SnakeState extends State<Snake> {
  late List<Color> grid = List.generate(tileAmount, (index) => tileColor);

  late List<int> snakeGrids = [];
  late int appleGrid = 0;

  Direction givenDirection = Direction.down;
  Direction realDirection = Direction.down;

  Timer? timer;

  @override
  void initState() {
    initializeGameState();
    initializeGrid();

    super.initState();
  }

  void initializeGrid() {
    grid[appleGrid] = appleColor;

    for (int i = 0; i < snakeGrids.length; i++) {
      grid[snakeGrids[i]] = snakeColor;
    }

    for (int i = 0; i < tileAmount; i++) {
      if (i % 20 == 0 || (i + 1) % 20 == 0 || i >= tileAmount - 20 || i < 20) {
        grid[i] = backgroundColor;
      }
    }
  }

  void initializeGameState() {
    appleGrid = initialAppleGrid;
    snakeGrids = [initialSnakeGrid];

    move();
  }

  void move() {
    setState(() {
      grid[snakeGrids.last] = tileColor;
      int moveValue = getMoveValue();
      if (snakeGrids.first >= tileAmount - 20 ||
          snakeGrids.first < 20 ||
          snakeGrids.first % 20 == 0 ||
          (snakeGrids.first + 1) % 20 == 0 ||
          grid[snakeGrids.first + moveValue] == Colors.white) {
        widget.changeGameState();
      }
      snakeGrids.insert(0, snakeGrids.first + moveValue);
      if (snakeGrids.first != appleGrid) {
        snakeGrids.removeLast();
      } else {
        generateApple();
      }

      realDirection = givenDirection;

      for (int i = 0; i < snakeGrids.length; i++) {
        grid[snakeGrids[i]] = snakeColor;
      }
    });

    timer?.cancel();

    timer = Timer.periodic(
      moveInterval,
      (timer) {
        move();
      },
    );
  }

  void generateApple() {
    int random = Random().nextInt(tileAmount);
    setState(() {
      grid[appleGrid] = tileColor;
      if (grid[random] != snakeColor && grid[random] != backgroundColor) {
        appleGrid = random;
        grid[appleGrid] = appleColor;
      }
    });
  }

  int getMoveValue() {
    final directionValues = {
      Direction.down: 20,
      Direction.up: -20,
      Direction.right: 1,
      Direction.left: -1,
    };
    return directionValues[givenDirection] ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Material(
        child: GestureDetector(
          onVerticalDragUpdate: (details) {
            if (details.primaryDelta! > 0 && realDirection != Direction.up) {
              givenDirection = Direction.down;
            } else if (details.primaryDelta! < 0 &&
                realDirection != Direction.down) {
              givenDirection = Direction.up;
            }
          },
          onHorizontalDragUpdate: (details) {
            if (details.primaryDelta! > 0 && realDirection != Direction.left) {
              givenDirection = Direction.right;
            } else if (details.primaryDelta! < 0 &&
                realDirection != Direction.right) {
              givenDirection = Direction.left;
            }
          },
          child: Scaffold(
            backgroundColor: backgroundColor,
            body: Center(
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 20,
                children: List.generate(
                  tileAmount,
                  (index) => Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: DecoratedBox(
                        decoration: BoxDecoration(color: grid[index]),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum Direction { up, down, left, right }
