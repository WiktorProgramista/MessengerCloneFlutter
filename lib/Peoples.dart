import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Peoples extends StatefulWidget {
  const Peoples({super.key});

  @override
  State<Peoples> createState() => _PeoplesState();
}

class _PeoplesState extends State<Peoples> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }else{
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index){
                QueryDocumentSnapshot x  = snapshot.data!.docs[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: x['profileImage'].isEmpty ? const AssetImage('assets/profile.png') : NetworkImage(x['profileImage']) as ImageProvider,
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
                    title: Text('${x['name']} ${x['surname']}'),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}