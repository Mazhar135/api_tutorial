// Library to convert JSON text into Dart objects (jsonDecode)
import 'dart:convert';

// Your own model file (from the earlier example)
import 'package:api_tutorial/Model/PostsModel.dart';
// Flutter's Material UI widgets (Scaffold, AppBar, ListView, etc.)
import 'package:flutter/material.dart';
// http package, used to make API requests. "as http" lets us write http.get(...)
import 'package:http/http.dart' as http;

// StatefulWidget: a screen whose content can change (here, after data loads)
class ExampleTwo extends StatefulWidget {
  const ExampleTwo({super.key});

  @override
  State<ExampleTwo> createState() => _State();
}

class _State extends State<ExampleTwo> {
  // Stores all photos fetched from the API
  List<Photos> photoList = [];

  // async function: it waits for the internet response without freezing the app.
  // It returns a Future, which means "a list of Photos that will arrive later".
  Future<List<Photos>> getPhotos() async {
    // Send a GET request to the API and wait (await) for the response
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));

    // Convert the response body (a JSON string) into Dart data (a List of Maps)
    var data = jsonDecode(response.body.toString());

    // Loop through each item in the JSON list
    for (Map i in data) {
      // Build a Photos object from the map's keys and add it to our list
      Photos photos = Photos(title: i['title'], url: i['url'], id: i['id']);
      photoList.add(photos);
    }

    // statusCode 200 means the request succeeded.
    // (Both branches return the same list here.)
    if (response.statusCode == 200) {
      return photoList;
    } else {
      return photoList;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold: the basic page structure (app bar + body)
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        // Center puts the title text in the middle of the app bar
        title: Center(child: Text('Api course')),
      ),
      // Column stacks its children vertically
      body: Column(
        children: [
          // Expanded makes the list take all remaining space
          // (needed because a ListView inside a Column needs a fixed height)
          Expanded(
            // FutureBuilder: waits for getPhotos() to finish,
            // then rebuilds the UI with the result
            child: FutureBuilder(
                future: getPhotos(), // the Future we are waiting for
                // snapshot holds the Future's state and its data
                builder: (index, AsyncSnapshot<List<Photos>> snapshot) {
                  // ListView.builder creates list items only as they scroll
                  // into view, which is efficient for large lists
                  return ListView.builder(
                      itemCount: photoList.length, // how many items to show
                      itemBuilder: (context, index) {
                        // One row of the list
                        return ListTile(
                          // Round image on the left, loaded from the photo URL
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                snapshot.data![index].url.toString()),
                          ),
                          // Smaller text below the title: the photo's title
                          subtitle:
                          Text(snapshot.data![index].title.toString()),
                          // Main text: the photo's id
                          title: Text(
                              'Notes id ' + snapshot.data![index].id.toString()),
                        );
                      });
                }),
          ),
        ],
      ),
    );
  }
}

// Model class: describes what one photo looks like
class Photos {
  String title, url; // text fields
  int id; // numeric id

  // "required" means these values must be passed when creating a Photos object
  Photos({required this.title, required this.url, required this.id});
}