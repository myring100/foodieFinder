import 'dart:io';
import 'dart:math';
import 'package:eatter/kConst.dart';
import 'package:eatter/widget/myRoulette.dart';
import 'package:flutter/material.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:roulette/roulette.dart';
import 'package:material_dialogs/material_dialogs.dart';

class Firstpage extends StatefulWidget {
  const Firstpage({Key? key}) : super(key: key);

  @override
  State<Firstpage> createState() => _FirstpageState();
}

class _FirstpageState extends State<Firstpage>
    with SingleTickerProviderStateMixin {
  late int randomNum;
  static final _random = Random();
  late RouletteController _controller;

  final bool _clockwise = true;

  final colors = <Color>[
    Colors.red.withAlpha(50),
    Colors.green.withAlpha(30),
    Colors.blue.withAlpha(70),
    Colors.yellow.withAlpha(90),
    Colors.amber.withAlpha(50),
    Colors.red.withAlpha(50),
    Colors.green.withAlpha(30),
    Colors.blue.withAlpha(70),
    Colors.yellow.withAlpha(90),
    Colors.amber.withAlpha(50),
  ];

  // final values = <String>[
  //   "한식",
  //   "일식",
  //   "중식",
  //   "이탈리안",
  //   "맥시코",
  //   "태국",
  //   "그리스",
  //   "터키",
  //   "프랑스",
  //   "인도",
  // ];
  final values = <String>[
    "Korean",
    "Japanese",
    "Chinese",
    "Italian",
    "Mexican",
    "Thai",
    "Greek",
    "Turkish",
    "French",
    "Indian",
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            kWelcomeTitle,
            const SizedBox(
              height: 20,
            ),
            //룻렛
            GestureDetector(
              child: MyRoulette(
                controller: _controller,
              ),
              onTap: () {
                randomNum = _random.nextInt(values.length - 1);
                rollRoulette();
              },
            ),
            const SizedBox(
              height: 25,
            ),
            //stop 버튼
            ElevatedButton(
              onPressed: () {
                _controller.rollTo(randomNum,
                    duration: const Duration(milliseconds: 300),
                    clockwise: _clockwise,
                    offset: _random.nextDouble());
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
                fixedSize: MaterialStateProperty.all(const Size(150,50)),
              ),
              child: const Text(
                "Stop",
                style: TextStyle(fontSize: 25),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    final group = RouletteGroup.uniform(
      values.length,
      textBuilder: (index) => values[index],
      colorBuilder: colors.elementAt,
      textStyleBuilder: (index) =>
          const TextStyle(fontSize: 20, color: Colors.black),
    );
    _controller = RouletteController(vsync: this, group: group);
    _controller.animation.addStatusListener((status) {
      if (status.index == 3) {
        String foodType = values[randomNum];
        Future.delayed(Duration(milliseconds: 200), () {
          Dialogs.materialDialog(
              customView: Image.asset('assets/bread.png'),
              msg: foodType,
              context: context,
              actions: [
                IconsButton(
                  onPressed: () {},
                  text: 'Find Restaurant',
                  color: Colors.red,
                  textStyle: TextStyle(color: Colors.white),
                  iconColor: Colors.white,
                ),
                IconsButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    _controller.resetAnimation();
                    rollRoulette();
                  },
                  text: 'Spin Again',
                  color: Colors.red,
                  textStyle: TextStyle(color: Colors.white),
                  iconColor: Colors.white,
                ),
              ]);
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void rollRoulette() {
    randomNum = _random.nextInt(values.length - 1);
    _controller.rollTo(randomNum,
        clockwise: _clockwise, offset: _random.nextDouble());
  }
}
