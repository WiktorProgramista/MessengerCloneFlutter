import 'package:flutter/material.dart';
import 'package:messenger_clone/FirebaseHelper.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController surname = TextEditingController();
  TextEditingController password1 = TextEditingController();
  TextEditingController password2 = TextEditingController();
  Service service = Service();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
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
                      hintText: 'Wpisz adres email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    controller: name,
                    decoration: InputDecoration(
                      hintText: 'Wpisz imię',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    controller: surname,
                    decoration: InputDecoration(
                      hintText: 'Wpisz nazwisko',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    obscureText: true,
                    controller: password1,
                    decoration: InputDecoration(
                      hintText: 'Wpisz hasło',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    obscureText: true,
                    controller: password2,
                    decoration: InputDecoration(
                      hintText: 'Powtórz hasło',
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
                      if(email.text.isNotEmpty && password1.text.isNotEmpty && name.text.isNotEmpty && surname.text.isNotEmpty){
                        if(password1.text == password2.text){
                          service.createUser(context, name.text, surname.text, email.text, password1.text);
                        }else{
                          service.errorBox(context, 'hasła do siebie nie pasują!');
                        }
                      }else{
                        service.errorBox(context, 'Wprowadzono błędne dane.');
                      }
                    },
                    child: const Text('Zarejestruj się'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

