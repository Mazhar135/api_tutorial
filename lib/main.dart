import 'package:api_tutorial/example_five.dart';
import 'package:api_tutorial/example_four.dart';
import 'package:api_tutorial/example_three.dart';
import 'package:api_tutorial/example_two.dart';
import 'package:api_tutorial/signup.dart';
import 'package:flutter/material.dart';

import 'view/create_todo_screen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: signUpScreen(),
  ));
}