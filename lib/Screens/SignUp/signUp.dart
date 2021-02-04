import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibrate/vibrate.dart';
import 'package:whatsup/AuthFunctions/auth.dart';
import 'package:whatsup/Functions/sharedPreferenceStoreUserDetails.dart';
import 'package:whatsup/Screens/Home/home.dart';
import 'package:whatsup/Screens/Login/login.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with SingleTickerProviderStateMixin {
  bool visibility = true;
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _username = TextEditingController();
  AuthMethods authMethods = AuthMethods();

  AnimationController _controller;
  @override
  void initState() {
    // TODO: implement initState
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    super.initState();
    _controller.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.purple[900], Colors.teal[900]])),
          child: FadeTransition(
            opacity: _controller,
            child: ScaleTransition(
              scale: _controller,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 100,
                  ),
                  Icon(
                    Icons.person,
                    size: 200,
                    color: Colors.white60,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 70),
                    child: Divider(
                      height: 20,
                      color: Colors.white60,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    width: size.width * 0.7,
                    decoration: BoxDecoration(
                      color: Colors.white60,
                      borderRadius: BorderRadius.circular(29),
                    ),
                    child: TextFormField(
                      controller: _username,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.person,
                            color: Colors.black,
                          ),
                          suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _username.text = '';
                                });
                              },
                              child: Icon(
                                Icons.clear,
                                color: Colors.black,
                              )),
                          border: InputBorder.none,
                          hintText: 'USERNAME',
                          hintStyle: TextStyle(fontWeight: FontWeight.w300)),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    width: size.width * 0.7,
                    decoration: BoxDecoration(
                      color: Colors.white60,
                      borderRadius: BorderRadius.circular(29),
                    ),
                    child: TextFormField(
                      controller: _email,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.mail_rounded,
                            color: Colors.black,
                          ),
                          suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _email.text = '';
                                });
                              },
                              child: Icon(
                                Icons.clear,
                                color: Colors.black,
                              )),
                          border: InputBorder.none,
                          hintText: 'E-MAIL',
                          hintStyle: TextStyle(fontWeight: FontWeight.w300)),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    width: size.width * 0.7,
                    decoration: BoxDecoration(
                      color: Colors.white60,
                      borderRadius: BorderRadius.circular(29),
                    ),
                    child: TextFormField(
                      controller: _password,
                      cursorColor: Colors.black,
                      obscureText: visibility,
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.lock_rounded,
                            color: Colors.black,
                          ),
                          suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  visibility = !visibility;
                                });
                              },
                              child: visibility
                                  ? Icon(
                                      Icons.visibility_off_rounded,
                                      color: Colors.black,
                                    )
                                  : Icon(
                                      Icons.visibility_rounded,
                                      color: Colors.black,
                                    )),
                          border: InputBorder.none,
                          hintText: 'PASSWORD',
                          hintStyle: TextStyle(fontWeight: FontWeight.w300)),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: size.width * 0.65,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.teal,
                    ),
                    child: FlatButton(
                      onPressed: () async {
                        
                        dynamic result = await authMethods.signUp(
                            _email.text, _password.text);
                        if (result) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Home()));
                        } else {
                          Vibrate.vibrate();
                        }
                      },
                      child: Text('Register',
                          style: GoogleFonts.londrinaSolid(
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                                fontSize: 25),
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Already have account ? '),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        },
                        child: Text(
                          'SignIn',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  )),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: size.width * 0.6,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                            child: Divider(
                          height: 10,
                          thickness: 1.5,
                          color: Colors.teal,
                        )),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 7),
                          child: Text(
                            "OR",
                            style: GoogleFonts.londrinaSolid(
                              textStyle: TextStyle(
                                  color: Colors.teal,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                  fontSize: 12),
                            ),
                          ),
                        ),
                        Expanded(
                            child: Divider(
                          height: 10,
                          thickness: 1.5,
                          color: Colors.teal,
                        )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    child: GestureDetector(
                        onTap: () {
                          AuthMethods().signInWithGoogle(context);
                        },
                        child: Image.asset(
                          'assets/google.png',
                          width: 150,
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}
