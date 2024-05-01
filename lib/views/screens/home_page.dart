import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _result = "Hey there !";

  Map<String, dynamic> data = {
    'name': 'hello',
    'age': 12,
    'Addresh': '52,Gurukrupa society,Katargam ,Surat',
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  GlobalKey<FormState> key = GlobalKey<FormState>();

  Future<void> startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            '#ff6666', 'cancel', true, ScanMode.BARCODE)!
        .listen((event) => log(event));
  }

  Future<void> scanQR() async {
    log("object");
    String barcode;
    try {
      barcode = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'cancel', true, ScanMode.QR);
      log(barcode);
      var qrdata = jsonDecode(barcode);

      log(qrdata.toString());
    } on PlatformException {
      barcode = 'failed to get platform';
      log(barcode);
    }
    if (!mounted) return;

    setState(() {
      _result = barcode;
    });
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'cancel', true, ScanMode.BARCODE);
    }

    if (!mounted) return;

    setState(() {
      _result = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Builder(
        builder: (context) {
          return Container(
            child: Form(
              child: Flex(
                direction: Axis.vertical,
                children: [
                  ElevatedButton(
                      onPressed: () => scanBarcodeNormal(),
                      child: Text("Start barcode scan")),
                  ElevatedButton(
                      onPressed: () {
                        log("=====>>>>>>>>>>>>>");
                        scanQR();
                      },
                      child: Text("Start QR Scan")),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Enter Your Text',
                    ),
                  )
                  // ElevatedButton(
                  //     onPressed: () => startBarcodeScanStream(),
                  //     child: Text("Start QR scan")),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
