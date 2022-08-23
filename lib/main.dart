import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tap_to_home/login.dart';
import 'package:tap_to_home/status.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  await Firebase.initializeApp();

  runApp(const TapToHome());
}

class TapToHome extends StatelessWidget {
  const TapToHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff006CE0)
      ),
      home:  StreamBuilder(
         stream: FirebaseAuth.instance.authStateChanges(),
         builder: (context, snapshot){
           if(snapshot.connectionState == ConnectionState.active){
             if(snapshot.hasData){
               return Status();
             }else if(snapshot.hasError){
               return Center(
                 child: Text('${snapshot.error}'),
               );
             }
           }

           if(snapshot.connectionState == ConnectionState.waiting){
             return Center(
               child: CircularProgressIndicator(
                 color: Theme.of(context).accentColor,
               ),
             );
           }

           return Login();
         },
      )
    );
  }
}


