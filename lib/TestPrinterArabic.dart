import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:ecommerce_sample/testPrinter.dart';
import 'package:ecommerce_sample/ui/receipt.dart';
import 'package:ecommerce_sample/utils/navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
 import 'package:usb_serial/usb_serial.dart';


class TestArabicPrinter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new TestArabicPrinterPage(),
    );
  }
}

class TestArabicPrinterPage extends StatefulWidget {
  @override
  _TestArabicPrinterPageState createState() => new _TestArabicPrinterPageState();
}

class _TestArabicPrinterPageState extends State<TestArabicPrinterPage> {
  GlobalKey _globalKey = new GlobalKey();

  bool inside = false;
  Uint8List imageInMemory;

  @override
  void initState() {
    getting();
  }

  getting()async{
  List<UsbDevice> devices = await UsbSerial.listDevices();
  print(devices);

  UsbPort port;
  if (devices.length == 0) {
    return;
  }
  port = await devices[0].create();

  bool openResult = await port.open();
  if ( !openResult ) {
    print("Failed to open");
    return;
  }

  await port.setDTR(true);
  await port.setRTS(true);

  port.setPortParameters(115200, UsbPort.DATABITS_8,
      UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);

  // print first result and close port.
  port.inputStream.listen((Uint8List event) {
    print(event);
    port.close();
  });

  await port.write(Uint8List.fromList([0x10, 0x00]));
}


  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _globalKey,
      child: new Scaffold(
          appBar: new AppBar(
            title: new Text('الفواتير'),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: <Widget>[
                  new Text(
                    'فاتورة رقم ٤٤',
                  ),
                  new RaisedButton(
                    child: Text('capture Image'),
                    onPressed:(){
                      navigateAndKeepStack(context, Receipt("totalPrice",[]));

                    },
                  ),
                  inside ? CircularProgressIndicator()
                      :
                  imageInMemory != null
                      ? Container(
                      child: Image.memory(imageInMemory),
                      margin: EdgeInsets.all(10))
                      : Container(),
                ],
              ),
            ),
          )),
    );
  }
}