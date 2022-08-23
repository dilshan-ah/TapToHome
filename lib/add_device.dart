import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddDevice extends StatefulWidget {
  var roomid;
  AddDevice(this.roomid);

  @override
  _AddDeviceState createState() => _AddDeviceState();
}

class _AddDeviceState extends State<AddDevice> {

  String ? _value;

  TextEditingController _devicenamecontroller = TextEditingController();
  TextEditingController _devicemodelcontroller = TextEditingController(text: "model?");


  sendDevicedataDB() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;


    CollectionReference _collectionRef =
    FirebaseFirestore.instance.collection("device-data");
    return _collectionRef
        .doc()
        .set(
        {
          "device-name": _devicenamecontroller.text,
          "device-model": _devicemodelcontroller.text,
          "device-category": _value,
          "status": false,
          "room-id": widget.roomid["room-id"].toString()
        }
    )
        .then((value) => Navigator.pop(context))
        .catchError((error) => Fluttertoast.showToast(msg: "Something went wrong"));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios,color: Theme.of(context).primaryColor,),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Hero(
                tag: new Text("hometitle"),
                child: RichText(
                  text: TextSpan(
                      text: "Add new device",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Oswald",
                          fontSize: 22)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: TextField(
                    controller: _devicenamecontroller,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Device name"
                    ),
                  )
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: TextField(
                    controller: _devicemodelcontroller,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Device Model"
                    ),
                  )
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(20)
                ),
                child: DropdownButton(
                    value: _value,
                    isExpanded: true,

                    underline: Container(color: Colors.transparent,),
                    hint:Text("Select Device Category"),
                    items: [
                      DropdownMenuItem(
                        child: Text("Light"),
                        value: "light",
                      ),

                      DropdownMenuItem(
                        child: Text("Fan"),
                        value: "fan",
                      ),

                      DropdownMenuItem(
                        child: Text("Tv"),
                        value: "tv",
                      ),

                      DropdownMenuItem(
                        child: Text("Refrigerator"),
                        value: "refrigerator",
                      ),

                      DropdownMenuItem(
                        child: Text("Router"),
                        value: "router",
                      ),
                    ],
                    onChanged: (value){
                      setState(() {
                        _value = value as String?;
                      });
                    }
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),
                  minWidth: double.infinity,
                  height: 50,
                  color: Theme.of(context).primaryColor,
                  onPressed: (){
                    sendDevicedataDB();
                  },
                  child: Text("ADD DEVICE",style: TextStyle(color: Colors.white),)
              ),
            )
          ],
        ),
      ),
    );
  }
}
