import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messenger_clone/FirebaseHelper.dart';
import 'package:messenger_clone/LoginScreen.dart';
import 'package:uuid/uuid.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Service service = Service();
  String? auth = FirebaseAuth.instance.currentUser!.email;
  ImagePicker image = ImagePicker();
  File? file;
  Uuid id = const Uuid();
  
  getImage() async {
    var img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(img!.path);
    });
  }

  uploadImage() async {
    var imageFile = FirebaseStorage.instance.ref().child('images').child('${id.v4()}.jpg');
    UploadTask task = imageFile.putFile(file!);
    TaskSnapshot snapshot = await task;
    var url = await snapshot.ref.getDownloadURL();
    var collection = FirebaseFirestore.instance.collection('users').where('email', isEqualTo: auth);
    var snapshotFirebase = await collection.get();
    for(var doc in snapshotFirebase.docs){
      await FirebaseFirestore.instance.collection('users').doc(doc.id).update({'profileImage': url});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Ja'),
      ),
      body: ListView(
        primary: true,
        shrinkWrap: true,
        children: [
          const SizedBox(height: 20),
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('users').where('email', isEqualTo: auth).snapshots(),
            builder: (context, snapshot){
              if(!snapshot.hasData){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }else{
                var x = snapshot.data!.docs[0];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await getImage();
                        await uploadImage();
                      },
                      child: CircleAvatar(
                        radius: 70,
                        backgroundImage: x['profileImage'].isEmpty ? const AssetImage('assets/profile.png') : NetworkImage(x['profileImage']) as ImageProvider,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '${x['name']} ${x['surname']}',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    ListTile(
                      onTap: (){
                      },
                      title: const Text('Tryb ciemny'),
                      subtitle: const Text('systemowy'),
                      leading: Container(
                        width: 60.0,
                        height: 60.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.0),
                          color: const Color.fromARGB(95, 116, 116, 116),
                        ),
                        child: const Icon(FontAwesomeIcons.moon),
                      ),
                    ),
                    ListTile(
                      onTap: (){},
                      title: const Text('Status aktywności'),
                      subtitle: const Text('Wł.'),
                      leading: Container(
                        width: 60.0,
                        height: 60.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.0),
                          color: const Color.fromARGB(95, 116, 116, 116),
                        ),
                        child: const Icon(Icons.access_time),
                      ),
                    ),
                    ListTile(
                      onTap: (){},
                      title: const Text('Nazwa użytkownika'),
                      subtitle: const Text('systemowy'),
                      leading: Container(
                        width: 60.0,
                        height: 60.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.0),
                          color: const Color.fromARGB(95, 116, 116, 116),
                        ),
                        child: const Icon(Icons.email),
                      ),
                    ),
                    ListTile(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                      },
                      title: const Text('Przełącz konto'),
                      leading: Container(
                        width: 60.0,
                        height: 60.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.0),
                          color: const Color.fromARGB(95, 116, 116, 116),
                        ),
                        child: const Icon(Icons.switch_account),
                      ),
                    ),
                  ],
                );
              }
            } 
          )
        ],
      ),
    );
  }
}