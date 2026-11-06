import 'dart:convert'; // for jsonDecode (converts JSON text into Dart objects)

import 'package:api_tutorial/Model/PostsModel.dart';
import 'package:api_tutorial/Model/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // for making API requests

// StatefulWidget because the screen's data (userList) is stored inside it
class ExampleThree extends StatefulWidget {
  const ExampleThree({super.key});

  @override
  State<ExampleThree> createState() => _ExampleThreeState();
}

class _ExampleThreeState extends State<ExampleThree> {

  // Empty list that will hold the users after they come from the API
  List<UserModel> userList = [];

  // async function: waits for the API and returns a list of users later (Future)
  Future<List<UserModel>> getUserApi() async {

    // Send a GET request to the API and wait for the response
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));

    // Convert the response text (JSON) into a Dart list of maps
    var data = jsonDecode(response.body.toString());

    // 200 means the request was successful
    if (response.statusCode == 200) {

      // Go through each user map and convert it to a UserModel object
      for (Map i in data) {
        userList.add(UserModel.fromJson(i));
      }

      return userList; // return the finished list
    } else {
      return []; // request failed, return an empty list
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Top bar of the screen
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Center(child: Text('Api Course')),
      ),
      body: Column(
        children: [
          // Expanded gives the list all the remaining space on screen
          Expanded(
            // FutureBuilder waits for the Future and rebuilds the UI when it finishes
              child: FutureBuilder(
                  future: getUserApi(), // the Future it waits for
                  builder: (context, snapshot) {

                    // No data yet, so show a loading spinner
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      // Data arrived, so build a scrollable list
                      return ListView.builder(
                          itemCount: userList.length, // number of rows
                          itemBuilder: (context, index) {
                            // index = position of the current user (0, 1, 2...)
                            return Card(
                              child: Column(
                                children: [

                                  // One row per field, using the reusable widget below
                                  ReusableRow(title: 'Name', value: snapshot.data![index].name.toString()),
                                  ReusableRow(title: 'username', value: snapshot.data![index].username.toString()),
                                  ReusableRow(title: 'email', value: snapshot.data![index].email.toString()),

                                  // address is a nested object, so we go address -> city and geo
                                  // "!" tells Dart the value is not null
                                  ReusableRow(
                                      title: 'address',
                                      value: snapshot.data![index].address!.city.toString() +
                                          snapshot.data![index].address!.geo.toString()),
                                ],
                              ),
                            );
                          });
                    }
                  }))
        ],
      ),
    );
  }
}

// A small reusable widget that shows "title ........ value" in one row
// StatelessWidget because it never changes by itself
class ReusableRow extends StatelessWidget {
  String title, value; // the two texts passed in from outside

  // "required" means you must pass both title and value
  ReusableRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0), // space around the row
      child: Row(
        // Pushes title to the far left and value to the far right
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(value),
        ],
      ),
    );
  }
}