import 'dart:convert';
import 'package:auto_direction/auto_direction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_maintainace/user/profile.dart';
import 'package:smart_maintainace/user/reserv.dart';
import 'barren/scan.dart';
import 'it/deviceinfo.dart';
import 'it/scan.dart';
import 'main.dart';


class login extends StatefulWidget {


  @override
  State<StatefulWidget> createState() {
    return _login();
  }
}

class _login extends State<login> {




  static final asscidController = TextEditingController();
  static final passwordController = TextEditingController();
  bool visible = false ;
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  bool _validate1 = false;
  bool _validate2 = false;
  String text1 = "";
  String text2 = "";
  String asscid;
  String password;
  String page;




  Future userLogin() async {
    setState(() {
      visible = true;
    });

    asscid = asscidController.text;
    password = passwordController.text;


    var url = "https://"+MyApp().ip+"/adit/login.php";

    var data = {'asscid': asscid, 'password': password};

    var response = await http.post(url, body: json.encode(data));

    var message = jsonDecode(response.body);


    if (message == "USER") {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("asscid", asscid);
      prefs.setString("password", password);
      var response = await http.post("https://"+MyApp().ip+"/adit/getstate.php", body:{"id":asscid});
      var st = jsonDecode(response.body);
      if(st=="on"){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Uprofile(asscid:asscid)),
        );
      }else if(st=="hold"){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Reserv()),
        );
      }
    }else if (message == "BARREN"){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("asscid", asscid);
      prefs.setString("password", password);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Bscanner(asscid:asscid)),
      );
    }else if (message == "BARREN"){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("asscid", asscid);
      prefs.setString("password", password);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Bscanner(asscid:asscid)),
      );
    }
    else if (message == "IT"){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("asscid", asscid);
      prefs.setString("password", password);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ITscanner(asscid:asscid)),
      );
    }else showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))
          ),
          title: new Text(message),
          actions: <Widget>[
            FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

  }

  @override
  Widget  build(BuildContext context) {


    Size size = MediaQuery.of(context).size; //check the size of device
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness ==
        Brightness.dark;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent,statusBarIconBrightness: Brightness.light));
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(40.0), //appbar size
          child: AppBar(
            bottomOpacity: 0.0,
            elevation: 0.0,
            shadowColor: Colors.transparent,
            backgroundColor: isDarkMode
                ? const Color(0xff06090d)
                : const Color(0xfff8f8f8),
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            leadingWidth: size.width * 0.15,
          ),
        ),
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Center(
          child: Container(
            height: size.height,
            width: size.height,
            decoration: BoxDecoration(
              color: isDarkMode
                  ? const Color(0xff06090d)
                  : const Color(0xfff8f8f8), //background color
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.04,
                ),
                child: Stack(
                    children: [
                      ListView(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(20.0),
                          physics: const NeverScrollableScrollPhysics(),

                          children: [
                            Image.asset(
                              isDarkMode
                                  ? 'assets/logo.png'
                                  : 'assets/logo.png',
                              height: size.height * 0.09,
                              width: size.width * 0.08,
                              fit: BoxFit.cover,
                            ),
                            Center(
                              child: Text(
                                "INFRASTRUCTURE",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  color: isDarkMode
                                      ? const Color(0xff3DA2E4).withOpacity(0.9)
                                      : const Color(0xff3DA2E4).withOpacity(0.9),
                                  fontSize: size.width * 0.04,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.15,
                            ),
                            Text(
                              "CREDENTIALS",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: isDarkMode
                                    ? const Color(0xff3DA2E4).withOpacity(0.9)
                                    : const Color(0xff3DA2E4).withOpacity(0.9),
                                fontSize: size.width * 0.04,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            AutoDirection(
                                text: text1,
                                child:TextField(
                                  style: TextStyle(color: const Color(0xff3DA2E4)),
                                  minLines: 1,
                                  maxLines: 1,
                                  autocorrect: false,
                                  textInputAction: TextInputAction.next,
                                  focusNode: focus1,
                                  onChanged: (v){ setState((){asscidController.text.isEmpty ? _validate1 = true : _validate1 = false;});
                                  setState(() {text1 = v;});
                                  },
                                  onSubmitted: (v){
                                    setState(() {asscidController.text.isEmpty ? _validate1 = true : _validate1 = false;});
                                    FocusScope.of(context).requestFocus(focus2);},
                                  decoration: InputDecoration(
                                    errorText: _validate1 ? 'Please enter your id' : null,
                                    hintText: 'ID',
                                    hintStyle: TextStyle(fontSize: 15, color: const Color(0xff3DA2E4)),
                                    filled: true,
                                    fillColor: Colors.transparent,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                      borderSide: BorderSide(color: const Color(0xff3DA2E4).withOpacity(0.9)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                      borderSide: BorderSide(color: const Color(0xff3DA2E4).withOpacity(0.9)),
                                    ),
                                  ),
                                  controller: asscidController,
                                )
                            ),
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            AutoDirection(
                                text: text2,
                                child:TextField(
                                  style: TextStyle(color: const Color(0xff3DA2E4)),
                                  minLines: 1,
                                  maxLines: 1,
                                  autocorrect: false,
                                  textInputAction: TextInputAction.next,
                                  focusNode: focus2,
                                  onChanged: (v){ setState((){passwordController.text.isEmpty ? _validate2 = true : _validate2 = false;});
                                  setState(() {text2 = v;});
                                  },
                                  onSubmitted: (v){
                                    setState(() {passwordController.text.isEmpty ? _validate2 = true : _validate2 = false;});
                                    FocusScope.of(context).requestFocus(focus3);},
                                  decoration: InputDecoration(
                                    errorText: _validate2 ? 'Please enter your id' : null,
                                    hintText: 'PASSWORD',
                                    hintStyle: TextStyle(fontSize: 15, color: const Color(0xff3DA2E4)),
                                    filled: true,
                                    fillColor: Colors.transparent,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                      borderSide: BorderSide(color: const Color(0xff3DA2E4).withOpacity(0.9)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                      borderSide: BorderSide(color: const Color(0xff3DA2E4).withOpacity(0.9)),
                                    ),
                                  ),
                                  controller: passwordController,
                                )
                            ),
                            SizedBox(
                              height: size.height * 0.04,
                            ),
                            Center(
                                child: Container(
                                  height: size.height * 0.07,
                                  width: size.width * 0.3,
                                  child: ElevatedButton(
                                      style: elevatedButtonStyle,
                                      child: Text(
                                        'LOGIN',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          color: isDarkMode
                                              ? Colors.black
                                              : Colors.white,
                                          fontSize: size.width * 0.04,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      onPressed: (){
                                        if(asscidController.text.isEmpty) {
                                          setState(() {
                                            asscidController.text.isEmpty ?
                                            _validate1 = true : _validate1 = false;
                                          });
                                          FocusScope.of(context).requestFocus(focus1);
                                        }else if (passwordController.text.isEmpty){
                                          setState(() {
                                            passwordController.text.isEmpty ? _validate2 = true : _validate2 = false;});
                                          FocusScope.of(context).requestFocus(focus2);
                                        } else{
                                          userLogin();
                                        }
                                      }
                                  ),
                                )
                            )
                          ]),

                    ]),
              ),
            ),
          ),
        ),
      )
    );
  }
}

final ButtonStyle elevatedButtonStyle = TextButton.styleFrom(
  primary: Colors.white,
  padding: EdgeInsets.symmetric(horizontal: 16.0),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
  ),
  backgroundColor: const Color(0xff3DA2E4).withOpacity(0.9),
);



