import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tap_to_home/status.dart';

class AddProfile extends StatefulWidget {
  const AddProfile({Key? key}) : super(key: key);

  @override
  _AddProfileState createState() => _AddProfileState();
}

class _AddProfileState extends State<AddProfile> {
  TextEditingController _fnamecontroller = TextEditingController();
  TextEditingController _lnamecontroller = TextEditingController();
  TextEditingController _agecontroller = TextEditingController();

  bool checkbox = false;


  sendUserdataDB() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;


    CollectionReference _collectionRef =
    FirebaseFirestore.instance.collection("users-data");
    return _collectionRef
        .doc(currentUser!.email)
        .set(
        {
          "first-name": _fnamecontroller.text,
          "last-name": _fnamecontroller.text,
          "age": _agecontroller.text,
          "is-operator": checkbox,
        }
    )
        .then((value) => Navigator.push(context, MaterialPageRoute(builder: (context)=>Status())))
        .catchError((error) => Fluttertoast.showToast(msg: "Something went wrong"));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text("User Details",style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Oswald"
                ),),
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
                      controller: _fnamecontroller,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "First Name"
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
                      controller: _lnamecontroller,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Last Name"
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
                      controller: _agecontroller,
                      keyboardType: TextInputType.numberWithOptions(),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Age"
                      ),
                    )
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Checkbox(
                        value: checkbox,
                        onChanged: (value){
                          setState(() {
                            checkbox = value!;
                          });
                          print(checkbox);
                        },
                    ),
                    Text("I am going to operate the app",style: TextStyle(
                      fontSize: 13,
                      fontFamily: "Oswald",
                    ),)
                  ],
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
                      sendUserdataDB();
                    },
                    child: Text("Create Account",style: TextStyle(color: Colors.white),)
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
