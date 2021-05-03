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

  String qrCodeResult, qrStatus = "Please Scan the QR";
  bool backCamera = true;
  final qrCode = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text("Scan with " + (backCamera ? "Front Cam" : "Back Cam")),
          actions: <Widget>[
            IconButton(
              icon: backCamera ? Icon(Icons.camera_alt) : Icon(Icons.camera),
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
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  qrStatus,
                  // (qrCodeResult == null) || (qrCodeResult == "")
                  //     ? "Please Scan the QR"
                  //     : startReceiving(qrCodeResult),
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w900),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                padding: EdgeInsets.all(10),
                color: Colors.white70,
                child: TextField(
                  controller: qrCode,
                  decoration: InputDecoration(hintText: "Enter OQ Code"),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              MaterialButton(
                color: Colors.purple,
                onPressed: () {
                  if (qrCode.text != "") {
                    qrCodeResult = qrCode.text;
                    startReceiving(qrCodeResult)
                        .then((value) => setQrStatus(value));
                  } else {
                    setState(() {
                      qrStatus = "Please enter valid code.";
                    });
                  }
                },
                child: Text(
                  "Check QR Code",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
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
      startReceiving(qrCodeResult).then((value) {
        setQrStatus(value);
        print(value);
      });
    });
  }

  void setQrStatus(value) {
    setState(() {
      qrStatus = value;
    });
  }

  Future<String> startReceiving(base64Str) async {
    await getName();
    //scan QR
    // var base64Str;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> transaction = prefs.getStringList('transactions');
    print(transaction);
    if (transaction.contains(base64Str)) {
      return "Code already used!!";
    }

    var transObject = jsonDecode(utf8.decode(base64.decode(base64Str)));
    var Amount = int.parse((transObject["1"].toString()));
    var Sender = transObject["2"];
    var Receiver = transObject["3"];
    print("hbdjjkv");
    print(Receiver.toString());
    var expiry = DateTime.parse(transObject["4"]);
    if (expiry.isAfter(DateTime.now()) != true) {
      return "Code has expired";
    }
    //verify current number to Receiver
    if (Receiver.toString() != senderName) {
      return "This Code can't be redeemed by this number";
    }
    //add amount to wallet
    wallet = wallet + Amount;
    prefs.setDouble('wallet', wallet);
    transaction.add(base64Str);
    prefs.setStringList('transactions', transaction);
    print(transaction);
    getName();

    return "Sucess!! Money credited";
  }
}

int camera = 1;
