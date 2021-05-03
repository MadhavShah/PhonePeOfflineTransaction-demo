import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Constant.dart';
import 'ReceiveMoney.dart';
import 'SendMoney.dart';

class SendOrReceive extends StatefulWidget {
  double wallet;
  String senderName;
  SendOrReceive(this.wallet, this.senderName);

  @override
  _SendOrReceiveState createState() => _SendOrReceiveState();
}

class _SendOrReceiveState extends State<SendOrReceive> {
  final _amount = TextEditingController();
  final _receiver = TextEditingController();
  String senderName;
  double wallet;

  @override
  Widget build(BuildContext context) {
    void updateWallet(prefs) {
      setState(() {
        wallet = prefs.getDouble('wallet');
      });
    }

    SharedPreferences.getInstance().then((prefs) => updateWallet(prefs));

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
              SizedBox(height: 30),
              Text("Your Wallet Balance - $wallet"),
              SizedBox(height: 30),
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
                                  decoration: InputDecoration(
                                      hintText: "Amount to be transferred"),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                  controller: _receiver,
                                  decoration: InputDecoration(
                                      hintText: "Mobile Number of Receiver"),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                MaterialButton(
                                  color: Colors.purple,
                                  onPressed: () {
                                    generateQRCode();
                                  },
                                  child: Text(
                                    "Send Money >",
                                    style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      });
                },
                child: Text(
                  "SEND MONEY",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              SizedBox(height: 50),
              MaterialButton(
                color: Colors.purple,
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => ScanPage()),
                      ModalRoute.withName(PHONE_PE));
                },
                child: Text(
                  "RECEIVE MONEY",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> generateQRCode() async {
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
    print(widget.wallet);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (double.parse(_amount.text) > wallet) {
      showToast("Insufficient Amount in Wallet");
      return;
    } else {
      wallet = wallet - double.parse(_amount.text);
      prefs.setDouble('wallet', wallet);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => GenerateQR(base64Str)),
          ModalRoute.withName(PHONE_PE));
    }
    var transaction = prefs.getStringList('transaction');
    transaction.add(base64Str);
    prefs.setStringList('transaction', transaction);
    print(transaction);
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
        fontSize: 16.0);
  }
}
