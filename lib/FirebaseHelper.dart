import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger_clone/Home.dart';
import 'package:messenger_clone/LoginScreen.dart';

class Service{
  final auth = FirebaseAuth.instance;

  void createUser(context, name, surname, email, password) async {
    try{
      await auth.createUserWithEmailAndPassword(email: email, password: password).then((value)=>{
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Home()))
      });
      await FirebaseFirestore.instance.collection('users').add({
        'name': name.toString().trim(),
        'surname': surname.toString().trim(),
        'email': email.toString().trim(),
        'profileImage': '',
        'activeStatus': '',
        'creationDate': DateTime.now()
      });
    }catch(e){
      errorBox(context, e);
    }
  }

  void loginUser(context, email, password) async {
    try{
      await auth.signInWithEmailAndPassword(email: email, password: password).then((value)=>{
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Home()))
      });
    }catch(e){
      errorBox(context, e);
    }
  }

  void signOut(context) async {
    await auth.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  void errorBox(context, e){
    showDialog(
      context: context, 
      builder: (context){
        return AlertDialog(
          title: const Text('Error'),
          content: Text(e.toString()),
        );
      }
    );
  }
}

