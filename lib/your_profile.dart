import 'package:flutter/material.dart';

class YourProfile extends StatefulWidget {
  const YourProfile({Key? key}) : super(key: key);

  @override
  _YourProfileState createState() => _YourProfileState();
}

class _YourProfileState extends State<YourProfile> {
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
    );
  }
}
