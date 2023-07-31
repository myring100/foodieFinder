
import 'dart:ui';
import 'package:eatter/screen/firstPage.dart';
import 'package:flutter/material.dart';
import 'screen/secondPage.dart';
import 'package:google_fonts/google_fonts.dart';


void main() {
  Locale currentLocale = window.locale;
  String languageCode = currentLocale.languageCode;
  print('사용자의 핸드폰 언어: $languageCode');
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
        textTheme: GoogleFonts.caveatTextTheme(
            Theme.of(context).textTheme), // 텍스트 폰트를 Google Caveat로 설정
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

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  final _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: PageView(
        children: [
          Firstpage(),
          SecondPage(),
        ],

        ),
    );
  }
}
