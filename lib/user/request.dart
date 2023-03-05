import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:auto_direction/auto_direction.dart';
import 'package:smart_maintainace/user/profile.dart';
import '../main.dart';




class request extends StatefulWidget {
  String asscid;
  request({Key key, @required this.asscid}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _request();
  }
}

class _request extends State<request> {

  final focus1 = FocusNode();
  final focus2 = FocusNode();
  String text1 = "";
  String asscid;

  bool visible = false ;
  static final requestController = TextEditingController();
  bool _validate1 = false;
  @override
  void initState() {
    super.initState();
    asscid=widget.asscid;
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

    Future send() async {
      String id = "aditr"+DateFormat('hhmmssaaaddMMyyyy').format(DateTime.now());
      String date = DateFormat('dd/MM/yyyy').format(DateTime.now());
      String state = "0";
      var url = 'https://'+MyApp().ip.trim()+'/adit/request.php';
      var data = {'id':id,'asscid':asscid,'request':requestController.text,'date':date,'state':state};
      var response = await http.post(url, body: json.encode(data));
      if(response.statusCode == 200){
        setState(() {
          visible = false;
          requestController.clear();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Uprofile(asscid:asscid)),
          );
        });
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return  AlertDialog(
                backgroundColor: Colors.transparent,
                content: Container(
                  height: size.height*0.45,
                  width: size.width*0.80,
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
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_outline,color:Colors.green,size:50),
                        SizedBox(height:10),
                        Text(
                          'REQUEST IS SENT , PLEASE WAIT FOR THE (IT) RESPOND',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: isDarkMode
                                ? Colors.white
                                : const Color(0xff06090d),
                            fontSize: size.width * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height:10),
                        SizedBox(
                          width: 150,
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "OK",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: const Color(0xff3DA2E4).withOpacity(0.5),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            });
      }else{
        setState(() {
          visible = false;
        });
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return  AlertDialog(
                backgroundColor: Colors.transparent,
                content: Container(
                  height: size.height*0.45,
                  width: size.width*0.80,
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
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_outline,color:Colors.green,size:50),
                        SizedBox(height:10),
                        Text(
                          'REQUEST IS NOT SENT , PLEASE TRY AGAIN',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: isDarkMode
                                ? Colors.white
                                : const Color(0xff06090d),
                            fontSize: size.width * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height:10),
                        SizedBox(
                          width: 150,
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "OK",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.green,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            });
      }
    }

    return Container(
        height: size.height*0.45,
        width: size.width*0.80,
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

        child: SingleChildScrollView(
            child: Column(
                children: [SizedBox(height:10),
                  Center(
                    child: Icon(
                      Icons.settings_applications,
                      color: isDarkMode ? const Color(0xff3DA2E4).withOpacity(0.5): const Color(0xff3DA2E4).withOpacity(0.5),
                      size: size.height * 0.1,
                    ),
                  ),
                  SizedBox(height:10),
                  Text(
                    "MAINTENANCE REQUEST",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.poppins(
                      color: isDarkMode
                          ? Colors.white
                          : const Color(0xff06090d),
                      fontSize: size.width * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height:15),
                  Container(
                      child:Padding(
                          padding: EdgeInsets.only(
                            left: size.width * 0.03,
                            right: size.width * 0.03,
                          ),
                          child: AutoDirection(
                              text: text1,
                              child:   TextField(
                                style: TextStyle(color: isDarkMode
                                    ? Colors.white
                                    : const Color(0xff06090d),fontSize: size.width * 0.04),
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                minLines: 1,
                                autocorrect: false,
                                focusNode: focus1,
                                textInputAction: TextInputAction.next,
                                onChanged: (v){ setState((){requestController.text.isEmpty ? _validate1 = true : _validate1 = false;});
                                setState(() {text1 = v;});
                                },
                                onSubmitted: (v){
                                  setState(() {requestController.text.isEmpty ? _validate1 = true : _validate1 = false;});
                                  FocusScope.of(context).requestFocus(focus2);},
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(vertical: 5),
                                  errorText: _validate1 ? 'PROBLEM Can\'t Be Empty' : null,
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(color: const Color(0xff3DA2E4).withOpacity(0.5)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(color: const Color(0xff3DA2E4).withOpacity(0.5)),
                                  ),
                                ),
                                controller: requestController,
                              )
                          )
                      )
                  ),
                  SizedBox(height:25),
                  TextButton(
                      style: flatButtonStyle,
                      child: Text(
                        'SEND REQUEST',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: isDarkMode
                              ? const Color(0xff06090d)
                              : Colors.white,
                          fontSize: size.width * 0.04,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      onPressed: (){
                        if(requestController.text.isEmpty) {
                          setState(() {
                            requestController.text.isEmpty ?
                            _validate1 = true : _validate1 = false;
                          });
                          FocusScope.of(context).requestFocus(focus1);
                        }else{
                           send();
                        }
                      }
                  ),
                  SizedBox(height:20),
                  Visibility(
                      visible: visible,
                      child: Container(
                          margin: EdgeInsets.only(bottom: 30),
                          child: CircularProgressIndicator()
                      )
                  )
                ]
            )
        )
    );
  }
  OutlineInputBorder textFieldBorder() {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(15.0)),
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.5),
        width: 1.0,
      ),
    );
  }
}

final ButtonStyle flatButtonStyle = TextButton.styleFrom(
  primary: Colors.white,
  minimumSize: Size(88, 44),
  padding: EdgeInsets.symmetric(horizontal: 16.0),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
  ),
  backgroundColor: const Color(0xff3DA2E4).withOpacity(0.5),
);