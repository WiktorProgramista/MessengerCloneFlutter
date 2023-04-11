import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger_clone/ChatScreen.dart';
import 'package:messenger_clone/CreateGroupChat.dart';
import 'package:messenger_clone/FirebaseHelper.dart';
import 'package:messenger_clone/LogOut.dart';
import 'package:messenger_clone/Profile.dart';
import 'package:messenger_clone/SearchPeople.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Chats extends StatefulWidget {
  const Chats({super.key});

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final email =  FirebaseAuth.instance.currentUser!.email;
  Service service = Service();
  String searchController = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            _key.currentState!.openDrawer();
          },
          icon: const Icon(Icons.menu),
        ),
        title: const Text('Czaty'),
        actions: [
          IconButton(
            onPressed: (){}, 
            icon: const Icon(Icons.camera_alt)
          ),
          IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateGroupChat()));
            }, 
            icon: const Icon(Icons.edit)
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
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPeople()));
                },
                decoration: InputDecoration(
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
          SizedBox(
            height: 100.0,
            width: MediaQuery.of(context).size.width,
            child: showActiveUsers()
          ),
          Expanded(child: showUserChats(email)),
        ],
      ),
      drawer: Drawer(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').where('email', isEqualTo: email).snapshots(),
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }else{
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index){
                  QueryDocumentSnapshot x = snapshot.data!.docs[index];
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: x['profileImage'].isEmpty ? const AssetImage('assets/profile.png') : NetworkImage(x['profileImage']) as ImageProvider,
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: Text('${x['name']} ${x['surname']}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const LogOut()));
                              }, 
                              icon: const Icon(Icons.keyboard_arrow_down)
                            ),
                            IconButton(
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const Profile()));
                              }, 
                              icon: const Icon(Icons.settings)
                            ),
                          ],
                        ),
                      ),    
                      const SizedBox(height: 10),
                      ListTile(
                        onTap: (){},
                        leading: Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade700,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(Icons.chat),
                        ),
                        title: const Text('Czaty', style: TextStyle(fontSize: 20)),
                      ),
                      ListTile(
                        onTap: (){},
                        leading: Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade700,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(Icons.shop_sharp),
                        ),
                        title: const Text('Marketplace', style: TextStyle(fontSize: 20)),
                      ),
                      ListTile(
                        onTap: (){},
                        leading: Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade700,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(Icons.message_outlined),
                        ),
                        title: const Text('Inne', style: TextStyle(fontSize: 20)),
                      ),
                      ListTile(
                        onTap: (){},
                        leading: Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade700,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(Icons.archive),
                        ),
                        title: const Text('Archiwum', style: TextStyle(fontSize: 20)),
                      ),
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

Widget showActiveUsers(){
  return StreamBuilder(
    stream: FirebaseFirestore.instance.collection('users').snapshots(),
    builder: (context, snapshot){
      if(!snapshot.hasData){
        return const Center(
          child: CircularProgressIndicator(),
        );
      }else{
        return ListView.builder(
          padding: EdgeInsets.zero,
          primary: true,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index){
            QueryDocumentSnapshot x = snapshot.data!.docs[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: x['profileImage'].isEmpty ? const AssetImage('assets/profile.png') : NetworkImage(x['profileImage']) as ImageProvider,
                    radius: 30,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.bottomRight,
                          child: CircleAvatar(
                            radius: 7,
                            backgroundColor: x['activeStatus'] == 'Online' ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text('${x['name']} ${x['surname']}')
                ],
              ),
            );
          },
        );
      }
    },
  );
}

Widget showUserChats(email){
  return StreamBuilder(
    stream: FirebaseFirestore.instance.collection('chats').snapshots(),
    builder: (context, snapshot){
      if(!snapshot.hasData){
        return const Center(
          child: CircularProgressIndicator(),
        );
      }else{
        return ListView.builder(
          padding: EdgeInsets.zero,
          primary: true,
          shrinkWrap: true,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index){
            QueryDocumentSnapshot x = snapshot.data!.docs[index];
            var documentId = x.id;
            var chatId = x['chatId'];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                child: ListTile(
                  onLongPress: (){
                    showDialog(
                      barrierDismissible: true,
                      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                      context: context,
                      builder: (context){
                        return SlidingUpPanel(
                          defaultPanelState: PanelState.OPEN,
                          borderRadius: const BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
                          color: ThemeData.dark().primaryColor,
                          panel: Column(
                            children: [
                              Material(
                                child: ListTile(
                                  onTap: (){},
                                  leading: const Icon(Icons.archive),
                                  title: const Text('Archiwizuj'),
                                ),
                              ),
                              Material(
                                child: ListTile(
                                  onTap: (){
                                    showDialog(
                                      context: context, 
                                      builder: (context){
                                        return AlertDialog(
                                          title: const Text('Usunąć całą tę konwersację?'),
                                          content: const Expanded(
                                            child: Text(
                                              'Jeśli usuniesz swoją kopię konwersacji, nie będzie można tego cofnąć.',
                                              style: TextStyle(
                                                color: Colors.grey
                                              ),
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: (){
                                                Navigator.pop(context);
                                              }, 
                                              child: const Text('ANULUJ')
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                FirebaseFirestore.instance.collection('chats').doc(documentId).delete();
                                                var collection =  FirebaseFirestore.instance.collection('messages').where('chatId', isEqualTo: chatId);
                                                var snapshot = await collection.get();
                                                for(var document in snapshot.docs){
                                                  await FirebaseFirestore.instance.collection('messages').doc(document.id).delete();
                                                }
                                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const Chats()));
                                              }, 
                                              child: const Text('USUŃ')
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  leading: const Icon(Icons.delete),
                                  title: const Text('Usuń'),
                                ),
                              ),
                              Material(
                                child: ListTile(
                                  onTap: (){},
                                  leading: const Icon(Icons.volume_mute_rounded),
                                  title: const Text('Wycisz powiadomienia'),
                                ),
                              ),
                              Material(
                                child: ListTile(
                                  onTap: (){},
                                  leading: const Icon(Icons.block),
                                  title: const Text('Zablokuj'),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    );
                  },
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(x)));
                  },
                  leading: const CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage('assets/profile.png'),
                  ),
                  title: Text('${x['chatName']}'),
                  subtitle: const Text('siema co tam?'),
                ),
              ),
            );
          },
        );
      }
    },
  );
}

