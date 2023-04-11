import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:messenger_clone/ChatScreen.dart';
import 'package:messenger_clone/Chats.dart';
import 'package:messenger_clone/CreateAccount.dart';
import 'package:messenger_clone/FirebaseHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final userName = FirebaseAuth.instance.currentUser;
  Service service = Service();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: userName != null ? savedAccountShow(context, userName) : loginWidget(context, email, password, service)
        ),
      )
    );  
  }
}

Widget loginWidget(context, email, password, service){
  return Container(
    height: MediaQuery.of(context).size.height,
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topRight,
        colors: [
          Color.fromRGBO(52,76,84, 1.0),
          Color.fromRGBO(52,76,84, 1.0),
        ]
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Row(
            children: const [
              BackButton(),
            ],
          ),
          const SizedBox(height: 50),
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/logo.png'),
              )
            ),
          ),
          const SizedBox(height: 50.0),
          TextField(
            controller: email,
            decoration: InputDecoration(
              hintText: 'Numer telefonu komórkowego lub adres e-mail',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          TextField(
            obscureText: true,
            controller: password,
            decoration: InputDecoration(
              hintText: 'Hasło',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)
              ),
            ),
            onPressed: () async {
              SharedPreferences pref = await SharedPreferences.getInstance();
              if(email.text.isNotEmpty && password.text.isNotEmpty){
                service.loginUser(context, email.text, password.text);
                pref.setString('email', email.text);
              }else{
                service.errorBox(context, 'Wprowadzono błędne dane.');
              }
            },
            child: const Text('Zaloguj się'),
          ),
          TextButton(
            onPressed: (){}, 
            child: const Text('Nie pamiętasz hasła?',
              style: TextStyle(
                color: Colors.white
              ),
            )
          ),
          const SizedBox(height: 30),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateAccount()));
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 45.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(width: 1, color: Colors.white),
                color: Colors.transparent,
              ),
              child: const Center(
                child: 
                Text('Utwórz nowe konto',
                  style: TextStyle(
                    fontSize: 18
                  ),
                )
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget savedAccountShow(context,User? userName){
  return Container(
    height: MediaQuery.of(context).size.height,
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topRight,
        colors: [
          Color.fromRGBO(52,76,84, 1.0),
          Color.fromRGBO(52,76,84, 1.0),
        ]
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          const SizedBox(height: 100),
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/logo.png'),
              )
            ),
          ),
          const SizedBox(height: 50.0),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const Chats()));
            },
            child: Container(
              height: 95.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: const Color.fromARGB(255, 225, 218, 218).withOpacity(0.2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage('assets/profile.png'),
                      radius: 40,
                    ),
                    const SizedBox(width: 10),
                    Text(userName!.email.toString().split('@')[0],
                      style: const TextStyle(
                        fontSize: 25,
                        color: Colors.white
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const Chats()));
            },
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.transparent,
                border: Border.all(width: 1, color: Colors.white)
              ),
              child: const Center(
                child: Text('Zaloguj się na inne konto',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}