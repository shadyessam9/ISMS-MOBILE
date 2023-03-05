import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_maintainace/it/printerinfo.dart';
import 'package:smart_maintainace/it/routerinfo.dart';
import 'package:smart_maintainace/it/switchinfo.dart';
import '../main.dart';
import 'camerainfo.dart';
import 'deviceinfo.dart';
import 'dvrinfo.dart';



Future<Data> fetchPost(String asscid) async {

  SharedPreferences prefs = await SharedPreferences.getInstance();

  final response = await http.post("https://"+MyApp().ip.trim()+"/adit/getdata.php", body:{"key": prefs.getString('asscid')});

  if (response.statusCode == 200) {
    return  Data.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load post');
  }
}


class Data{
  final company;
  final name;
  final depart;
  final position;
  Data({this.company,this.name,this.depart,this.position});
  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
        company: json['company'],
        name: json['name'],
        depart: json['depart'],
        position: json['position']
    );
  }
}

class ITscanner extends StatefulWidget {
  final String asscid;
  ITscanner({Key key,@required this.asscid}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ITscanner();}
}

class _ITscanner extends State<ITscanner> {

  String asscid;
  String barcodeScanRes ="";
  String bar ="";
  String _timeString;
  static Future<Data> data;


  @override
  void initState() {
    asscid=widget.asscid;
    data = fetchPost(asscid);
    super.initState();
    _timeString = _formatDateTime(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());

  }

  Future scan() async {
    barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", false, ScanMode.DEFAULT);
    setState(() { bar = barcodeScanRes; });
  print(bar);
    var response = await http.post("https://"+MyApp().ip.trim()+"/adit/gettype.php", body:{"id":bar});
    var type = jsonDecode(response.body);
    if(type=="PC"||type=="LAPTOP"||type=="SERVER"){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ITdeviceinfo(asscid:bar)),
      );
    }else if(type=="ROUTER"){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ITrouterinfo(asscid:bar)),
      );
    }else if(type=="SWITCH"){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ITswitchinfo(asscid:bar)),
      );
    }else if(type=="CAMERA"){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ITcamerainfo(asscid:bar)),
      );
    }else if(type=="DVR"){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ITdvrinfo(asscid:bar)),
      );
    }else if(type=="PRINTER"){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ITprinterinfo(asscid:bar)),
      );
    }
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('MM/dd/yyyy hh:mm:ss').format(dateTime);
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

    return WillPopScope(
        onWillPop: () async => false,
      child: FutureBuilder<Data>(
          future: data,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return  Scaffold(
                appBar: AppBar(
                  bottomOpacity: 0.0,
                  elevation: 0.0,
                  shadowColor: Colors.transparent,
                  backgroundColor: isDarkMode
                      ? const Color(0xff06090d)
                      : const Color(0xfff8f8f8), //appbar bg color
                  automaticallyImplyLeading: false,
                  titleSpacing: 0,
                  leadingWidth: size.width * 0.15,
                  title: Image.asset(
                    isDarkMode
                        ? 'assets/logo.png'
                        : 'assets/logo.png',
                    height: size.height * 0.06,
                    width: size.width * 0.35,
                  ),
                  centerTitle: true,
                ),
                body: Center(
                    child: Container(
                        height: size.height,
                        width: size.height,
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? const Color(0xff06090d)
                              : const Color(0xfff8f8f8), //background color
                        ),
                        child:SafeArea(
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.08,
                                ),
                                child:Column(
                                    children: [
                                      SizedBox(height:10),
                                      Center(
                                        child: Icon(
                                          Icons.account_circle,
                                          color: isDarkMode ? const Color(0xff3DA2E4).withOpacity(0.5) : const Color(0xff3DA2E4).withOpacity(0.5),
                                          size: size.height * 0.1,
                                        ),
                                      ),
                                      SizedBox(height:10),
                                      Center(
                                          child: Text(
                                            snapshot.data.name,
                                            textAlign: TextAlign.left,
                                            style: GoogleFonts.poppins(
                                              color: isDarkMode
                                                  ? Colors.white
                                                  : const Color(0xff06090d),
                                              fontSize: size.width * 0.05,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                      ),
                                      SizedBox(height:15),
                                      Center(
                                          child: Text(
                                            snapshot.data.company,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                              color: isDarkMode
                                                  ? Colors.white
                                                  : const Color(0xff06090d),
                                              fontSize: size.width * 0.05,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                      ),
                                      SizedBox(height:15),
                                      Center(
                                        child: Center(
                                            child: Text(
                                              snapshot.data.depart+" , "+snapshot.data.position,
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.poppins(
                                                color: isDarkMode
                                                    ? Colors.white
                                                    : const Color(0xff06090d),
                                                fontSize: size.width * 0.05,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                        ),
                                      ),
                                      SizedBox(height:10),
                                      Center(
                                        child:Container(
                                            child: Text(_timeString,
                                                style: GoogleFonts.poppins(
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : const Color(0xff06090d),
                                                  fontSize: size.width * 0.05,
                                                  fontWeight: FontWeight.bold,
                                                )
                                            )
                                        ),
                                      ),
                                      SizedBox(height:20),
                                      Center(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(primary:isDarkMode ? const Color(0xff06090d) : Colors.white),
                                            onPressed: () {
                                              scan();
                                            },
                                            child:  Icon(
                                              Icons.qr_code,
                                              color: isDarkMode ? const Color(0xff3DA2E4).withOpacity(0.5) : const Color(0xff3DA2E4).withOpacity(0.5),
                                              size: size.height * 0.30,
                                            ),
                                          )
                                      )
                                    ]
                                )
                            ))
                    )
                ),
              );
            }else if (snapshot.hasError) {
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
          }));
  }

}

