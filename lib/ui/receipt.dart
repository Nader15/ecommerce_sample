import 'dart:async';
import 'dart:typed_data';

import 'package:ecommerce_sample/ApiFunctions/Api.dart';
import 'package:ecommerce_sample/model/cart_content_model.dart';
import 'package:ecommerce_sample/ui/categories/categories.dart';
import 'package:ecommerce_sample/utils/colors_file.dart';
import 'package:ecommerce_sample/utils/global_vars.dart';
import 'package:ecommerce_sample/utils/navigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_usb_write/flutter_usb_write.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';

class Receipt extends StatefulWidget {
  var totalPrice;
  List<Success> cartList;
  Receipt(this.totalPrice,this.cartList);

  @override
  _ReceiptState createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  FlutterUsbWrite _flutterUsbWrite = FlutterUsbWrite();
  UsbEvent _lastEvent;
  StreamSubscription<UsbEvent> _usbStateSubscription;
  List<UsbDevice> _devices = [];
  int _connectedDeviceId;
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

  Future<void> printAction() async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    List<int> bytes = [];

    bytes += generator.text('Fenjan Cafe',
        styles: PosStyles(underline: true), linesAfter: 1);
    bytes +=
        generator.text('Align left', styles: PosStyles(align: PosAlign.left));


    // bytes += generator.row([
    //   PosColumn(
    //     text: widget.cartList[index].product.name,
    //     width: 3,
    //     styles: PosStyles(align: PosAlign.center, underline: true),
    //   ),
    //   PosColumn(
    //     text: 'x ${"${widget.cartList[index].product.amount}"}',
    //     width: 6,
    //     styles: PosStyles(align: PosAlign.center, underline: true),
    //   ),
    //   PosColumn(
    //     text: widget.cartList[index].product.price,
    //     width: 3,
    //     styles: PosStyles(align: PosAlign.center, underline: true),
    //   ),
    // ]);



    // bytes += generator.row([
    //   PosColumn(
    //     text: "Total Price ",
    //     width: 3,
    //     styles: PosStyles(align: PosAlign.center, underline: true),
    //   ),
    //   PosColumn(
    //     text: widget.totalPrice.toString(),
    //     width: 6,
    //     styles: PosStyles(align: PosAlign.center, underline: true),
    //   ),
    //
    // ]);

    // bytes += generator.text('Text size 200%',
    //     styles: PosStyles(
    //       height: PosTextSize.size2,
    //       width: PosTextSize.size2,
    //     ));

    // Print image:
    // final ByteData data = await rootBundle.load('assets/logo.png');


    bytes += generator.feed(2);
    bytes += generator.cut();
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
  void showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
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
  Future<void> createUsbListener() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.

    print("WQfqwfffff");
    if (!mounted) return;

    setState(() {
      _usbStateSubscription =
          _flutterUsbWrite.usbEventStream.listen((UsbEvent event) async {
            setState(() {
              _lastEvent = event;
              print(_lastEvent.device.serial+"devicedevicedevice ");
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
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration(milliseconds: 0), () {
      gettingData();
    });
    super.initState();

//    showHud();
  }

  gettingData() {
    createUsbListener();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: InkWell(
        onTap: () {
          printAction();
          // Api(context).orderCartApi(_scaffoldKey).then((value) {
          //   totalCount = 0;
          //
          //   navigateAndClearStack(context, Categories());
          // });/
        },
        child: Container(
          color: Colors.orangeAccent,
          width: MediaQuery.of(context).size.width,
          height: 50,
          child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Print Receipt",style: TextStyle(color: whiteColor,fontWeight: FontWeight.bold,fontSize: 20),),
                ],
              )),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              // Container(
              //   padding: EdgeInsets.all(10),
              //   child: Image.asset(
              //     "assets/images/coffee-cup.png",
              //     fit: BoxFit.fitHeight,
              //     // width: MediaQuery.of(context).size.width,
              //   ),
              //   height: MediaQuery.of(context).size.height / 3.5,
              // ),
              SizedBox(height: 20,),
              Text("Total Price",style: TextStyle(fontSize: 30),),
              SizedBox(height: 20,),
              Text("${TotalPrice.toString()}",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
              Divider(thickness: 1,),
              // SingleChildScrollView(
              //   child: Padding(
              //     padding: const EdgeInsets.all(20.0),
              //     child: Column(
              //       children: [
              //         Container(
              //           width: MediaQuery.of(context).size.width,
              //           height: MediaQuery.of(context).size.height/1.451,
              //           child: GridView.builder(
              //             itemCount: widget.cartList.length,
              //             gridDelegate:
              //             SliverGridDelegateWithFixedCrossAxisCount(
              //               crossAxisCount: 1,
              //               childAspectRatio: 5.5,
              //               mainAxisSpacing: 10,
              //               crossAxisSpacing: .5,
              //             ),
              //             itemBuilder: (context, index) {
              //
              //               return CartList(index);
              //             },
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
  Widget CartList(int index) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            "${widget.cartList[index].product.name}",
            style: TextStyle(fontSize: 18, color: blackColor),
          ),
          trailing: Container(
            width: MediaQuery.of(context).size.width/3.5,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "x${widget.cartList[index].amount}",
                  style: TextStyle(fontSize: 18, color: blackColor),
                ),
                Text(
                  "cost ${widget.cartList[index].product.price}",
                  style: TextStyle(fontSize: 18, color: blackColor),
                ),
              ],
            ),
          ),
        ),
        Divider(thickness: 1,height: 0,)
      ],
    );
  }
}
