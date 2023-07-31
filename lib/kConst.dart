
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:typewritertext/typewritertext.dart';

Widget kWelcomeTitle = const Text('Today Special',  style: TextStyle(fontSize: 48,color: Colors.red),);
Widget kWelcomSubTitle = const TypeWriterText(
  text:
  Text('Spin Menu',style: TextStyle(fontSize: 32),textAlign: TextAlign.center,),
  duration: Duration(milliseconds: 50),
repeat: false,);




