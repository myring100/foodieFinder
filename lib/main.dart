import 'package:eatter/screen/pizzaScreen.dart';
import 'utilities/breadButton.dart';
import 'package:flutter/material.dart';
import 'screen/secondPage.dart';
import 'kConst.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eatter',
      theme: ThemeData(
        primaryColor: Colors.purple[200],
        // 연보라 파스텔톤의 primary color
        accentColor: Colors.purpleAccent[100],
        // 연보라 파스텔톤의 accent color
        scaffoldBackgroundColor: Colors.purple[100],
        // 연보라 파스텔톤의 scaffold background color
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          color: Colors.blue[200], // 앱바 백그라운드 색상을 연보라 파스텔톤으로 설정
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.purple, // 버튼 색상을 보라색으로 설정
          ),
        ),
        textTheme: GoogleFonts.caveatTextTheme(Theme.of(context).textTheme), // 텍스트 폰트를 Google Caveat로 설정

      ),
      // home: const MyHomePage(),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(

      body: SingleChildScrollView(

        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              kWelcomeTitle,
              // PizzaScreen(),
              SizedBox(height: 20,),
              kWelcomSubTitle,
              SizedBox(height: 20,),
              CloudButton(
                onPressed: () {
                  // 버튼 클릭 시 다음 페이지로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SecondPage()),
                  );
                },
                text: 'Menu',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
