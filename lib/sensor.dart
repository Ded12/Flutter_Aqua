import 'dart:async';
import 'dart:convert' show utf8;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:vibration/vibration.dart';

import 'homeui.dart';

class SensorPage extends StatefulWidget {
  const SensorPage({Key key, this.device}) : super(key: key);
  final BluetoothDevice device;

  @override
  _SensorPageState createState() => _SensorPageState();
}

class _SensorPageState extends State<SensorPage> {
  String service_uuid = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
  String charaCteristic_uuid = "beb5483e-36e1-4688-b7f5-ea07361b26a8";
  bool isReady;
  Stream<List<int>> stream;
  List _val;
  String t ;

  @override
  void initState() {
    super.initState();
    isReady = false;
    connectToDevice();
  }

  void dispose() {
    widget.device.disconnect();
    super.dispose();
  }

  connectToDevice() async {
    if (widget.device == null) {
      _pop();
      return;
    }

    new Timer(const Duration(seconds: 15), () {
      if (!isReady) {
        disconnectFromDevice();
        _pop();
      }
    });

    await widget.device.connect();
    discoverServices();
  }

  disconnectFromDevice() {
    if (widget.device == null) {
      _pop();
      return;
    }

    widget.device.disconnect();
  }

  discoverServices() async {
    if (widget.device == null) {
      _pop();
      return;
    }

    List<BluetoothService> services = await widget.device.discoverServices();
    services.forEach((service) {
      if (service.uuid.toString() == service_uuid) {
        service.characteristics.forEach((characteristic) {
          if (characteristic.uuid.toString() == charaCteristic_uuid) {
            characteristic.setNotifyValue(!characteristic.isNotifying);
            stream = characteristic.value;

            setState(() {
              isReady = true;
            });
          }
        });
      }
    });

    if (!isReady) {
      _pop();
    }
  }

  Future<bool> _onWillPop() {
    return showDialog(
        context: context,
        builder: (context) =>
            new AlertDialog(
              title: Text('Are you sure?'),
              content: Text('Do you want to disconnect device and go back?'),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: new Text('No')),
                new FlatButton(
                    onPressed: () {
                      disconnectFromDevice();
                      Navigator.of(context).pop(true);
                    },
                    child: new Text('Yes')),
              ],
            ) ??
            false);
  }

  _pop() {
    Navigator.of(context).pop(true);
  }

  String val(List<int> dataFromDevice) {
    return utf8.decode(dataFromDevice);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.indigo.shade800,
        appBar: AppBar(

          title: Text('Sensor Value',
        ),

        elevation: 0,
        backgroundColor: Colors.indigo.shade800,
      ),
        body: Container(
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.only(
          //     topLeft: Radius.circular(60),
          //     topRight: Radius.circular(60),
          //   ),
          //  color: Colors.white,
         // ),
            child: !isReady
                ? Center(

                    child: Text(
                      "Conecting...",
                      style: TextStyle(fontSize: 24, fontFamily: 'assets/fonts/mo_li.ttf', color: Colors.black),
                    ),
                  )
                : Container(

                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: StreamBuilder<List<int>>(
                      stream: stream,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<int>> snapshot) {
                        if (snapshot.hasError)
                          return Text('Error: ${snapshot.error}');
                        if (snapshot.connectionState == ConnectionState.active) {
                          var currentValue = val(snapshot.data);
                          print('$currentValue');
                          if(currentValue != false){
                            t = '$currentValue';
                            Vibration.vibrate(pattern: [500, 1000, 500, 2000]);
                          }

                          return HomeUI(
                            val: t,

                          );
                        } else {
                          return Text('Check the stream');
                        }
                      },
                    ),

                  ),
      ),


    ));
    
  }

}
