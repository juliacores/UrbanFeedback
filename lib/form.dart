import 'dart:async';
import 'dart:io' as io;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:place_picker/place_picker.dart';

import 'constants.dart';

class Forma extends StatefulWidget {

  static String routeName = 'sendForma';
  final DatabaseReference db = FirebaseDatabase().reference();

  @override
  _FormaState createState() => _FormaState();
}

class _FormaState extends State<Forma> {
  @override
  void initState() {
    super.initState();

    // Demonstrates configuring the database directly
    final FirebaseDatabase database = FirebaseDatabase();

    database.reference().child('counter').once().then((DataSnapshot snapshot) {
      print('Connected to second database and read ${snapshot.value}');
    });

    database.setPersistenceCacheSizeBytes(10000000);
  }

  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        fotopath = _image.path;
        print('image ' + fotopath);
      } else {
        print('No image selected.');
      }
    });
  }

  Proverka() {
    if (problem == null) {
      print('No problem');
      setState(() {
        errorP = true;
      });
    } else
      setState(() {
        errorP = false;
      });
    if (category == null) {
      print('No category');
      setState(() {
        errorC = true;
      });
    } else
      setState(() {
        errorC = false;
      });
    if (fotopath == null) {
      print('No fotopath');
      setState(() {
        errorF = true;
      });
    } else
      setState(() {
        errorF = false;
      });
    if (location == null) {
      print('No location');
      setState(() {
        //errorL = true;
      });
    } else
      setState(() {
        errorL = false;
      });
    if (errorP && errorC && errorF && errorL)
      return;
    else
      SendData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Сообщение о проблеме'),
        ),
        body: SafeArea(
          child: ListView(
            children: [
              Question('Категория проблемы'),
              Category(),
              Question('Фотография проблемы'),
              Foto(getImage),
              Question('Описание проблемы'),
              TextInput1(),
              Question('Геолокация'),
              Location(),
              Question('Рекомендация по решению проблемы'),
              TextInput2(),
              Send(Proverka)
            ],
          ),
        ));
  }
}

void SendData() async {
  DatabaseReference dbRef =
      FirebaseDatabase.instance.reference().child('problems');
  print('firebase connected');

  String name = fotopath.split('/').last;
  print('name '+name);
  firebase_storage.Reference firebaseStorageRef =
      firebase_storage.FirebaseStorage.instance.ref().child('photos/$name');
  print('firebase storage inited');
  final metadata = firebase_storage.SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': fotopath});
  firebase_storage.UploadTask uploadTask =
      firebaseStorageRef.putFile(io.File(fotopath), metadata);
  print('upload task created');

  

  firebase_storage.TaskSnapshot taskSnapshot = await Future.value(uploadTask);

  print('send started');
  taskSnapshot.ref.getDownloadURL().then((value) {
    dbRef.push().set({
      "catregory": category,
      "problem": problem,
      "location": location,
      "recomendation": recomendation == null ? '' : recomendation,
      "photo_url": value
    }).then((value) {
      print('send complited');
    });
  });
}

class Foto extends StatelessWidget {
  Function getImage;
  Foto(Function getImage) {
    this.getImage = getImage;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
        child: FlatButton(
            onPressed: getImage,
            child: Row(
              children: [
                Icon(CupertinoIcons.photo_camera),
                Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text('Добавить фото', style: Constants().accenttext))
              ],
            )));
  }
}

class Question extends StatelessWidget {
  String text;
  Question(String text) {
    this.text = text;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
        child: Text(text, style: Constants().maintext));
  }
}

class TextInput1 extends StatefulWidget {
  @override
  _TextInput1State createState() => _TextInput1State();
}

class _TextInput1State extends State<TextInput1> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
        child: TextField(
          onChanged: (String text) {
            problem = text;
          },
          style: Constants().maintext,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide:
                      BorderSide(color: errorP ? Colors.red : Colors.grey)),
              hintText: 'Опишите проблему'),
        ));
  }
}

class TextInput2 extends StatefulWidget {
  @override
  _TextInput2State createState() => _TextInput2State();
}

class _TextInput2State extends State<TextInput2> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
        child: TextField(
          onChanged: (String text) {
            recomendation = text;
          },
          style: Constants().maintext,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Оставьте свою рекомендацию'),
        ));
  }
}

class Category extends StatefulWidget {
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  String val = '';
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(8),
        decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: BorderSide(color: errorC ? Colors.red : Colors.grey))),
        child: DropdownButton<String>(
          underline: null,
          hint: Text('Выберите категорию'),
          value: val == '' ? null : val,
          items: problems.map((String value) {
            return new DropdownMenuItem<String>(
              value: value,
              child: new Text(value),
            );
          }).toList(),
          onChanged: (String value) {
            category = value;
            setState(() {
              val = value;
            });
          },
        ));
  }
}

List<String> problems = <String>[
  'Дороги',
  'Здания',
  'Парки и скверы',
  'Сфетофоры',
  'Пешеходные дорожки',
  'Остановки'
];

class Location extends StatelessWidget {
  void showPlacePicker(BuildContext context) async {
    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            PlacePicker("AIzaSyBgmBTDkqf69_PerM7j-nkgM0_mVM0OnTM")));

    // Handle the result in your way
    print('location ' + result.toString());
    print('location.formattedAddress ' + result.formattedAddress);
    location = result.formattedAddress;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
        child: FlatButton(
            onPressed: () {
              showPlacePicker(context);
            },
            child: Row(
              children: [
                Icon(CupertinoIcons.location),
                Text('Выбрать геолокацию', style: Constants().accenttext)
              ],
            )));
  }
}

class Send extends StatelessWidget {
  Function func;
  Send(Function func) {
    this.func = func;
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: func,
        child: Container(
            alignment: Alignment.center,
            decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                color: Constants.accent),
            margin: EdgeInsets.only(left: 40, right: 40, top: 10),
            padding: EdgeInsets.all(16),
            child: Text('Отправить сообщение', style: Constants().buttontext)));
  }
}

String problem, recomendation, category, fotopath, location;
bool errorP = false, errorC = false, errorF = false, errorL = false;
