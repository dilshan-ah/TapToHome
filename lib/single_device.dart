import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:switcher_button/switcher_button.dart';

class SingleDevice extends StatefulWidget {
  var devicedata;
  SingleDevice(this.devicedata);

  @override
  _SingleDeviceState createState() => _SingleDeviceState();
}

class _SingleDeviceState extends State<SingleDevice> {
  // bool _value = false;

  sendDevicestatusDB(value) async {
    var _firestoreInstance = FirebaseFirestore.instance;
    DocumentSnapshot<Map<String, dynamic>> qn = await _firestoreInstance.collection("device-data").doc().get();



    
      CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection("device-data");
      return _collectionRef
          .doc()
          .update(
          {
            "status": value,
          }
      )
          .then((value) => Fluttertoast.showToast(msg: "Device status changed"))
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
              child: RichText(
                text: TextSpan(
                    text: widget.devicedata["device-name"],
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Oswald",
                        fontSize: 22)),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Energy bulb",
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: "Oswald",
                  fontSize: 13,
                ),
              ),
            ),

            SizedBox(height: 50,),

            Center(
              child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Theme.of(context).primaryColor
                  ),
                  borderRadius: BorderRadius.circular(70)
                ),
                child: RotatedBox(
                  quarterTurns: 3,
                  child: SwitcherButton(
                    value: widget.devicedata['status'],
                    onColor: Theme.of(context).primaryColor,
                    offColor: Colors.white,
                    size: 200,
                    onChange: (value) {
                      value = !value;
                      sendDevicestatusDB(value);
                      setState(() {
                        value = !value;
                        sendDevicestatusDB(value);
                        print(value);
                      });
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 30,),

            Center(child: Text(widget.devicedata['status'] == false ? "Off":"On",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),)),
            FlatButton(
              color: Colors.blue,
                onPressed: (){
                  print(widget.devicedata['status']);
                },
                child: Text("check")
            )
          ],
        ),
      ),
    );
  }
}
