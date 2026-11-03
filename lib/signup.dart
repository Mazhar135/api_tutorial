import"package:flutter/material.dart";
import 'package:http/http.dart';

class signUpScreen extends StatefulWidget {
  const signUpScreen({super.key});

void login(String email, password)async{

  try{
   Response response = await post(
     Uri.parse('https://reqres.in/api/register'),
     body: {
       'email' : email,
       'password':  password ,

   }

   );
   if(response.statusCode == 200){
      print('Login successfully');
   }else{
     print('Failed');
   }
  }catch (e){
    print(e.toString());
  }
}
  @override
  State<signUpScreen> createState() => _signUpScreenState();
}

class _signUpScreenState extends State<signUpScreen> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text("Sign Up APi"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            SingleChildScrollView(
              child: TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Email'
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                  hintText: 'password'
              ),
            ),

            SizedBox(
              height: 20,
            ),
              GestureDetector(child:   Container(

                decoration: BoxDecoration(

                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10)

                ),
                height: 40,
                child: Center(
                  child: Text("Sign up"),
                ) ,
              ),
                onTap: ()

                {

                  widget.login(
                      emailController.text.toString(),
                      passwordController.text.toString(), );                },
              ),

          ],
        ),
      ),
    );
  }
}
