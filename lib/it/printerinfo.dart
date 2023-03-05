import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:smart_maintainace/barren/scan.dart';
import 'package:smart_maintainace/user/request.dart';
import 'package:unicons/unicons.dart';
import '../main.dart';



Future<Data> fetchPost(String asscid) async {

  final response = await http.post("https://"+MyApp().ip.trim()+"/adit/getdata.php", body:{"key": asscid});

  if (response.statusCode == 200) {
    return  Data.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load post');
  }
}


class Data{
  final type;
  final model;
  final ip;
  final picd;
  final st;
  final company;
  final name;
  final depart;
  Data({this.type,this.model,thisports,this.ip,this.picd,this.st,this.company,this.name,this.depart});
  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      type: json['type'],
      model: json['model'],
      ip: json['dvr'],
      picd: json['picd'],
      st: json['st'],
      company: json['company'],
      name: json['name'],
      depart: json['depart'],
    );
  }
}



class ITprinterinfo extends StatefulWidget {
  String asscid;
  ITprinterinfo ({this.asscid});



  @override
  _ITprinterinfo createState() => _ITprinterinfo ();
}

class _ITprinterinfo  extends State<ITprinterinfo> {

  static Future<Data> data;
  String asscid ;




  setUpTimedFetch() {
    Timer.periodic(Duration(seconds: 15), (timer) {
      setState(() {
        data = fetchPost(asscid);
      });
    });
  }


  void initState() {
    asscid=widget.asscid;
    data = fetchPost(asscid);
    super.initState();
    setUpTimedFetch();
  }

  @override
  Widget build(BuildContext context) {


    Size size = MediaQuery.of(context).size; //check the size of device



    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness ==
        Brightness.dark;

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent,statusBarIconBrightness: Brightness.light));

    return WillPopScope(
        onWillPop: () async => false,
        child:FutureBuilder<Data>(

            future: data,
            builder: (context, snapshot) {
              if (snapshot.hasData) {

                return Scaffold(

                  appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(40.0), //appbar size
                    child: AppBar(
                      bottomOpacity: 0.0,
                      elevation: 0.0,
                      shadowColor: Colors.transparent,
                      backgroundColor: isDarkMode
                          ? const Color(0xff06090d)
                          : const Color(0xfff8f8f8), //appbar bg color
                      leading: Padding(
                        padding: EdgeInsets.only(
                          left: size.width * 0.05,
                        ),
                        child: SizedBox(
                          height: size.width * 0.1,
                          width: size.width * 0.1,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Bscanner()),
                              );//go back to home page
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? const Color(0xff070606)
                                    : Colors.white, //icon bg color
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: isDarkMode ? Colors.white : const Color(0xff3DA2E4).withOpacity(0.5),
                                size: size.height * 0.025,
                              ),
                            ),
                          ),
                        ),
                      ),
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
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Image.network(
                                      snapshot.data.picd,
                                      height: size.width * 0.6,
                                      width: size.width * 0.8,
                                      fit: BoxFit.cover,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data.company,
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                            color: isDarkMode
                                                ? Colors.white
                                                : const Color(0xff06090d),
                                            fontSize: size.width * 0.04,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Spacer(),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          snapshot.data.name+"'S CAMERA",
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.poppins(
                                            color: isDarkMode
                                                ? Colors.white
                                                : const Color(0xff06090d),
                                            fontSize: size.width * 0.05,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Spacer()
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          snapshot.data.depart,
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.poppins(
                                            color: isDarkMode
                                                ? Colors.white
                                                : const Color(0xff06090d),
                                            fontSize: size.width * 0.05,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Spacer()
                                      ],
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(
                                          top: size.height * 0.03,
                                        ),
                                        child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  buildStat(
                                                    UniconsLine.power,
                                                    'STATE',
                                                    '${snapshot.data.st}',
                                                    size,
                                                    isDarkMode,
                                                  ),
                                                  buildStat(
                                                    UniconsLine.airplay,
                                                    'TYPE',
                                                    '( ${snapshot.data.type} )',
                                                    size,
                                                    isDarkMode,
                                                  ),
                                                  buildStat(
                                                    UniconsLine.processor,
                                                    'MODEL',
                                                    '( ${snapshot.data.model} )',
                                                    size,
                                                    isDarkMode,
                                                  ),
                                                ],
                                              ),
                                            ]
                                        )
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(
                                          top: size.height * 0.03,
                                        ),
                                        child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  buildStat(
                                                    Icons.memory,
                                                    'IP',
                                                    '${snapshot.data.ip}',
                                                    size,
                                                    isDarkMode,
                                                  )
                                                ],
                                              )
                                            ]
                                        )
                                    ),
                                  ]
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child:  new CircularProgressIndicator(),
                );
              }
              return Center(
                child: new CircularProgressIndicator(),
              );}
        )
    );

  }

  Padding buildStat(
      IconData icon, String title, String desc, Size size, bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.015,
      ),
      child: SizedBox(
        height: size.width * 0.32,
        width: size.width * 0.25,
        child: Container(
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.white,
            borderRadius: const BorderRadius.all(
              Radius.circular(
                10,
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              top: size.width * 0.03,
              left: size.width * 0.03,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  color: const Color(0xff3DA2E4).withOpacity(0.5),
                  size: size.width * 0.08,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: size.width * 0.02,
                  ),
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: size.width * 0.03,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  desc,
                  style: GoogleFonts.averiaGruesaLibre(
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.7)
                        : Colors.black.withOpacity(0.7),
                    fontSize: size.width * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}