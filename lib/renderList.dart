import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class History extends StatefulWidget {
  History({Key key}) : super(key: key);
  @override
  _HistoryCalculation createState() => _HistoryCalculation();
}

class _HistoryCalculation extends State<History> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("History"),
      ),
    
       body: Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('testApp')
              .snapshots(),
            builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return new Text('Loading...');
                  default:
                    return new ListView(
                      children: snapshot.data.docs
                        .map((DocumentSnapshot document) {
                          return new ListTile(   leading: Icon(Icons.calculate_outlined,color: Colors.black,),title: Text(document['calculatedValue'],style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)));
                          
                      }).toList(),
                    );
                }
              },
            )),
          ),
    
    );    }
}
