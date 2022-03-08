import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Friednlychat/lib/pages/login';

class Authentification extends StatelessWidget {
  Authentification({ Key? key }) : super(key: key);

  final _formkey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestor _db = FirebaseFirestore.insatance;
   
  TextEditingController _emailField = TextEditingController(); 
  TextEditingController _passwordField = TextEditingController(); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.blueAccent,

        ),

        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextFormField(
                controller: _emailField, 
                validator: (String? value) {
                 if (value == null){
                    return "Email cannot be empty";
                  }else if (!value.contains("@") & !value.contains(".")){
                    return "Please enther a valid email address";
                  }
                }
                decoration: InputDecoration(
                  hintText: "example@gmail.com",
                  hintStyle: TextStyle(
                   color: Colors.white,
                  ),
                 labelText: "Email",
                 labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
             ),

              TextFormField(
                controller: _passwordField,
                obscureText: true,
                validator: (String? value) {
                  if (value == null){
                    return "Password cannot be empty";
                 }else if (value.length < 8){
                   return "Password must be 8 characters or longer";
                  }
               }
               decoration: InputDecoration(
                  hintText: "example123",
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                 labelText: "Password",
                 labelStyle: TextStyle(
                    color: Colors.white,
                 ),
                ),
              ),

              Container(
               width: MediaQuery.of(context).size.width /1.4,
               height: 45,
               decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.white,
                ),
              
                child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing')),
                      );
                      _register(context);
                    }
                  },
                  child: Text("Register"),
                ),
              ),

              Container(
                width: MediaQuery.of(context).size.width /1.4,
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.white,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing')),
                      );
                      _login(context);
                    }

                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()))
                  },
                  child: Text("Login"), 
                ),
              ),

              Container(
                width: MediaQuery.of(context).size.width /1.4,
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.white,
                ),

                child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing')),
                      );
                    }
                  },
                  child: Text("Sign In with Google"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _register(BuildContext context) async {
    try{
      await _auth.createUserWithEamilAndPassword(
        email: _email.text, password: _password.text);
        ScaffoldMessenger.of(context).clearSnackBars();
    } on FirebaseException catch(e){
      if (e.code == 'email-already-in-use'){
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('A user with this email already exists')),
        );
      } else if (e.code == 'weak-password'){
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('The password entered is too weak')),
        );
      }
      return;
    }

    try on FirebaseException{
      await _db.collection("users").doc(_auth.currentUser!.uid).set({
        "email" : _email.text,
        "role" : "USER"
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(e.message ?? "Unknown error")),
      );
    }
  }

  void _login(BuildContext context) async {
    try{
      await _auth.signInWithEamilAndPassword(
        email: _email.text, password: _password.text);
        ScaffoldMessenger.of(context).clearSnackBars();
    } on FirebaseException catch(e){
      if (e.code == 'user-not-found' || e.code == 'wrong-password'){
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email/Password combination incorrect')),
        );
      } 
      return;
    }
    
    try on FirebaseException{
      await _db.collection("user").dooc(_auth.currentUser!.uid).set({
        "email" : _email.text
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(e.message ?? "Unknown error")),
      );
    }
  }
}