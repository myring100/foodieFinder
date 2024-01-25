import 'dart:math';
import 'package:eatter/kConst.dart';
import 'package:eatter/screen/findDinning.dart';
import 'package:eatter/widget/myRoulette.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:group_button/group_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:roulette/roulette.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:geolocator/geolocator.dart';
import 'package:xen_popup_card/xen_popup_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eatter/itemByCountry.dart';
class Firstpage extends StatefulWidget {
  const Firstpage({Key? key}) : super(key: key);

  @override
  State<Firstpage> createState() => _FirstpageState();
}

class _FirstpageState extends State<Firstpage>
    with TickerProviderStateMixin {

  final controller = GroupButtonController();
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
  ];

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<List<String>>? selectedValues;
  final values = <String>[
    "Korean",
    "Japanese",
    "Chinese",
    "Italian",
    "Mexican",
    "Thai",
    // "Greek",
    // "Turkish",
    // "French",
    // "Indian",
  ];

  void setImage(int i) {
    switch (i) {
      case 0:
        foodImage = Image.asset('assets/korean.jpeg');
        break;
      case 1:
        foodImage = Image.asset('assets/japanese.jpeg');
        break;
      case 2:
        foodImage = Image.asset('assets/chinese.jpeg');
        break;
      case 3:
        foodImage = Image.asset('assets/italian.jpeg');
        break;
      case 4:
        foodImage = Image.asset('assets/mexican.jpeg');
        break;
      case 5:
        foodImage = Image.asset('assets/thai.jpeg');
        break;
      case 6:
        foodImage = Image.asset('assets/greek.jpeg');
        break;
      case 7:
        foodImage = Image.asset('assets/turkish.jpeg');
        break;
      case 8:
        foodImage = Image.asset('assets/french.jpeg');
        break;
      case 9:
        foodImage = Image.asset('assets/india.jpeg');
        break;
      default:
        foodImage = Image.asset('assets/mexican.jpeg');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: selectedValues,
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }
        else {
          int itemCount = snapshot.data?.length ?? 6;
          List<String> items = snapshot.data ??
              ['Korean', 'Japanese', 'Chinese', 'Italian', 'Mexican', 'hi'];

          final group = RouletteGroup.uniform(
            itemCount,
            textBuilder: (index) => items[index],
            colorBuilder: colors.elementAt,
            textStyleBuilder: (index) =>
            const TextStyle(fontSize: 20, color: Colors.black),
          );
          _controller = RouletteController(vsync: this, group: group);
          _controller.animation.addStatusListener((status) {
            //status.index 3 == 스핀이 끝낫을때
            if (status.index == 3) {
              String foodType = items[randomNum];
              Future.delayed(const Duration(milliseconds: 200), () {
                Dialogs.materialDialog(
                    customView: foodImage,
                    msg: foodType,
                    context: context,
                    actions: [
                      IconsButton(
                        onPressed: () async {
                          requestLocationPermission();
                        },
                        text: 'Find Restaurant',
                        color: Colors.red,
                        textStyle: const TextStyle(color: Colors.white),
                        iconColor: Colors.white,
                      ),
                      IconsButton(
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop();
                          _controller.resetAnimation();
                          rollRoulette(itemCount);
                        },
                        text: 'Spin Again',
                        color: Colors.red,
                        textStyle: const TextStyle(color: Colors.white),
                        iconColor: Colors.white,
                      ),
                    ]);
              });
            }
          });


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
                  //eidt button
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shadowColor: MaterialStateProperty.all(
                            Colors.transparent),
                        backgroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                      ),
                      onPressed: () {
                        showEditPopUp();
                      },
                      child: const Icon(Icons.edit),
                    ),
                  ),
                  GestureDetector(
                    child: MyRoulette(
                      controller: _controller, items: items,
                    ),
                    onTap: () {
                      rollRoulette(itemCount);
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  //stop 버튼
                  ElevatedButton(
                    onPressed: () {
                      print(_controller.animation.status);
                      if (_controller.animation.status ==
                          AnimationStatus.forward) {
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
                      "S T O P",
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          );
        }
      },
    );
  }

  void rollRoulette(int count) {
    randomNum = _random.nextInt(count);
    _controller.rollTo(
        duration: const Duration(seconds: 3),
        randomNum,
        clockwise: _clockwise,
        offset: _random.nextDouble());
    setImage(randomNum);
  }

  @override
  void initState() {
    // selectedValues = _prefs.then((SharedPreferences prefs) {
    //   prefs.setStringList('item', ['Korean','Japanese','Chinese','Italian','Mexican','Tahi']);
    //   return prefs.getStringList('item') ?? [];
    // });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showSnackBar(BuildContext context) {
    const snackBar = SnackBar(
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
    if (status == LocationPermission.denied ||
        status == LocationPermission.deniedForever) {
      final result = await Geolocator.requestPermission();
      if (result == LocationPermission.whileInUse ||
          result == LocationPermission.always) {
        print('access allowed');
        Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low)
            .then((value) =>
            Get.to(() => FindDinning(value), transition: Transition.fade));
      } else {
        print('access denied');
      }
    } else if (status == LocationPermission.deniedForever) {} else
    if (status == LocationPermission.whileInUse ||
        status == LocationPermission.always) {
      print('access allowed already');
      Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low).then(
              (value) =>
              Get.to(() => FindDinning(value), transition: Transition.fade));
    }
  }


  void showEditPopUp() {
    final controller = GroupButtonController();
    List<String> values =[];
    XenCardGutter gutter =  XenCardGutter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30,10,30,10),
        child: ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.purple[200])),onPressed: () {}, child: const Text('Done',style: TextStyle(color: Colors.black),),),
      ),
    );
    showDialog(
        context: context,
        builder: (builder) =>
            XenPopupCard(
              gutter: gutter,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GroupButton(
                    isRadio: false,
                    onSelected: (text,i,selected){
                      if(selected) {
                        values.add(text);
                      } else {
                        values.remove(text);
                      }
                    },

                      options: GroupButtonOptions(
                        selectedTextStyle: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                        selectedColor: Colors.purple[500],
                        unselectedColor: Colors.purple[200],
                        unselectedTextStyle: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(50),
                        spacing: 10,
                        runSpacing: 10,
                        groupingType: GroupingType.wrap,
                        direction: Axis.horizontal,
                        buttonHeight: 60,
                        buttonWidth: 60,
                        mainGroupAlignment: MainGroupAlignment.center,
                        crossGroupAlignment: CrossGroupAlignment.center,
                        groupRunAlignment: GroupRunAlignment.center,
                        textAlign: TextAlign.center,
                        textPadding: EdgeInsets.zero,
                        alignment: Alignment.center,
                        elevation: 0,
                      ),
                      maxSelected: 5,
                      controller:controller,
                      buttons: ItembyCountry().items),
                  TextButton(
                    onPressed: () => controller.selectIndex(1),
                    child: const Text('Select 3 - 6 buttons'),
                  )
                ],
              ),
            ));
  }
}
