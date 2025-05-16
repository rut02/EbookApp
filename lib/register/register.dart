import 'dart:convert';
import 'package:ebookapp/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:ebookapp/login/login.dart';
// import 'package:ebookapp/register/register.dart';
import 'package:ebookapp/user/user.dart';

class register extends StatefulWidget {
  @override
  _registerState createState() => _registerState();
}

class _registerState extends State<register> {
  
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final fromKey = GlobalKey<FormState>(); //keep from widget


  Future sing_up() async{

    String url =  'http://'+ip+':8080/api/users/register';
    print('check');
    final response = await http.post(Uri.parse(url) , 
    
    body: jsonEncode({
      
      'username' : userNameController.text,
      'email' : emailController.text,
      'password' : passwordController.text

    }),
    headers: 
    {
      'Content-Type': 'application/json',
    });


    // var data = json.decode(response.body);
    
    
  if (response.statusCode == 200) {
    if (response.body.trim() == 'no') {
      Navigator.pushNamed(context, 'register');
      print('Email already exists in the database');
    } else {
    
      Navigator.pushNamed(context, 'login');
      print('Registration successful');
    }
  } else {
    print('Request failed with status: ${response.statusCode}');
  }
  
}

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Form(
          key: fromKey,
          child: ListView(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: Text(
                  "Register",
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(20),
                child: Text(
                  "Sign up",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  validator: (val){
                    if(val!.isEmpty){
                      return 'Empty';
                    }
                    return null;
                    //chk txt in txt field
                  },
                  controller: userNameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  validator: (val){
                    if(val!.isEmpty){
                      return 'Empty';
                    }
                    return null;
                    //chk txt in txt field
                  },
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextFormField(
                  validator: (val){
                    if(val!.isEmpty){
                      return 'Empty';
                    }
                    return null;
                    //chk txt in txt field
                  },
                  obscureText: true,
                  controller: passwordController,
                  decoration: InputDecoration(
                      labelText: 'Password'
                      ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextFormField(
                  validator: (val){
                    if(val!.isEmpty){
                      return 'Empty';
                    }
                    else if(val != passwordController.text){
                      return 'Password not match';
                    }
                    return null;
                    //chk txt in txt field
                  },
                  obscureText: true,
                  controller: passwordController,
                  decoration: InputDecoration(
                      labelText: 'Retry Password'
                      ),
                ),
              ),
              Container(
                height: 50,
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.blue, // สีของตัวอักษร
                  ),
                  onPressed: () {

                    bool pass = fromKey.currentState!.validate();

                    if(pass){
                      sing_up();
                      print(userNameController);
                      print(emailController);
                      print(passwordController);
                    }
                  },
                  child: Text('Register'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
