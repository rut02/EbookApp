import 'dart:convert';
import 'package:ebookapp/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ebookapp/user/user.dart';

class login extends StatefulWidget {
  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  
  final fromKey = GlobalKey<FormState>();
 
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  user user_class = user();

  Future sing_in() async{

  String url =  'http://'+ip+':8080/api/users/login';
  
  final response = await http.post(Uri.parse(url) , 
  
  body: jsonEncode({
    
    'email' : emailController.text,
    'password' : passwordController.text

  }),
  headers: 
  {
    'Content-Type': 'application/json',
  });

  final responseJson = json.decode(response.body);
  int userID = responseJson['id'];
  
  if (response.statusCode == 200) {
    // print('Request failed with status: ${response.statusCode}');
    await user.setsigin(true);
    await user.setUserID(userID);
    Navigator.pushNamed(context, 'homepage');

  } 
  else 
  {
    // print('Request failed with status: ${response.statusCode}');
    Navigator.pushNamed(context, 'login');
  }
  
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Padding(
         padding: EdgeInsets.fromLTRB(20, 100, 20, 20),
        child:Form(
          key: fromKey,
          child: ListView(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: Text(
                  "Login",
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
                  "Sign in",
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
                      labelText: 'Password'),
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
                      sing_in();
                      // print(emailController);
                      // print(passwordController);
                      Navigator.pushNamed(context, 'homepage');
                    }
                  },
                  child: Text('Login'),
                ),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Text("ไม่มีบัญชี?"),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.blue,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, 'register');
                      },
                      child: Text(
                        'Sign up',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
