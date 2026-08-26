import 'dart:convert';

import 'package:api_tutorial/Model/PostsModel.dart';
import 'package:api_tutorial/Model/UserModel.dart';
import'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ExampleThree extends StatefulWidget {
  const ExampleThree({super.key});

  @override
  State<ExampleThree> createState() => _ExampleThreeState();
}

class _ExampleThreeState extends State<ExampleThree> {

  List<UserModel> userList = [];
  Future<List<UserModel>> getUserApi () async{

    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));

  var data = jsonDecode(response.body.toString());

 if(response.statusCode == 200){

   for(Map i in data){
   userList.add(UserModel.fromJson(i));
   }

   return userList;
 }else{
return [];
 }
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      title: Center(child: Text('Api Course')),
      ),
      body: Column(
        children: [
          Expanded(
              child: FutureBuilder(
                  future: getUserApi(),
                  builder: (context,  snapshot){

                    if(!snapshot.hasData){
                      return Center(child: CircularProgressIndicator());
                    }else{
                      return ListView.builder(
                          itemCount: userList.length,
                          itemBuilder: (context, index){
                            return Card(
                              child:Column(
                                children: [

                                  ReusableRow(title: 'Name', value: snapshot.data![index].name.toString()),
                                  ReusableRow(title: 'username', value: snapshot.data![index].username.toString()),
                                  ReusableRow(title: 'email', value: snapshot.data![index].email.toString()),
                                  ReusableRow(title: 'address',
                                      value: snapshot.data![index].address!.city.toString()
                              + snapshot.data![index].address!.geo.toString())

                              ,
                                ],
                              ) ,
                            );
                          });
                    }

                  })
          )
        ],
      ),
    );
  }
}


class ReusableRow extends StatelessWidget {
  String title, value;
   ReusableRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title ),
          Text(value)
        ],
      ),
    );
  }
}

