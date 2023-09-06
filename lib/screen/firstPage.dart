import 'dart:math';
import 'package:eatter/kConst.dart';
import 'package:eatter/screen/findDinning.dart';
import 'package:eatter/widget/myRoulette.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:roulette/roulette.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:geolocator/geolocator.dart';


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
  late Image foodImage;
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

  void setImage(int i){

    switch(i){
    case 0 : foodImage = Image.asset('assets/korean.jpeg'); break;
    case 1 : foodImage = Image.asset('assets/japanese.jpeg'); break;
    case 2 : foodImage = Image.asset('assets/chinese.jpeg');break;
    case 3 : foodImage = Image.asset('assets/italian.jpeg');break;
    case 4 : foodImage = Image.asset('assets/mexican.jpeg');break;
    case 5 : foodImage = Image.asset('assets/thai.jpeg');break;
    case 6 : foodImage = Image.asset('assets/greek.jpeg');break;
    case 7 : foodImage = Image.asset('assets/turkish.jpeg');break;
    case 8 : foodImage = Image.asset('assets/french.jpeg');break;
    case 9 : foodImage = Image.asset('assets/india.jpeg');break;
      default : foodImage = Image.asset('assets/mexican.jpeg');break;
    }
  }

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
                print(_controller.animation.status);
                if (_controller.animation.status == AnimationStatus.forward) {
                  _controller.rollTo(randomNum,
                      duration: const Duration(milliseconds: 300),
                      clockwise: _clockwise,
                      offset: _random.nextDouble());
                } else {
                  _showSnackBar(context);
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
                fixedSize: MaterialStateProperty.all(const Size(150, 50)),
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
      //status.index 3 == 스핀이 끝낫을때
      if (status.index == 3) {
        String foodType = values[randomNum];
        Future.delayed(Duration(milliseconds: 200), () {
          Dialogs.materialDialog(
              customView: foodImage,
              msg: foodType,
              context: context,
              actions: [
                IconsButton(
                  onPressed: () async{
                    requestLocationPermission();
                  },
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
    _controller.rollTo(
        duration: Duration(seconds: 3),
        randomNum,
        clockwise: _clockwise,
        offset: _random.nextDouble());
    setImage(randomNum);
  }

  void _showSnackBar(BuildContext context) {
    final snackBar = SnackBar(
        content: Text(
      'Need to Spin Roulette',
      textAlign: TextAlign.center,
    ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  Future<void> requestLocationPermission() async {
    print('requestLocationPermission()');

    final status = await Geolocator.checkPermission();
    print('current status = $status');
    if (status == LocationPermission.denied || status == LocationPermission.deniedForever) {
      final result = await Geolocator.requestPermission();
      if (result == LocationPermission.whileInUse || result == LocationPermission.always) {
        print('access allowed');
        Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low).then((value) => Get.to( () => FindDinning(value),transition: Transition.fade));
      } else {
        print('access denied');
      }
    } else if (status == LocationPermission.deniedForever){

    }

    else if (status == LocationPermission.whileInUse || status == LocationPermission.always) {
      print('access allowed already');
      Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low).then((value) => Get.to( () => FindDinning(value),transition: Transition.fade));
    }
  }

}
