
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenerateQR extends StatefulWidget {
  String qrData;
  GenerateQR(this.qrData);
  @override
  _GenerateQRState createState() => _GenerateQRState();
}

class _GenerateQRState extends State<GenerateQR> {

  final qrdataFeed = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Appbar having title
      appBar: AppBar(
        title: Center(child: Text("Generate QR Code")),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(

          //Scroll view given to Column
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              QrImage(data: widget.qrData),
              SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.all(8.0),
                //Button for generating QR code
                child: FlatButton(
                  onPressed: () async {


                  },
                  //Title given on Button
                  child: Text("Copy & Share QR",style: TextStyle(color: Colors.indigo[900],),),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Colors.indigo[900]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
