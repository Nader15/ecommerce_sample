import 'package:ecommerce_sample/ApiFunctions/Api.dart';
import 'package:ecommerce_sample/model/cart_content_model.dart';
import 'package:ecommerce_sample/ui/categories/categories.dart';
import 'package:ecommerce_sample/utils/colors_file.dart';
import 'package:ecommerce_sample/utils/global_vars.dart';
import 'package:ecommerce_sample/utils/navigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Receipt extends StatefulWidget {
  @override
  _ReceiptState createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  CartContentModel cartContentModel;
  List<Success> cartList = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 0), () {
      gettingData();
    });
//    showHud();
  }

  gettingData() {
    setState(() {
      cartList = List();
      Api(context).cartContent(_scaffoldKey).then((value) {
        cartContentModel = value;
        cartContentModel.success.forEach((element) {
          setState(() {
            print("idid:: ${element.productId}");
            print("amountamount:: ${element.amount}");
            cartList.add(element);
          });
        });

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: InkWell(
        onTap: () {
          Api(context).orderCartApi(_scaffoldKey).then((value) {
            totalCount = 0;
            navigateAndClearStack(context, Categories());
          });
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
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height/1.451,
                        child: GridView.builder(
                          itemCount: CartListVar.length,
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            childAspectRatio: 5.5,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: .5,
                          ),
                          itemBuilder: (context, index) {
                            return CartList(index);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
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
            "${CartListVar[index].product.name}",
            style: TextStyle(fontSize: 18, color: blackColor),
          ),
          trailing: Container(
            width: MediaQuery.of(context).size.width/3.5,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "x${OderedProductAmount.toString()}",
                  style: TextStyle(fontSize: 18, color: blackColor),
                ),
                Text(
                  "cost ${CartListVar[index].product.price}",
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
