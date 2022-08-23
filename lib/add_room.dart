import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tap_to_home/status.dart';

class AddRoom extends StatefulWidget {
  const AddRoom({Key? key}) : super(key: key);

  @override
  _AddRoomState createState() => _AddRoomState();
}

class _AddRoomState extends State<AddRoom> {

  TextEditingController _roomnamecontroller = TextEditingController();

  String ? _value;

  sendRoomdataDB() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;


    CollectionReference _collectionRef =
    FirebaseFirestore.instance.collection("room-data");
    return _collectionRef
        .doc()
        .set(
        {
          "room-name": _roomnamecontroller.text,
          "room-category": _value,
          "for-user": currentUser?.email,
          "room-id": _rooms.length.toString()
        }
    )
        .then((value) => Navigator.push(context, MaterialPageRoute(builder: (context)=>Status())))
        .catchError((error) => Fluttertoast.showToast(msg: "Something went wrong"));
  }

  List _rooms = [];

  fetchProducts() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;

    var _firestoreInstance = FirebaseFirestore.instance;
    QuerySnapshot qn = await _firestoreInstance.collection("room-data").get();
    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        if(qn.docs[i]["for-user"] == currentUser?.email){
          _rooms.add({
            "room-name": qn.docs[i]["room-name"],
            "room-cat": qn.docs[i]["room-category"],
          });
        }
      }
    });
    return qn.docs;
  }

  @override
  void initState() {
    fetchProducts();
    super.initState();
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
                      text: "Add new room",
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
                    controller: _roomnamecontroller,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Room name"
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
                    hint:Text("Select Room Category"),
                    items: [
                      DropdownMenuItem(
                        child: Text("Bed room"),
                        value: "bedroom",
                      ),

                      DropdownMenuItem(
                        child: Text("Kitchen"),
                        value: "kitchen",
                      ),

                      DropdownMenuItem(
                        child: Text("Dining room"),
                        value: "diningroom",
                      ),

                      DropdownMenuItem(
                        child: Text("Washroom"),
                        value: "washroom",
                      ),

                      DropdownMenuItem(
                        child: Text("Garage"),
                        value: "garage",
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
                    sendRoomdataDB();
                  },
                  child: Text("ADD ROOM",style: TextStyle(color: Colors.white),)
              ),
            )
          ],
        ),
      ),
    );
  }
}
