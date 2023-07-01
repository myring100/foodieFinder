import 'package:flutter/material.dart';


class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eatter'),
      ),
      body: Center(
        child: Text(
          'This is the Second Page!',
          style: TextStyle(fontSize: 32),
        ),
      ),
    );
  }
}
