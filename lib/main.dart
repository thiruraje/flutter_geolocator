import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:android_intent/android_intent.dart';
import 'package:location_permissions/location_permissions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
      
        primarySwatch: Colors.blue,
       
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Position position;
  StreamSubscription<Position> _streamSubscription;


   Geolocator geolocator = Geolocator();

  Position userLocation;
  // Address _address;
  initState()  {
    super.initState();
  
     _gpsService();

  }
  Future _gpsService() async {
  
  if (!(await Geolocator().isLocationServiceEnabled())) {
    print("no");
    _checkGps();
    // return null;
  } else
    print("connect");
    var currentLocation;
    try {
      
      currentLocation = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      print(currentLocation);
       setState(() {
          userLocation = currentLocation;
        });
    } catch (e) {
      currentLocation = null;
    }
  }

  Future _checkGps() async {
    if (!(await Geolocator().isLocationServiceEnabled())) {
      if (Theme.of(context).platform == TargetPlatform.android) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
          title: Text("Can't get gurrent location"),
          content:const Text('Please make sure you enable GPS and try again'),
          actions: <Widget>[
            FlatButton(child: Text('Ok'),
            onPressed: () {
              Navigator.pop(context);
              final AndroidIntent intent = AndroidIntent(
                action: 'android.settings.LOCATION_SOURCE_SETTINGS');
                intent.launch();
            
            _gpsService();
            })],
          );
        });
        }
      }
  }
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            userLocation == null
                ? CircularProgressIndicator()
                : Text("Lat : " +
                    userLocation.latitude.toString() +
                    " \n Lang : " +
                    userLocation.longitude.toString()),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                onPressed: () {
                  _gpsService();
                },
                color: Colors.blue,
                child: Text(
                  "Get Location",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
