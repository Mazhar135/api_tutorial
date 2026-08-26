import'package:flutter/material.dart';

class LastExampleScreen extends StatefulWidget {
  const LastExampleScreen({super.key});

  @override
  State<LastExampleScreen> createState() => _LastExampleScreenState();
}

class _LastExampleScreenState extends State<LastExampleScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Api Course'),


      ),
      body: Column(
        children: [

        ],
      ),
    );
  }
}
