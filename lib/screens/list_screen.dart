// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_string_interpolations, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ListScreen extends StatefulWidget {
  ListScreen(this._cameraData, this._countryData);

  final List _cameraData;
  final _countryData;
  @override
  _list_screenState createState() => _list_screenState();
}

class _list_screenState extends State<ListScreen> {
  String _dropdownValueProv = 'Antwerpen';
  String _dropdownValueCity = 'city';
  String _dropdownValueType = 'FLITS';

  List _fdisplayType = [];
  List _fdisplayCity = [];
  List _fdisplayProv = [];
  List _message = [];
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

  void filterProv() {
    _fdisplayType.isNotEmpty
        ? _fdisplayType.removeAt(0) //removes the item at index 1
        : null;
    _fdisplayProv.isNotEmpty
        ? _fdisplayProv.removeAt(0) //removes the item at index 1
        : null;
    _fdisplayCity.isNotEmpty
        ? _fdisplayCity.removeAt(0) //removes the item at index 1
        : null;
    for (var i = 0; i < widget._cameraData.length; i++) {
      if (widget._cameraData[i].city == _dropdownValueProv) {
        setState(() {
          _fdisplayType.insert(0, widget._cameraData[i].type);
          _fdisplayProv.insert(0, widget._cameraData[i].province);
          _fdisplayCity.insert(0, widget._cameraData[i].city);
        });
      }
    }
  }

  Widget _dropDownMenuProv() {
    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Theme.of(context).primaryColor, width: 3),
      ),

      // dropdown below..
      child: DropdownButton<String>(
          value: _dropdownValueProv,
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 30,
          onChanged: (String? newValue) {
            setState(() {
              _dropdownValueProv = newValue!;
              _dropdownValueCity = 'city';
              _getCityData();
              filterProv();
              filterCheck = true;
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
      // padding: EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Theme.of(context).primaryColor, width: 3),
      ),

      // dropdown below..
      child: Expanded(
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
      ),
    );
  }

  bool filterCheck = false;

  Widget getChildType(int position) {
    if (filterCheck == true) {
      return Text(
        '${_fdisplayType[position]}-',
        style: TextStyle(fontSize: 18.0),
      );
    } else {
      return Text('${widget._cameraData[position].type}-',
          textAlign: TextAlign.end,
          style:
              TextStyle(fontSize: 22.0, color: Theme.of(context).primaryColor));
    }
  }

  Widget getChildProv(position) {
    if (filterCheck == true) {
      return Text(
        '${_fdisplayProv[position]}-',
        style: TextStyle(fontSize: 18.0),
      );
    } else {
      return Text(
        '${widget._cameraData[position].province}-',
        style: TextStyle(fontSize: 18.0),
      );
    }
  }

  Widget getChildCity(position) {
    if (filterCheck == true) {
      return Text(
        '${_fdisplayCity[position]}-',
        style: TextStyle(fontSize: 18.0),
      );
    } else {
      return Text(
        '${widget._cameraData[position].city}-',
        style: TextStyle(fontSize: 18.0),
      );
    }
  }

  int itembuildLength() {
    if (filterCheck == true) {
      return _fdisplayType.length;
    } else {
      return widget._cameraData.length;
    }
  }

  Widget _dropDownMenuType() {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Theme.of(context).primaryColor, width: 3),
      ),

      // dropdown below..
      child: DropdownButton<String>(
          value: _dropdownValueType,
          hint: Text("Select Type"),
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

  @override
  void initState() {
    widget._cameraData;
    setState(() {
      _getCountryData(widget._countryData);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: itembuildLength(),
              itemBuilder: (context, position) {
                return Card(
                  child: InkWell(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => MarkerData(
                      //       data: dat,
                      //     ),
                      //   ),
                      // );
                    },
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: getChildType(position)),
                        ),
                        Row(
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 5.0, right: 5.0),
                                child: getChildCity(position)),
                            getChildProv(position)
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _dropDownMenuType(),
              _dropDownMenuProv(),
              Expanded(child: _dropDownMenuCity()),
            ],
          ),
        ],
      ),
    );
  }
}
