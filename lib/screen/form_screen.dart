import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:test_firebase_app/model/student.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final formkey = GlobalKey<FormState>();
  Student myStudent = Student();
  final Future<FirebaseApp> firebase =
      Firebase.initializeApp(); //prepare firebase
  CollectionReference _studentCollection = FirebaseFirestore.instance.collection("students");

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebase,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text("Error")),
            body: Center(
              child: Text("${snapshot.error}"),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              title: Text("แบบฟอร์มบันทึกคะแนนสอบ"),
            ),
            body: Container(
              padding: EdgeInsets.all(20),
              child: Form(
                key: formkey,
                child: SingleChildScrollView(
                  //ทำให้เลื่อนจอได้
                  child: Column(
                    //เรียงในแนวตั้ง
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Full Name",
                        style: TextStyle(fontSize: 20),
                      ),
                      TextFormField(
                        validator: RequiredValidator(
                            errorText: "Please give your full name"),
                        onSaved: (fname) {
                          myStudent.fname = fname;
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Last Name",
                        style: TextStyle(fontSize: 20),
                      ),
                      TextFormField(
                        validator: RequiredValidator(
                            errorText: "Please give your last name"),
                        onSaved: (lname) {
                          myStudent.lname = lname;
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Email",
                        style: TextStyle(fontSize: 20),
                      ),
                      TextFormField(
                        // validator: EmailValidator(errorText: "False format of email"),
                        validator: MultiValidator([
                          //เช็ค validator หลายกรณี
                          EmailValidator(errorText: "False Format of email"),
                          RequiredValidator(errorText: "Please give your email")
                        ]),
                        keyboardType:
                            TextInputType.emailAddress, //เปลี่ยนรูปแบบ keyboard
                        onSaved: (email) {
                          myStudent.email = email;
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Score",
                        style: TextStyle(fontSize: 20),
                      ),
                      TextFormField(
                        validator: RequiredValidator(
                            errorText: "Please give your score"),
                        keyboardType: TextInputType.number,
                        onSaved: (score) {
                          myStudent.score = score;
                        },
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          child: Text(
                            "Submit",
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () async{
                            if (formkey.currentState!.validate()) {
                              formkey.currentState!.save();
                              await _studentCollection.add({ //ส่งค่าไป firestore ในรูปแบบ JSON Object(Key, Value)
                                "fname": myStudent.fname,
                                "lname": myStudent.lname,
                                "email": myStudent.email,
                                "score": myStudent.score,
                              });
                              formkey.currentState!.reset();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
