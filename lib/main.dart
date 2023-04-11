import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:messenger_clone/Home.dart';
import 'package:messenger_clone/LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); 
  SharedPreferences pref = await SharedPreferences.getInstance();
  var email = pref.get('email');
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Messenger Clone',
      home:  email == null ? const LoginScreen() : const Home(),
    )
  );
}

