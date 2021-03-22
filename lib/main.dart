import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "./renderList.dart";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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

Future<void> calValue(String val) async {
  CollectionReference myVal = FirebaseFirestore.instance.collection("testApp");
  myVal.add({'calculatedValue': val});
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List randorList = [];
  var currentNumber;

  getList() async {
    var response =
        await Dio().get('https://csrng.net/csrng/csrng.php?min=1&max=1000');
    randorList.add(response.data[0]['random'].toString());
    setState(() {
      currentNumber = response.data[0]['random'].toString();
    });
    calValue(currentNumber);
  }

  Widget myItmes() {
    return Column(
      // Text('You CANNOT put other Widgets here'),
      children: randorList.map((item) => Text(item)).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0, top: 20.0),
                child: GestureDetector(
                    onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => History()),
                );
              },
                  child: Text("History",
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold)),
                )),
          ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                child: Text(
                  'Random Number',
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  getList();
                }),
            Text('$currentNumber '),
            Text("Previous Numbers"),
            myItmes()
          ],
        ),
      ),
    );
  }
}
