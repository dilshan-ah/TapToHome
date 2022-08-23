import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tap_to_home/login.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(height: 38,),
          IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.close,color: Theme.of(context).primaryColor,)),
          SizedBox(height: 10,),
          RotatedBox(
              quarterTurns: 3,
              child: TextButton(
                  onPressed: (){},
                  child: Text("Your profile",style: TextStyle(color: Theme.of(context).primaryColor))
              )
          ),
          SizedBox(height: 10,),
          RotatedBox(
              quarterTurns: 3,
              child: TextButton(
                  onPressed: (){
                    _signOut();
                  },
                  child: Text("Logout",style: TextStyle(color: Theme.of(context).primaryColor),)
              )
          ),
        ],
      ),
    );
  }
}
