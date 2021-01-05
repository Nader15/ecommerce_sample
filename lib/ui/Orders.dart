import 'package:ecommerce_sample/ApiFunctions/Api.dart';
import 'package:ecommerce_sample/model/AttendListModel.dart';
import 'package:ecommerce_sample/model/OrdersListModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrdersListScreen extends StatefulWidget {
  @override
  _OrdersListScreenState createState() => _OrdersListScreenState();
}

class _OrdersListScreenState extends State<OrdersListScreen> {
  OrdersListModel orderListModel;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<OrdersItem> orderList = List();
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration(milliseconds: 0), () {
      gettingData();
    });

    super.initState();
  }

  gettingData() {
    Api(context).ordersListApi(_scaffoldKey).then((value) {
      orderListModel = value;
      orderListModel.success.forEach((element) {
        setState(() {
          // DateFormat format = new DateFormat("HH:mm:ss");
          // DateTime time = format.parse(element.createdAt.split("T")[1]);
          // time.toLocal();
          //
          // print("toLocal:: ${ time.toLocal()}");
          orderList.add(element);
        });
      });

      setState(() {
        orderList = orderList.reversed.toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text(
          "الطلبات",
          style: TextStyle(color: Colors.black),
        ),
      ),
      key: _scaffoldKey,
      body: Container(
        child: orderList.length == 0
            ? Container(
                child: Center(child: Text("No data found")),
              )
            : ListView.builder(
                itemCount: orderList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      ListTile(
                        title: orderList[index].product == null
                            ? Text("")
                            : Text(orderList[index].product.name ?? ""),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(orderList[index].createdAt.split("T")[0] +
                                "${(int.parse(orderList[index].createdAt.split("T")[1].split(":")[0]) + 2) > 24 ? ( (int.parse(orderList[index].createdAt.split("T")[1].split(":")[0]) + 2)-2) : (int.parse(orderList[index].createdAt.split("T")[1].split(":")[0]) + 2)} : ${orderList[index].createdAt.split("T")[1].split(":")[1]}"),
                            orderList[index].product == null

                                ? Text("")

                                : Text("  جنيه ${(double.parse(orderList[index].amount.toString()) * double.parse(orderList[index].product.price))}")

                          ],
                        ),
                        trailing: Text(orderList[index].amount.toString()),
                      ),
                      Divider()
                    ],
                  );
                }),
      ),
    );
  }
}
