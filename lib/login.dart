import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tap_to_home/register.dart';
import 'package:tap_to_home/status.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();

  bool obs = true;

  logIn() async{
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailcontroller.text,
          password: _passwordcontroller.text
      );

      var authCredential = userCredential.user;
      print(authCredential!.uid);
      if(authCredential.uid.isNotEmpty){
        Navigator.push(context, CupertinoPageRoute(builder: (_)=>Status()));
        Fluttertoast.showToast(msg: "Welcome");
      }
      else{
        Fluttertoast.showToast(msg: "Something went wrong");
      }


    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        Fluttertoast.showToast(msg: "User not found");
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        Fluttertoast.showToast(msg: "Wrong Password");
      }
    }catch (e) {
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
                child: Text("Log in to your account",style: TextStyle(
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
                child: TextButton(onPressed: (){}, child: Text("Forgot Password",style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 14
                ),textAlign: TextAlign.right,),),
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
                      logIn();
                    },
                    child: Text("Login",style: TextStyle(color: Colors.white),)
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Register()));
                  },
                  child: Text("Create new account",style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 14
                ),textAlign: TextAlign.right,),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
