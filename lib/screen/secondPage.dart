import 'package:flutter/material.dart';


class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eatter'),
      ),
      body: const Center(
        child: Text(
          'This is the Second Page!',
          style: TextStyle(fontSize: 32),
        ),
      ),
    );
  }
}
