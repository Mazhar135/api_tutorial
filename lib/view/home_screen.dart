import 'dart:convert';

import 'package:api_tutorial/Model/PostsModel.dart';
import'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {

    List<PostsModel> postList = [];

    Future<List<PostsModel>>  getPostApi() async{
  final resposne = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/posts"));

  var data = jsonDecode(resposne.body.toString());

  for(Map i in data){
    postList.add(PostsModel.fromJson(i));
  }

  if(resposne.statusCode == 200){
    return postList;
  }else{
    return postList;
  }
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
          title: Center(child: Text('API Course'))
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
                future: getPostApi() ,
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    return ListView.builder(
                        itemCount: postList.length,
                        itemBuilder: (context, index){
                          return Card(
                            child:
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Title",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                                  SizedBox(height: 5,),
                                  Text(postList[index].title.toString()),
                                  SizedBox(height: 5,),
                                  Text("Description",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),

                                  Text(postList[index].body.toString())
                                ],
                              ),
                            ),
                          );
                        });

                  }else{
                    return Center(child: Text("Loading"));
                  }

                } ),
          )

        ],
      ),
    );
  }
}
