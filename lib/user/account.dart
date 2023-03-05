import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:smart_maintainace/main.dart';



class account extends StatefulWidget {
  final String asscid;
  account({this.asscid});
  @override
  State<StatefulWidget> createState() {
    return _account();
  }
}

Future<Data> fetchPost(String asscid) async {

  final response = await http.post("https://"+MyApp().ip.trim()+"/adit/getdata.php", body:{"key":asscid});

  if (response.statusCode == 200) {
    return  Data.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load post');
  }
}



class Data{
  final name;
  final depart;
  final position;
  final company;
  Data({this.name,this.depart,this.position,this.company});
  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
        name: json['name'],
        depart: json['depart'],
        position: json['position'],
        company: json['company']
    );
  }
}



class _account extends State<account> {
  String asscid;
  static Future<Data> data;

  @override
  void initState() {
    asscid=widget.asscid;
    data = fetchPost(asscid);
    super.initState();

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
    return FutureBuilder<Data>(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.hasData) {

            return Container(
                height: size.height*0.40,
                width: size.height*0.40,
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? const Color(0xff06090d)
                      : const Color(0xfff8f8f8), //background color
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff3DA2E4).withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)
                  ),
                ),

                child: Column(
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
                      Container(
                        width: 306,
                        height: 1,
                        color: const Color(0xff3DA2E4).withOpacity(0.5) ,
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
                    ]
                )
            );
          }else if (snapshot.hasError) {
            return Center(
              child:  new CircularProgressIndicator(),
            );
          }
          return Center(
              child: CircularProgressIndicator()
          );}
    );
  }
}