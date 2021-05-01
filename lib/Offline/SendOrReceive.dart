import 'package:flutter/material.dart';

import 'ReceiveMoney.dart';
import 'SendMoney.dart';

class SendOrReceive extends StatefulWidget {
  @override
  _SendOrReceiveState createState() => _SendOrReceiveState();
}

class _SendOrReceiveState extends State<SendOrReceive> {
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GenerateQR()),
                    );
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
                      MaterialPageRoute(builder: (context) => ScanQR()),
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
}
