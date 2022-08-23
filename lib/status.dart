import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:switcher_button/switcher_button.dart';
import 'package:tap_to_home/add_room.dart';
import 'package:tap_to_home/drawer.dart';
import 'package:tap_to_home/single_device.dart';
import 'package:tap_to_home/single_room.dart';

class Status extends StatefulWidget {
  const Status({Key? key}) : super(key: key);

  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> {
  bool _value = false;

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
            "room-id": qn.docs[i]["room-id"],
          });
        }
      }
    });
    return qn.docs;
  }

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

  sendDevicestatusDB() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;

    CollectionReference _collectionRef =
    FirebaseFirestore.instance.collection("device-data");
    return _collectionRef
        .doc()
        .update(
        {
          "status": _value,
        }
    )
        .then((value) => Navigator.pop(context))
        .catchError((error) => Fluttertoast.showToast(msg: "Something went wrong"));
  }


  @override
  void initState() {
    fetchProducts();
    fetchDevices();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF1F4F6),
      drawer: DrawerWidget(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: Builder(builder: (ctx) {
          return IconButton(
            onPressed: () {
              Scaffold.of(ctx).openDrawer();
            },
            icon: Icon(
              Icons.menu,
              color: Theme.of(context).primaryColor,
            ),
          );
        }),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder(
                stream: FirebaseFirestore.instance.collection("users-data")
                    .doc(FirebaseAuth.instance.currentUser!.email)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  var data = snapshot.data;

                  if(data != null){
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Hello "+ data["first-name"],
                        style: TextStyle(
                          fontFamily: "Oswald",
                          fontSize: 30,
                        ),
                      ),
                    );
                  }else{
                    return Text("Hello User");
                  }
                }
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Good Morning",
                style: TextStyle(
                  fontFamily: "Oswald",
                  fontSize: 25,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Your rooms",
                    style: TextStyle(
                      fontFamily: "Oswald",
                      fontSize: 20,
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>AddRoom()));
                      },
                      child: Text(
                        "Add New Room",
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
              width: double.infinity,
              height: 300,
              child: ListView.builder(
                itemBuilder: (BuildContext context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SingleRoom(_rooms[index])));
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 15),
                      padding: EdgeInsets.all(15),
                      height: 300,
                      width: 200,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: _rooms[index]['room-cat'] == 'bedroom'?
                            AssetImage('asset/image/bed.jpg'):
                            _rooms[index]['room-cat'] == 'diningroom'?
                            AssetImage('asset/image/sofa.jpg'):
                            _rooms[index]['room-cat'] == 'washroom'?
                            AssetImage('asset/image/wash.jpg'):
                            _rooms[index]['room-cat'] == 'kitchen'?
                            AssetImage('asset/image/stove.jpg'):
                            _rooms[index]['room-cat'] == 'garage'?
                            AssetImage('asset/image/garage.jpg'):
                            AssetImage('asset/image/blank.jpg'),


                            fit: BoxFit.fitWidth,
                          )),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Hero(
                            tag: new Text("hometitle"),
                            child: RichText(
                              text: TextSpan(
                                  text: "${_rooms[index]["room-name"]}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Oswald",
                                      fontSize: 20)),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "5 device active",
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Oswald",
                                fontSize: 15),
                          )
                        ],
                      ),
                    ),
                  );
                },
                itemCount: _rooms.length,
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              width: double.infinity,
              height: 220,
              child: ListView.builder(
                itemBuilder: (BuildContext context, index) {
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
                      margin: EdgeInsets.only(right: 15),
                      padding: EdgeInsets.all(15),
                      width: 200,
                      decoration: BoxDecoration(
                          color: _value == false
                              ? Colors.white
                              : Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SvgPicture.asset(
                            "asset/icon/bulb.svg",
                            color: _value == false ? Theme.of(context).primaryColor: Colors.white,
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
                                    text: "${_device[index]["device-name"]}",
                                    style: TextStyle(
                                        color: _value == false ? Colors.black:Colors.white,
                                        fontFamily: "Oswald",
                                        fontSize: 20)),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "${_device[index]["device-model"]}",
                                style: TextStyle(
                                    color: _value == false ? Colors.grey:Colors.white,
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
                                  print(value);
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
                itemCount: _device.length,
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
              ),
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
