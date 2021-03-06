import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_usb_write/flutter_usb_write.dart';

import 'package:flutter/services.dart';

import 'package:esc_pos_utils/esc_pos_utils.dart';

import 'package:image/image.dart' as im;


class TestPrinterScreen extends StatefulWidget {
  Uint8List imageInMemory;

  TestPrinterScreen(this.imageInMemory);

  @override
  _TestPrinterScreenState createState() => _TestPrinterScreenState();
}

class _TestPrinterScreenState extends State<TestPrinterScreen> {
  FlutterUsbWrite _flutterUsbWrite = FlutterUsbWrite();
  UsbEvent _lastEvent;
  StreamSubscription<UsbEvent> _usbStateSubscription;
  List<UsbDevice> _devices = [];
  int _connectedDeviceId;
  TextEditingController _textController =
      TextEditingController(text: "Hello world");
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool didInit = false;

  @override
  void initState() {
    super.initState();
    createUsbListener();
  }

  @override
  Future didChangeDependencies() async {
    super.didChangeDependencies();
    if (!didInit) {
      didInit = true;
      await _getPorts();
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> createUsbListener() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _usbStateSubscription =
          _flutterUsbWrite.usbEventStream.listen((UsbEvent event) async {
        setState(() {
          _lastEvent = event;
          print(_lastEvent.device.serial);
        });
        await _getPorts();
        if (event.event.endsWith("USB_DEVICE_DETACHED")) {
          //check if connected device was detached
          if (event.device.deviceId == _connectedDeviceId) {
            // unawaited(_disconnect());

          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('USB Device Example'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 15),
                child: Text(
                    _devices.isNotEmpty
                        ? "Available USB Devices"
                        : "No USB devices available",
                    style: Theme.of(context).textTheme.title),
              ),
              ..._portList(),
              getInputTextBox(),
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 15),
                child: getEventInfo(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getEventInfo() {
    if (_lastEvent == null) return SizedBox.shrink();
    if (_lastEvent.event.endsWith('USB_DEVICE_ATTACHED')) {
      return Text(
        _lastEvent.device.manufacturerName + ' ATTACHED',
        style: TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
        ),
      );
    }
    return Text(
      _lastEvent.device.manufacturerName + ' DETACHED',
      style: TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget getInputTextBox() {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 15),
      child: ListTile(
        title: TextField(
          controller: _textController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Text To Send',
          ),
        ),
        trailing: RaisedButton(
          child: Text("Send"),
          onPressed: () {
            printAction();
          },
        ),
      ),
    );
  }

  Future _getPorts() async {
    try {
      List<UsbDevice> devices = await _flutterUsbWrite.listDevices();
      _devices = devices;
      _connect(_devices[0]).then((value) {
        print(value.toString());
      });
    } on PlatformException catch (e) {
      showSnackBar(e.message);
    }
  }

  List<Widget> _portList() {
    List<Widget> ports = [];
    _devices.forEach((device) {
      ports.add(
        ListTile(
          leading: Icon(Icons.usb),
          title: Text(device.productName),
          subtitle: Text(device.manufacturerName),
          trailing: RaisedButton(
            child: Text(_connectedDeviceId == device.deviceId
                ? "Disconnect"
                : "Connect"),
            onPressed: () async {
              if (_connectedDeviceId == device.deviceId) {
                await _disconnect();
              } else {
                await _connect(device);
              }
            },
          ),
        ),
      );
    });
    if (ports.isEmpty) {
      ports.add(SizedBox.shrink());
    }
    return ports;
  }

  Future<UsbDevice> _connect(UsbDevice device) async {
    try {
      var result = await _flutterUsbWrite.open(
        vendorId: device.vid,
        productId: device.pid,
      );
      setState(() {
        _connectedDeviceId = result.deviceId;
      });
      return result;
    } on PermissionException {
      showSnackBar("Not allowed to do that");
      return null;
    } on PlatformException catch (e) {
      showSnackBar(e.message);
      return null;
    }
  }

  Future _disconnect() async {
    try {
      await _flutterUsbWrite.close();
      setState(() {
        _connectedDeviceId = null;
      });
    } on PlatformException catch (e) {
      showSnackBar(e.message);
    }
  }

  void showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  void dispose() {
    super.dispose();
    if (_usbStateSubscription != null) {
      _usbStateSubscription.cancel();
    }
  }

  Future<void> printAction() async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile,spaceBetweenRows: 100);
    List<int> bytes = [];
    // print(StaticUI().normalise("تجربه"));
//     // bytes += generator.text(StaticUI().normalise("حسين"));
//     //
//     bytes += generator.image(Image.fromBytes(40,  60,widget.imageInMemory));
//
//     List<int> list = 'hussein samir '.codeUnits;
//     List<int> list2 = 'حسين سمير محمد '.codeUnits;
//     Uint8List wqedwd = Uint8List.fromList(list);
//     Uint8List wqedwd2 = Uint8List.fromList(list2);
//     String body = utf8.decode(wqedwd2);
// File dd;
//     bytes += generator.text(body,
//         styles: PosStyles(bold: true));
//
//     bytes += generator.textEncoded(wqedwd2,
//         styles: PosStyles(bold: true));
//     // bytes += generator.image(Image.file());
 //
//      // bytes += generator.image(imageee);
//     print("imageInMemory::  ${widget.imageInMemory}");
//     // bytes += generator.text('test', styles: PosStyles(reverse: true));
    bytes += generator.text('test14322',
        styles: PosStyles(underline: true), linesAfter: 1);
    //var image = AssetImage('graphics/background.png');
   // bytes += generator.image(Image.asset('assets/images/image_01.png',width: 40,height: 40,));

   // bytes += generator.emptyLines(2);
    bytes += generator.cut();


    await _flutterUsbWrite.write(Uint8List.fromList(bytes));
   // await _flutterUsbWrite.write();
  }
}
