import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messenger_clone/ContactItem.dart';
import 'package:messenger_clone/FirebaseHelper.dart';
import 'package:uuid/uuid.dart';

class CreateGroupChat extends StatefulWidget {
  const CreateGroupChat({super.key});

  @override
  State<CreateGroupChat> createState() => _CreateGroupChatState();
}

class _CreateGroupChatState extends State<CreateGroupChat> {
  Service service = Service();
  List<ContactItem> contacts = [];
  List<ContactItem> selectedContacts = [];
  TextEditingController chatController = TextEditingController();
  Uuid chatId = const Uuid();
  Future createContactModels() async {
    var collection = FirebaseFirestore.instance.collection('users');
    var querySnapshot = await collection.get();
    if(contacts.isEmpty){
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data();
        contacts.add(ContactItem(data, false));
      }
    }
  }
  @override
  void initState() {
    createContactModels();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Nowa grupa'),
        actions: [
          TextButton(
            onPressed: () async {
              try{
                if(selectedContacts.isNotEmpty){
                  await FirebaseFirestore.instance.collection('chats').add({
                    'chatName': chatController.text,
                    'chatId': chatId.v4(),
                    'users':  selectedContacts.map((e) => e.snapshot).toList()
                  });
                }
              }catch(e){
                service.errorBox(context, 'Błąd przy wczytywaniu użytkowników.');
              }
            }, 
            child: const Text('UTWÓRZ')
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 45.0,
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade800,
                  prefixIcon: const Icon(Icons.search),
                  labelText: 'Szukaj',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30)
                  )
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: chatController,
              decoration: const InputDecoration(
                hintText: 'Nazwa grupy (opcjonalnie)',
                border: InputBorder.none
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: createContactModels(),
              initialData: contacts,
              builder: (context, snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }else{
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    primary: true,
                    shrinkWrap: true,
                    itemCount: contacts.length,
                    itemBuilder: (context, index){
                      var x = contacts[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          onTap: () {
                            setState(() {
                              x.isSelected = !x.isSelected;
                              if(contacts[index].isSelected == true){
                                selectedContacts.add(contacts[index]);
                              }else{
                                selectedContacts.removeWhere((element) => 
                                  element.snapshot['email'] == contacts[index].snapshot['email']);
                              }
                            });
                          },
                          leading: const CircleAvatar(
                            radius: 25,
                            backgroundImage: AssetImage('assets/profile.png'),
                          ),
                          title: Text('${x.snapshot['name']}'),
                          subtitle: const Text('siema co tam?'),
                          trailing: x.isSelected == true ? const Icon(Icons.check_circle, color: Colors.blue) : const Icon(Icons.check_circle_outline_outlined),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
