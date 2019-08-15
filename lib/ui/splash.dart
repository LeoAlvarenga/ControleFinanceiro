import 'package:controle_financeiro/ui/home_page.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 4)).then((_){
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) {
            return Home();
          }
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body:Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.deepPurple
          ),
          height: 250,
          width: 250,
          child: FlareActor("assets/Wallet.flr", animation: "animation"),
        ),
      )
    );
  }
}