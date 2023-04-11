import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchPeople extends StatefulWidget {
  const SearchPeople({super.key});

  @override
  State<SearchPeople> createState() => _SearchPeopleState();
}

class _SearchPeopleState extends State<SearchPeople> {
  String searchController = '';

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').where('name', isEqualTo: searchController).snapshots(),
          builder: (context, snapshot){
            if(!snapshot.hasData){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }else{
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: (value){
                        setState(() {
                          searchController = value;
                        });
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
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index){
                        QueryDocumentSnapshot x = snapshot.data!.docs[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundImage: x['profileImage'].isEmpty ? const AssetImage('assets/profile.png') : NetworkImage(x['profileImage']) as ImageProvider,
                            ),
                            title: Text('${x['name']} ${x['surname']}'),
                          ),
                        );
                      }
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}