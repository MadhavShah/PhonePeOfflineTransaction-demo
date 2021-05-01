import 'dart:convert';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}
class _ScanPageState extends State<ScanPage> {

  String senderName;
  double wallet;

  Future<bool> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    senderName = prefs.getString('sender');
    print(senderName);
    wallet = prefs.getDouble('wallet');
  }
  String qrCodeResult;
  bool backCamera = true;
  final qrCode = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Scan with " + (backCamera ? "Front Cam" : "Back Cam")),
          actions: <Widget>[
            IconButton(
              icon: backCamera
                  ? Icon(Icons.camera_alt)
                  : Icon(Icons.camera),
              onPressed: () {
                setState(() {
                  backCamera = !backCamera;
                  camera = backCamera ? 1 : -1;
                });
              },
            ),
            IconButton(
              icon: Icon(MaterialCommunityIcons.qrcode_scan),
              onPressed: () {
                _scan();
              },
            )
          ],
        ),
        body: Center(
          child: Column(
            children: [
              Text(
                (qrCodeResult == null) || (qrCodeResult == "")
                    ? "Please Scan to show some result"
                    : "Result:" + qrCodeResult,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w900),
              ),
              SizedBox(height: 80,),
              Container(
                color: Colors.white70,
                child: TextField(
                  controller: qrCode,
                  decoration: InputDecoration(hintText: "Enter OQ Code"),
                ),
              ),
              SizedBox(height: 20,),
              MaterialButton(
                color: Colors.purple,
                onPressed: () {

                },
                child: Text("Check QR Code",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              )
            ],
          ),
        ));
  }
  Future<void> _scan() async {
    ScanResult codeSanner = await BarcodeScanner.scan(
      options: ScanOptions(
        useCamera: camera,
      ),
    );
    setState(() {
      qrCodeResult = codeSanner.rawContent;
    });
  }


  Future<void> startReceiving(base64Str) async {
    await getName();
    //scan QR
    // var base64Str;
    var transObject = jsonDecode(utf8.decode(base64.decode(base64Str)));
    var Amount = int.parse((transObject["1"].toString()));
    var Sender = transObject["2"];
    var Receiver = transObject["3"];
    var expiry = DateTime.parse(transObject["4"]);
    if (expiry.isAfter(DateTime.now()) != true) {
      print("Transaction timeout");
      return;
    }
    //verify current number to Receiver
    if (Receiver != senderName) {
      print("Wrong code !! Cannot be redeemed by this number.");
      return;
    }
    //add amount to wallet
    wallet = wallet + Amount;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('wallet', wallet);
  }
}
int camera = 1;


