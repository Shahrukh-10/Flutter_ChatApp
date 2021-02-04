import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whatsup/Screens/SignUp/signUp.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Material(
        child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.purple[900], Colors.teal[900]]),
            ),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 200,
                ),
                Container(
                  child: Container(
                    child: Image.asset(
                      'assets/hello.gif',
                      height: 150,
                    ),
                  ),
                ),
                SizedBox(
                  height: 300,
                ),
                HelloText(),
              ],
            )),
      ),
    );
  }
}

class HelloText extends StatefulWidget {
  @override
  _HelloTextState createState() => _HelloTextState();
}

class _HelloTextState extends State<HelloText> with TickerProviderStateMixin {
  AnimationController _controller;
  AnimationController _nextcontroller;
  @override
  void initState() {
    // TODO: implement initState
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _nextcontroller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    super.initState();
    Timer(Duration(milliseconds: 400), () => _controller.forward());
    Timer(Duration(milliseconds: 2500), () => _nextcontroller.forward());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            child: SlideTransition(
              position: Tween<Offset>(begin: Offset(0, 2), end: Offset(0, 0))
                  .animate(_controller),
              child: FadeTransition(
                opacity: _controller,
                child: Text(
                  'Welcome User',
                  style: GoogleFonts.londrinaSolid(
                    textStyle: TextStyle(
                        color: Colors.white60,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        fontSize: 50),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => SignUp()));
            },
            child: Container(
              child: FadeTransition(
                opacity: _nextcontroller,
                child: Text(
                  'Next',
                  style: TextStyle(color: Colors.white38, fontSize: 20),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
