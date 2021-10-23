// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:custom_info_window/custom_info_window.dart';

class Mapping extends StatefulWidget {
  Mapping(this._cameraData);

  List _cameraData;
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Mapping> {
  Future _getLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    _liveLat = position.latitude;
    _liveLng = position.longitude;
    return position;
  }

  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  late double _liveLat;
  late double _liveLng;
  Future<Object?>? _liveLocation;
  late LatLng _markerLatLong;
  List _markerLat = [];
  List _markerLng = [];

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  // MapScreenData mapData = MapScreenData();

  @override
  void initState() {
    super.initState();

    setState(() {
      _getMarkersCoordinatesFromData(widget._cameraData);
      _liveLocation = _getLocation();
      _addMarkers(_markerLat, _markerLng);
    });
  }

  _getMarkersCoordinatesFromData(data) {
    for (var i = 0; i < data.length; i++) {
      _markerLat.add(data[i].latitude);
      _markerLng.add(data[i].longitude);
    }
  }

  _addMarkers(lat, lng) {
    for (int j = 0; j < lat.length; j++) {
      myMarker.add(
        Marker(
          markerId: MarkerId("Marker${j}"),
          position: LatLng(lat[j], lng[j]),
          onTap: () {
            _markerLatLong = LatLng(lat[j], lng[j]);
            print(_markerLatLong);
            setState(() {
              _customInfoWindowController.addInfoWindow!(
                Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.account_circle,
                                color: Colors.white,
                                size: 30,
                              ),
                              SizedBox(
                                width: 8.0,
                              ),
                              Text(
                                "I am here",
                                //   style:
                                //       Theme.of(context).textTheme.headline6.copyWith(
                                //             color: Colors.white,
                                //           ),
                              )
                            ],
                          ),
                        ),
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ],
                ),
                _markerLatLong,
              );
            });
          },
        ),
      );
    }
  }

  List<Marker> myMarker = [];

  @override
  Widget build(BuildContext context) => FutureBuilder(
      future: _liveLocation,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          return Scaffold(
            body: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target: LatLng(_liveLat, _liveLng), zoom: 14.0),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  markers: Set.from(myMarker),
                  onTap: (position) {
                    _customInfoWindowController.hideInfoWindow!();
                  },
                  mapType: MapType.hybrid,
                  onCameraMove: (position) {
                    _customInfoWindowController.onCameraMove!();
                  },
                  onMapCreated: (GoogleMapController controller) async {
                    _customInfoWindowController.googleMapController =
                        controller;
                  },
                ),
                CustomInfoWindow(
                  controller: _customInfoWindowController,
                  height: 75,
                  width: 350,
                  offset: 50,
                ),
              ],
            ),
          );
        }
      });
}
