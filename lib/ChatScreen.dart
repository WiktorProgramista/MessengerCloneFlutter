import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messenger_clone/FirebaseHelper.dart';
import 'package:uuid/uuid.dart';

class ChatScreen extends StatefulWidget {

  final QueryDocumentSnapshot chatMap;
  const ChatScreen(this.chatMap, {super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final userName = FirebaseAuth.instance.currentUser;
  Service service = Service();
  Uuid id = const Uuid();
  TextEditingController message = TextEditingController();
  ImagePicker image = ImagePicker();
  File? file;

  getImage() async {
    var img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(img!.path);
    });
}

  uploadImage() async {
    if(file == null){
      return;
    }
    if(file != null){
      var imageFile = FirebaseStorage.instance.ref().child('images').child('${id.v4()}.jpg');
      UploadTask task = imageFile.putFile(file!);
      TaskSnapshot snapshot = await task;
      var url = await snapshot.ref.getDownloadURL();
      await FirebaseFirestore.instance.collection('messages').add({
        'user': userName!.email,
        'uid': userName!.uid,
        'date': DateTime.now(),
        'message': url,
        'type': 'image',
        'chatId': widget.chatMap['chatId']
      });
    }
    file = null;
  }

  uploadMessage() async {
    await FirebaseFirestore.instance.collection('messages').add({
      'user': userName!.email,
      'uid': userName!.uid,
      'date': DateTime.now(),
      'message': message.text,
      'type': 'text',
      'chatId': widget.chatMap['chatId']
    });
    message.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: (){
              
            }, 
            icon: const Icon(FontAwesomeIcons.circleInfo),
          )
        ],
        title: Text(widget.chatMap['chatName'].toString()),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: showMessages(userName!, widget.chatMap['chatId']),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row( 
              children: [
                Expanded(
                  child: Row(
                    children: [
                      IconButton(onPressed: (){}, icon: const Icon(Icons.camera_alt)),
                      IconButton(
                        onPressed: () async {
                          await getImage();
                          await uploadImage();
                        }, 
                        icon: const Icon(Icons.image)
                      ),
                      IconButton(onPressed: (){}, icon: const Icon(Icons.mic)),
                    ],
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 45.0,
                    child: TextField(
                      controller: message,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          
                        )
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: (){
                    uploadMessage();
                    uploadImage();
                  }, 
                  icon: const Icon(Icons.send),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget showMessages(User userName, String chatId){
  return StreamBuilder(
    stream: FirebaseFirestore.instance.collection('messages').where('chatId', isEqualTo: chatId).orderBy('date').snapshots(),
    builder: (context, snapshot){
      if(!snapshot.hasData){
        return const Center(
          child: CircularProgressIndicator(),
        );
      }else{
        return ListView.builder(
          primary: true,
          shrinkWrap: true,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index){
            QueryDocumentSnapshot x = snapshot.data!.docs[index];
            if(x['type'] == 'text'){
              return ListTile(
                title: Column(
                  crossAxisAlignment: userName.uid == x['uid']  ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(x['user'].toString().split("@")[0]),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: userName.uid == x['uid'] ? Colors.blue : Colors.grey[800],
                      ),
                      child: Text(x['message'])
                    ),
                  ],
                ),
              );
            }else{
              return ListTile(
                title: Column(
                  crossAxisAlignment: userName.uid == x['uid']  ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(x['user'].toString().split("@")[0]),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.50,
                        height: MediaQuery.of(context).size.height * 0.50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(x['message']),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        );
      }
    },
  );
}