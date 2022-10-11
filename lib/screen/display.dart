import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class DisplayScreen extends StatefulWidget {
  const DisplayScreen({super.key});

  @override
  State<DisplayScreen> createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Score Report"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("students").snapshots(), //เลือก collection ใน firestore
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(!snapshot.hasData) { //ถ้าไม่มข้อมูล
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            children: snapshot.data!.docs.map((document) {
              return Container(
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: FittedBox(
                      child: Text(document["score"]),
                    ),
                  ),
                  title: Text(document["fname"] + document["lname"]),
                  subtitle: Text(document["email"]),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
