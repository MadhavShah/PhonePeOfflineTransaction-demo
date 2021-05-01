import 'package:flutter/material.dart';

class SendOrReceive extends StatefulWidget {
  @override
  _SendOrReceiveState createState() => _SendOrReceiveState();
}

class _SendOrReceiveState extends State<SendOrReceive> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MaterialButton(
                onPressed: () {},
              child: Text("SEND MONEY"),
            ),
            MaterialButton(
                onPressed: () {} ,
              child: Text("RECEIVE MONEY"),
            )
          ],
        ),
      ),
    );
  }
}
