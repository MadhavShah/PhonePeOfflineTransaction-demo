import 'dart:io';
import 'dart:convert';

var Wallet1 = 500;
var Wallet2 = 500;
var current = 1234;

// import 'package:connectivity/connectivity.dart';

  
void main() {
  var base64Str = startSending();
  startReceiving(base64Str);
}

String startSending() {
  var Amount = 100, Sender, Receiver = 1234;
  var expiry = DateTime.now().add(const Duration(minutes: 5));
  var transObject = {
    "1": Amount,
    "2": Sender,
    "3": Receiver,
    "4": expiry.toString()
  };
  var base64Str = base64.encode(utf8.encode(jsonEncode(transObject)));
  // Deduct amount from wallet money
  if (Amount > Wallet1) {
    print(" Insufficient Amount ");
    return "";
  }
  Wallet1 = Wallet1 - Amount;

  print(base64Str);
  return base64Str;

  /// generate qr and show
}

void startReceiving(base64Str) {
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
  if (Receiver != current) {
    print("Wrong code !! Cannot be redeemed by this number.");
    return;
  }
  //add amount to wallet
  Wallet2 = Wallet2 + Amount;
}
