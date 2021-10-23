// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:zohaib_project/providers/camera_data.dart';
import 'package:zohaib_project/screens/report_screen.dart';
import 'package:zohaib_project/screens/settings_screen.dart';
import 'dart:developer' as developer;

import 'list_screen.dart';
import 'map_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List _cameraData = [];
  late Map<String, dynamic> _countryData;

  Future _ReadJsonData() async {
    //read json file

    final jsondata = await rootBundle.loadString('jsonfile/belgium.json');
    //decode json data as list
    // print(jsondata);
    _countryData = json.decode(jsondata);

    // state = _countryData['provinces'];
    // print(state);
    // provs = state.map((e) => e['name']).toList();
    // // print(provs);
    // cities = _countryData['${provs[3]}'];
    // Acities = cities.map((e) => e['name']).toList();
    // // print(Acities);
    // print(cities.map((e) => e[0]['name']).toList());
    // print(list['${provs[0]}']);
    // print(provs);
    // _countryData = CountryInfo.fromJson(list);
    // print(_countryData.Antwerpen);
    // print(_countryData.provinces[0]['name']);
    //map json and initialize using DataModel
    // list.map((e) => CountryInfo.fromJson(e)).toList();
    // print(list);
  }
  // Future<List<CountryInfo>>

  _getData() async {
    CollectionReference<Map<String, dynamic>> collection =
        FirebaseFirestore.instance.collection("posts");
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await collection.get();

    for (var queryDocumentSnapshot in querySnapshot.docs) {
      List _message = queryDocumentSnapshot.data()['message'].split("-");
      _cameraData.add(CameraData(
        queryDocumentSnapshot.data()['address'],
        queryDocumentSnapshot.data()['created_time'],
        queryDocumentSnapshot.data()['item'],
        queryDocumentSnapshot.data()['message'],
        queryDocumentSnapshot.data()['post_id'],
        queryDocumentSnapshot.data()['location']['lat'],
        queryDocumentSnapshot.data()['location']['lng'],
        _message[0].trim(),
        _message[1].trim(),
        _message[2].trim(),
      ));
    }
  }

  @override
  void initState() {
    _getData();

    super.initState();
  }

  int _selectedIndex = 0;

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
      future: _ReadJsonData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text("Polcon"),
              actions: [
                PopupMenuButton(
                    icon: Icon(Icons.more_vert),
                    onSelected: (value) {
                      if (value == 1) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingScreen()),
                        );
                      }
                    },
                    itemBuilder: (context) => [
                          PopupMenuItem(
                            child: Text("Settings"),
                            value: 1,
                          ),
                        ])
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _selectedIndex,
              onTap: _onItemTap,
              items: [
                new BottomNavigationBarItem(
                  icon: new Icon(Icons.book_outlined),
                  label: ("NEWS"),
                ),
                new BottomNavigationBarItem(
                  icon: new Icon(Icons.list_alt_outlined),
                  label: ("List"),
                ),
                new BottomNavigationBarItem(
                  icon: new Icon(Icons.report_problem),
                  label: ("Report"),
                ),
                new BottomNavigationBarItem(
                  icon: new Icon(Icons.map),
                  label: ("Map"),
                ),
              ],
            ),
            body: [
              WebView(
                initialUrl: 'https://www.vanmorgen.be/auto/',
                initialMediaPlaybackPolicy:
                    AutoMediaPlaybackPolicy.always_allow,
                javascriptMode: JavascriptMode.unrestricted,
                onPageFinished: (message) {
                  developer.log(message);
                },
              ),
              ListScreen(_cameraData, _countryData),
              Report(_countryData),
              Mapping(_cameraData),
            ].elementAt(_selectedIndex),
          );
        }
      });
}
