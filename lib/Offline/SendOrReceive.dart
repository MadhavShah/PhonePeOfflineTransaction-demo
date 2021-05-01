import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ReceiveMoney.dart';
import 'SendMoney.dart';

class SendOrReceive extends StatefulWidget {
  @override
  _SendOrReceiveState createState() => _SendOrReceiveState();
}

class _SendOrReceiveState extends State<SendOrReceive> {

  final _amount = TextEditingController();
  final _receiver = TextEditingController();
  String senderName;
  double wallet;

  Future<bool> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
     senderName = prefs.getString('sender');
    print(senderName);
    wallet = prefs.getDouble('wallet');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
           crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MaterialButton(
                color: Colors.purple,
                  onPressed: () {
                      return showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Let's send Money!!"),
                              content: Container(
                                height: 300,
                                child: Column(
                                  children: [
                                    TextField(
                                  controller: _amount,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(hintText: "Amount to be transferred"),
                                    ),
                                    SizedBox(height: 10,),
                                     TextField(
                                       controller: _receiver,
                                       decoration: InputDecoration(hintText: "Name of Receiver"),
                                    ),
                                    SizedBox(height: 20,),
                                    MaterialButton(
                                      color: Colors.purple,
                                      onPressed: () {
                                        generateQRCode();

                                      },
                                      child: Text("Send Money >",
                                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          });

                    },
                child: Text("SEND MONEY",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              SizedBox(height: 50),
              MaterialButton(
                color: Colors.purple,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ScanPage()),
                    );
                  },
                child: Text("RECEIVE MONEY",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> generateQRCode() async {
    await getName();
    print(_amount.text);
    var expiry = DateTime.now().add(const Duration(minutes: 5));
    var transObject = {
      "1": _amount.text,
      "2": senderName,
      "3": _receiver.text,
      "4": expiry.toString()
    };
    var base64Str = base64.encode(utf8.encode(jsonEncode(transObject)));
    // Deduct amount from wallet money
    print("Q R CODE");
    print(base64Str);
    print(wallet);
    if (double.parse(_amount.text) < wallet) {
      showToast("Insufficient Amount in Wallet");
    }else {
      wallet = wallet - double.parse(_amount.text);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setDouble('wallet', wallet);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GenerateQR(base64Str)),
      );
    }
    print(base64Str);
  }

  showToast(String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

}


