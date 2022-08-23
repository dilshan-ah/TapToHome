import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tap_to_home/add_profile.dart';
import 'package:tap_to_home/login.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();

  bool obs = true;


  register() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailcontroller.text,
          password: _passwordcontroller.text
      );
      var authCredential = userCredential.user;
      print(authCredential!.uid);
      if(authCredential.uid.isNotEmpty){
        Navigator.push(context, CupertinoPageRoute(builder: (_)=>AddProfile()));
        Fluttertoast.showToast(msg: "Registration complete");
      }
      else{
        Fluttertoast.showToast(msg: "Something went wrong");
      }

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(msg: "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(msg: "The account already exists for that email.");
      }
    } catch (e) {
      print(e);
    }
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
                child: Text("Create a new account",style: TextStyle(
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
                      controller: _emailcontroller,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Email"
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
                      controller: _passwordcontroller,
                      keyboardType: TextInputType.text,
                      obscureText: obs,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: (){
                            setState(() {
                              obs = !obs;
                            });
                          },
                          icon: obs == true ? Icon(Icons.visibility,color: Theme.of(context).primaryColor):Icon(Icons.visibility_off,color: Colors.grey,),
                        ),
                          border: InputBorder.none,
                          hintText: "Password"
                      ),
                    )
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Already have an account?",style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14
                    ),),
                    TextButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
                        },
                        child: Text("Login",style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 14
                    ),))
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
                      register();
                    },
                    child: Text("Register",style: TextStyle(color: Colors.white),)
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
