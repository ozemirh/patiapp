// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:login_screen/screens/saving_scr.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(WelcomeScreen());
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  CollectionReference animals =
      FirebaseFirestore.instance.collection('animal_info');

  final animalInfo = [
    [
      'Luna',
      'Female',
      '1.5 years',
      'She is a very lovely cat, mother of three kittens, quite noble and playful',
      'images/luna.png'
    ],
    [
      'Mila',
      'Female',
      '5.5 months',
      "A grown up kitten, quite energetic and playful, doesn't rest for a moment, and a pile of cloud",
      'images/mila.png'
    ],
    [
      'Alya',
      'Female',
      '2 years',
      'She is playful, not friendly to strangers but if it is someone that she loves she sleeps with them',
      'images/alya.jpg'
    ],
    [
      'Yulaf',
      'Female',
      '4 months',
      'Loves playing, her favourite game is hide and seek. Also she loves hugging and sleeping',
      'images/yulaf.jpg'
    ],
    [
      'Pera',
      'Female',
      '1.5 years',
      'Playful, smart, quite cunning and manipulative',
      'images/pera.jpg'
    ],
    [
      'Leo',
      'Male',
      '2 years',
      "Leo is a playful male, he loves eating and that's why he is fat. He also loves sleeping with people",
      "images/leo.jpg"
    ],
    [
      'Yorke',
      'Male',
      '1.5 years',
      'He is full of love, playful, a bit hyperactive and also quite naive',
      "images/yorke.jpg",
    ]
  ];
  List dataList = [];
  void getData() async {
    final animal_data = await animals.get();
    for (var data in animal_data.docs) {
      dataList.add(data);
      print(data);
    }
    print(animal_data);
  }

  void getImages() async {
    final storageRef =
        firebase_storage.FirebaseStorage.instance.ref().child('files/');
    final listResult = await storageRef.listAll();
  }

  @override
  void initState() {
    getImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget profileWidget(String profileName, profileGender, profileAge,
        profileInfo, profilePicture) {
      return Container(
        width: 475,
        height: 165,
        decoration: BoxDecoration(
          color: Colors.blue,
          border: Border.all(color: Colors.black, width: 1.5),
        ),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 100.0,
                  height: 106.0,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.0),
                      color: Colors.white),
                  child: Image(
                    image: AssetImage(profilePicture),
                    height: 98,
                    fit: BoxFit.cover,
                  ),
                ),
                // child: Image.network(
                //   profilePicture,
                //   height: 98,
                //   fit: BoxFit.cover,
                // )),
                Container(
                  width: 249.0,
                  height: 106.0,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.0),
                      color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      profileInfo,
                      maxLines: 7,
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  profileName,
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
                Text(
                  profileGender,
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
                Text(
                  profileAge,
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0))),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        fixedSize: MaterialStateProperty.all(Size(6.0, 6.0))),
                    onPressed: null,
                    child: Text(
                      'Apply',
                      style: TextStyle(fontSize: 12, color: Colors.blue),
                    ))
              ],
            ),
          )
        ]),
      );
    }

    return MaterialApp(
        theme: ThemeData(fontFamily: 'Milky Honey'),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blue,
              title: Center(
                child: Text(
                  'PatiApp',
                  style: TextStyle(color: Colors.yellowAccent, fontSize: 22),
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: (() {
                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SavingScreen(),
                    ),
                  );
                });
              }),
              child: Icon(Icons.add),
            ),
            body: Column(children: [
              Expanded(
                child: SizedBox(
                    width: 480,
                    // child: StreamBuilder(
                    //   stream: animals.snapshots(),
                    //   builder: ((context,
                    //       AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    //     if (streamSnapshot.hasData) {
                    //       return Padding(
                    //         padding: EdgeInsets.only(
                    //             top: 8.0, right: 8.0, left: 8.0),
                    //         child: ListView.separated(
                    //             itemBuilder: ((context, index) {
                    //               final DocumentSnapshot documentSnapshot =
                    //                   streamSnapshot.data!.docs[index];

                    //               return Column(
                    //                 children: [
                    //                   profileWidget(
                    //                       documentSnapshot['name'],
                    //                       documentSnapshot['gender'],
                    //                       documentSnapshot['age'],
                    //                       documentSnapshot['general_info'],
                    //                       "images/luna.png")
                    //                 ],
                    //               );
                    //             }),
                    //             separatorBuilder: ((context, index) =>
                    //                 Divider()),
                    //             itemCount: streamSnapshot.data!.docs.length),
                    //       );
                    //     }
                    //     return Text('loading..');
                    //   }),
                    // ),
                    child: ListView.separated(
                        itemBuilder: ((context, index) {
                          return Padding(
                              padding: EdgeInsets.only(
                                  top: 8.0, left: 8.0, right: 8.0),
                              child: Column(
                                children: [
                                  profileWidget(
                                    animalInfo[index][0],
                                    animalInfo[index][1],
                                    animalInfo[index][2],
                                    animalInfo[index][3],
                                    animalInfo[index][4],
                                  )
                                ],
                              ));
                        }),
                        separatorBuilder: ((context, index) => Divider()),
                        itemCount: animalInfo.length)),
              ),
            ])));
  }
}
