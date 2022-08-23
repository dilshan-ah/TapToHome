import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:switcher_button/switcher_button.dart';
import 'package:tap_to_home/add_device.dart';
import 'package:tap_to_home/single_device.dart';

class SingleRoom extends StatefulWidget {
  var room;
  SingleRoom(this.room);

  @override
  _SingleRoomState createState() => _SingleRoomState();
}

class _SingleRoomState extends State<SingleRoom> {

  bool _value = false;

  List _device = [];

  fetchDevices() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;

    var _firestoreInstance = FirebaseFirestore.instance;
    QuerySnapshot qn = await _firestoreInstance.collection("device-data").get();
    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        _device.add({
          "device-name": qn.docs[i]["device-name"],
          "device-model": qn.docs[i]["device-model"],
          "device-category": qn.docs[i]["device-category"],
          "status": qn.docs[i]["status"]
        });
      }
    });
    return qn.docs;
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
                      text: widget.room['room-name'],
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Oswald",
                          fontSize: 22)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Devices in the room",
                    style: TextStyle(
                      fontFamily: "Oswald",
                      fontSize: 20,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>AddDevice(widget.room)));
                      print(widget.room["room-id"]);
                      },
                    child: Text(
                      "Add New Device",
                      style: TextStyle(
                          fontFamily: "Oswald",
                          fontSize: 15,
                          color: Theme.of(context).primaryColor),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
              child: GridView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: 6,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 210,
                      childAspectRatio: 3 / 4,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15
                  ),
                  itemBuilder: (context, index){
                    return InkWell(
                      onLongPress: (){
                        showDialog(context: context, builder: (context){
                          return AlertDialog(
                            content: Container(
                              height: 150,
                              child: Column(
                                children: [
                                  TextButton(onPressed: (){}, child: Text("Edit",style: TextStyle(color: Colors.green),),),
                                  TextButton(onPressed: (){}, child: Text("Delete",style: TextStyle(color: Colors.red))),
                                  TextButton(onPressed: (){
                                    Navigator.pop(context);
                                  }, child: Text("Close",style: TextStyle(color: Colors.black))),
                                ],
                              ),
                            ),
                          );
                        });
                      },
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>SingleDevice(_device[index])));
                      },
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: _value == true
                                ? Theme.of(context).primaryColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SvgPicture.asset(
                              "asset/icon/bulb.svg",
                              color: _value == false
                                  ?Theme.of(context).primaryColor:Colors.white,
                              semanticsLabel: 'Bulb',
                              width: 50,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                      text: "Light",
                                      style: TextStyle(
                                          color: _value == false
                                              ?Colors.black:Colors.white,
                                          fontFamily: "Oswald",
                                          fontSize: 20)),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  "Energy bulb",
                                  style: TextStyle(
                                    color: _value == false
                                        ?Colors.grey:Colors.white,
                                    fontFamily: "Oswald",
                                    fontSize: 13,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                  border: Border.all(
                                      width: 1,
                                      color: Theme.of(context).primaryColor),
                                  borderRadius: BorderRadius.circular(50)),
                              child: SwitcherButton(
                                value: _value,
                                onColor: Theme.of(context).primaryColor,
                                offColor: Colors.white,
                                size: 35,
                                onChange: (value) {
                                  setState(() {
                                    _value = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
              ),
            )
          ],
        ),
      ),
    );
  }
}
