// ignore_for_file: unnecessary_this, unnecessary_new, prefer_const_constructors, prefer_typing_uninitialized_variables, unused_field

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:zohaib_project/utilities/FirebaseApi.dart';

class Report extends StatefulWidget {
  @override
  _reportState createState() => _reportState();
  final _countryData;
  Report(this._countryData);
}

class _reportState extends State<Report> {
  FirebaseStorage storage = FirebaseStorage.instance;

  late File _imageFile;
  var pickedFile;
  var URL;

  String _path = ' No file';

  File? file;
  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    final path = result.files.single.path;

    setState(() {
      file = File(path!);
    });
  }

  // Future _openGallery(BuildContext context) async {
  //   final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

  //   if (pickedFile == null) return;
  //   setState(() {
  //     File _imageFile = new File(pickedFile!.path);
  //   });
  //   Navigator.of(context).pop();
  // }

  // _openCamera(BuildContext context) async {
  //   final XFile? _image = await _picker.pickImage(source: ImageSource.camera);
  //   this.setState(() {
  //     _imageFile = _image;
  //   });
  //   Navigator.of(context).pop();
  // }

  Future uploadFile() async {
    if (file == null) return;
    final fileName = file!.path;
    final destination = "file/$fileName";
    FirebasApi.uploadFile(destination, file!);
  }
  // Future uploadImageToFirebase(BuildContext context) async {
  //   String fileName = _imageFile.path;
  //   Reference ref = storage.ref().child('uploads/$fileName');
  //   UploadTask uploadTask = ref.putFile(_imageFile);
  //   uploadTask.then((res) {
  //     res.ref.getDownloadURL().then(
  //           (value) => print("Done: $value"),
  //         );
  //   });
  // }

  String _dropdownValueProv = 'Antwerpen';
  String _dropdownValueCity = 'city';
  String _dropdownValueStreet = 'Street';
  String _dropdownValueType = 'FLITS';
  List _provincesNames = [];
  List _citiesNames = [];
  List Type = ["FLITS", "ALCO", "ANDERE"];

  _getCountryData(data) {
    List state;
    state = widget._countryData['provinces'];

    _provincesNames = state.map((e) => e['name']).toList();

    // print(_provincesNames);
  }

  _getCityData() {
    List _cityData;
    _cityData = widget._countryData['${_dropdownValueProv}'];

    _citiesNames = _cityData.map((e) => e['name']).toList();
    _citiesNames.insert(0, 'city');
  }

  @override
  void initState() {
    setState(() {
      _getCountryData(widget._countryData);
    });

    super.initState();
  }

  Widget _dropDownMenuProv() {
    return Container(
      width: 400,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Theme.of(context).primaryColor, width: 3),
      ),

      // dropdown below..
      child: DropdownButton<String>(
          value: _dropdownValueProv,
          icon: Icon(Icons.arrow_drop_down),
          iconSize: 30,
          onChanged: (String? newValue) {
            setState(() {
              _dropdownValueProv = newValue!;
              _dropdownValueCity = 'city';
              _getCityData();
            });
          },
          items: _provincesNames.map<DropdownMenuItem<String>>((value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                overflow: TextOverflow.clip,
                maxLines: 1,
                softWrap: false,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            );
          }).toList()),
    );
  }

  Widget _dropDownMenuCity() {
    return Container(
      width: 400,
      padding: EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Theme.of(context).primaryColor, width: 3),
      ),

      // dropdown below..
      child: DropdownButton<String>(
          value: _dropdownValueCity,
          icon: Icon(Icons.arrow_drop_down),
          iconSize: 30,
          hint: Text("Select City"),
          onChanged: (String? newValue) {
            setState(() {
              _dropdownValueCity = newValue!;
            });
          },
          items: _citiesNames.map<DropdownMenuItem<String>>((value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                overflow: TextOverflow.clip,
                maxLines: 1,
                softWrap: false,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            );
          }).toList()),
    );
  }

  Widget _dropDownMenuType() {
    return Container(
      width: 400,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Theme.of(context).primaryColor, width: 3),
      ),

      // dropdown below..
      child: DropdownButton<String>(
          hint: Text("Select Type"),
          value: _dropdownValueType,
          onChanged: (newValue) {
            setState(() {
              _dropdownValueType = newValue!;
            });
          },
          items: Type.map<DropdownMenuItem<String>>((value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                overflow: TextOverflow.clip,
                maxLines: 1,
                softWrap: false,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            );
          }).toList()),
    );
  }

  Future _showChoiceDialogue(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Choose option"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: GestureDetector(
                        child: Text("Gallery"),
                        onTap: () {
                          selectFile();
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: GestureDetector(
                        child: Text("Camera"),
                        onTap: () {
                          // _openCamera(context);
                        },
                      ),
                    ),
                  ],
                ),
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    final filename = file != null ? file!.path : "No file";
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _dropDownMenuType(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _dropDownMenuProv(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _dropDownMenuCity(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                hintText: "Street",
                border: OutlineInputBorder(
                    // borderSide: BorderSide(color: Colors.teal),
                    ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.fromLTRB(10, 30, 10, 0),
                hintText: "Additional info",
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: Size(360, 50),
                // side: BorderSide(color: Colors.teal),
              ),
              child: Text(
                "Upload Image",
                // style: TextStyle(color: Colors.teal),
              ),
              onPressed: () {
                _showChoiceDialogue(context);
              },
            ),
          ),
          Center(child: Text(filename)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              child: Text(
                "Confirm",
                // style: TextStyle(color: Colors.white),
              ),
              // style: TextButton.styleFrom(backgroundColor: Colors.teal),
              onPressed: () {
                uploadFile();
              },
            ),
          ),
        ],
      ),
    );
  }
}
