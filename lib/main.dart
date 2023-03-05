import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_maintainace/it/scan.dart';
import 'package:smart_maintainace/user/account.dart';
import 'package:smart_maintainace/user/profile.dart';
import 'package:smart_maintainace/user/reserv.dart';
import 'barren/scan.dart';
import 'login.dart';



class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}


void main(){
  HttpOverrides.global = new MyHttpOverrides();
  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
 String ip ="donkol.sytes.net:3031";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  SplashScreen()
    );
  }
}


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  bool visible = false ;

  Future<void> check() async {

    setState(() {
      visible = true ;
    });

    WidgetsFlutterBinding.ensureInitialized();

    SharedPreferences prefs = await SharedPreferences.getInstance();



    if(prefs.getString('asscid')== null&& prefs.getString('password')==null){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>login()),
      );

    } else{
      var url = "https://"+ MyApp().ip+"/adit/login.php";

      var data = {'asscid': prefs.getString('asscid'), 'password' : prefs.getString('password')};

      var response = await http.post(url, body: json.encode(data));

      var message = jsonDecode(response.body);

      var response1 = await http.post("https://"+MyApp().ip+"/adit/getstate.php", body:{"id":prefs.getString('asscid')});
      var st = jsonDecode(response1.body);

      if (message == "USER") {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("asscid", prefs.getString('asscid'));
        prefs.setString("password", prefs.getString('password'));
        var response = await http.post("https://"+MyApp().ip+"/adit/getstate.php", body:{"id":prefs.getString('asscid')});
        var st = jsonDecode(response.body);
        if(st=="on"){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Uprofile(asscid:prefs.getString('asscid'))),
          );
        }else if(st=="hold"){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Reserv()),
          );
        }
      }else if (message == "BARREN"){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Bscanner(asscid:prefs.getString('asscid'))),
        );
      }else if (message == "IT"){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ITscanner(asscid:prefs.getString('asscid'))),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    check();
  }
  @override
  Widget build(BuildContext context) {


    Size size = MediaQuery.of(context).size; //check the size of device

    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness ==
        Brightness.dark;

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent,statusBarIconBrightness: Brightness.light));
    ResponsiveWidgets.init(context,
      allowFontScaling: true, // Optional
    );



    return Scaffold(
        backgroundColor: isDarkMode
            ? const Color(0xff06090d)
            : const Color(0xfff8f8f8),
        extendBody: true,
        extendBodyBehindAppBar: true,

        body:Padding(
            padding: EdgeInsets.fromLTRB(40,MediaQuery.of(context).size.height*0.25,40,MediaQuery.of(context).size.height*0.25),
            child: Column(
                children: [
                  Center(
            child:Text(
              'HELLO',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'SF Display',
                fontSize: 40,
                color: Colors.blue,
              ),
            )
                  ),
                  SizedBox(height: 30),
                  new CircularProgressIndicator()
                ]
            )
        )
    );
  }
}
