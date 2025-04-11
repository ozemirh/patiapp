// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, avoid_print

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(SavingScreen());
}

class SavingScreen extends StatefulWidget {
  const SavingScreen({super.key});

  @override
  State<SavingScreen> createState() => _SavingScreenState();
}

class _SavingScreenState extends State<SavingScreen> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  late String name, gender, age, generalInfo;
  ImagePicker picker = ImagePicker();
  Image? picture;
  XFile? image;
  String dropdownValue = 'Male';
  var items = ['Male', 'Female'];

  CollectionReference animals =
      FirebaseFirestore.instance.collection('animal_info');
  Future<void> addUser() {
    // Call the user's CollectionReference to add a new user
    return animals
        .add({
          'name': name,
          'gender': gender,
          'age': age,
          'general_info': generalInfo,
        })
        .then((value) => print("Animal Added"))
        .catchError((error) => print("Failed to add animal: $error"));
  }

  Future uploadFile() async {
    if (image == null) return;
    final fileName = basename(image!.path);
    final destination = 'files/$basename';

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('file/');
      await ref.putFile(File(image!.path));
    } catch (e) {
      print('error occured');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(fontFamily: 'Milky Honey'),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  width: 350.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.5),
                      color: Colors.blue),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 8.0, top: 8.0),
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 1.0),
                                color: Colors.white),
                            child: Column(
                              children: [
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      image = await picker.pickImage(
                                          source: ImageSource.gallery);
                                      setState(() {
                                        //update UI
                                      });
                                    },
                                    style: ButtonStyle(
                                      fixedSize: MaterialStateProperty.all(
                                          Size(75.0, 40.0)),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.blueAccent),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16.0))),
                                    ),
                                    child: Center(
                                        child: Text(
                                      'Upload picture',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    )),
                                  ),
                                ),
                                image == null
                                    ? Container()
                                    : Image.file(
                                        File(image!.path),
                                        fit: BoxFit.fitWidth,
                                        height: 98,
                                      ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 8.0, top: 8.0),
                            width: 217.5,
                            height: 100.0,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 1.0),
                                color: Colors.white),
                            child: Expanded(
                              child: TextField(
                                onChanged: (value) {
                                  generalInfo = value;
                                },
                                maxLines: 7,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(5.0),
                                  hintText:
                                      'Write down general information about the animal.',
                                  hintStyle: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                style: TextStyle(
                                  overflow: TextOverflow.clip,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, top: 8.0, right: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: TextField(
                                onChanged: (value) {
                                  name = value;
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  constraints: BoxConstraints.tightFor(
                                      width: 90.0, height: 15.0),
                                  hintText: 'Name',
                                  hintStyle: TextStyle(
                                      fontSize: 15, color: Colors.white),
                                ),
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white),
                              ),
                            ),
                            DropdownButton(
                              isDense: true,
                              dropdownColor: Colors.blue,
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.white,
                              ),
                              value: dropdownValue,
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue!;
                                  gender = dropdownValue;
                                });
                              },
                              items: items.map((String item) {
                                return DropdownMenuItem(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.white),
                                    ));
                              }).toList(),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: TextField(
                                onChanged: (value) {
                                  age = value;
                                },
                                textAlign: TextAlign.end,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  constraints: BoxConstraints.tightFor(
                                      width: 80.0, height: 15.0),
                                  hintText: 'Age',
                                  hintStyle: TextStyle(
                                      fontSize: 15, color: Colors.white),
                                ),
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: (() {
                    addUser();
                    uploadFile();
                  }),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0))),
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                      fixedSize: MaterialStateProperty.all(Size(75.0, 35.0))),
                  child: Text(
                    'Save',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  )),
            ],
          ),
        ));
  }
}
