import 'package:ecommerce_sample/ApiFunctions/Api.dart';

import 'package:ecommerce_sample/model/cart_content_model.dart';
import 'package:ecommerce_sample/model/cart_content_model.dart';
import 'package:ecommerce_sample/ui/categories/categories.dart';
import 'package:ecommerce_sample/utils/colors_file.dart';
import 'package:ecommerce_sample/utils/global_vars.dart';
import 'package:ecommerce_sample/utils/navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  CartContentModel cartContentModel;
  List<Success> cartList = List();

  var totalPrice = 0.0;

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
        getTotalPrice();
      });
    });
  }

  getTotalPrice() {
    totalPrice = 0.0;
    for (int i = 0; i < cartList.length; i++) {
      setState(() {
        totalPrice += (double.parse((cartList[i].product.price)) *
            double.parse(cartList[i].amount.toString()));
        print("totalPrice::: ${totalPrice}");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.grey,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.keyboard_backspace,
            ),
          ),
          actions: [
            Center(child: Text(totalCount.toString())),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.shopping_cart,
              ),
            ),
          ],
          title: Text("Cart"),
          centerTitle: true,
        ),
        body: Container(
          child: cartList.length == 0
              ? Center(
                  child: Container(
                    child: Text("No data found"),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 1.3,
                        child: GridView.builder(
                          itemCount: cartList.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            childAspectRatio: 4,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: .5,
                          ),
                          itemBuilder: (context, index) {
                            return Slidable(
                                actionPane: SlidableDrawerActionPane(),
                                actions: <Widget>[
                                  IconSlideAction(

                                    onTap: () {
                                      Api(context)
                                          .removeFromCartContent(
                                              _scaffoldKey, cartList[index].productId)
                                          .then((value) {

                                        gettingData();
                                      });
                                    },
                                    caption: 'delete',
                                    foregroundColor: Colors.white,
                                    color: Colors.white,
                                    iconWidget: Container(

                                        child: Icon(
                                          Icons.delete_outline,
                                          color: Colors.redAccent,
                                          size: 25,
                                        )),
                                  ),
                                ],
                                child: CartList(index));
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          Api(context).orderCartApi(_scaffoldKey).then((value) {
                            totalCount = 0;
                            navigateAndClearStack(context, Categories());
                          });
                        },
                        child: Container(
                          color: Colors.green,
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Total Cost  ${totalPrice}"),
                              Text("Pay  ${totalPrice}"),
                            ],
                          )),
                        ),
                      )
                      // Text("Total Cost",style: TextStyle(fontSize: 20),),
                      // //
                      // Text("${totalPrice}",style: TextStyle(fontSize: 20),),
                    ],
                  ),
                ),
        ));
  }

  Widget CartList(int index) {
    return Column(
      children: [
        ListTile(
          subtitle: Row(
            children: [
              Text(
                "Price ",
                style: TextStyle(fontSize: 18, color: blackColor),
              ),
              Text(
                "${cartList[index].product.price}",
                style: TextStyle(fontSize: 20, color: blackColor),
              ),
            ],
          ),
          onTap: () {},
          leading: Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                image: DecorationImage(
                  image: NetworkImage(cartList[index].product.photo == null
                          ? "https://forums.oscommerce.com/uploads/monthly_2017_12/C_member_309126.png"
                          : dataBaseUrl + cartList[index].product.photo

                      // "https://forums.oscommerce.com/uploads/monthly_2017_12/C_member_309126.png"

                      ),
                  fit: BoxFit.cover,
                )),
          ),
          title: Text(
            "${cartList[index].product.name}",
            style: TextStyle(fontSize: 18, color: blackColor),
          ),
          trailing: Container(
            width: 80,
            height: 50,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if(cartList[index].amount==1){
                      Api(context)
                          .removeFromCartContent(
                          _scaffoldKey, cartList[index].productId)
                          .then((value) {

                        gettingData();
                      });
                    }
                    else if (cartList[index].amount > 0) {
                      setState(() {
                        totalCount--;
                        cartList[index].amount--;

                        Api(context)
                            .editcartApi(
                                _scaffoldKey,
                                cartList[index].productId,
                                cartList[index].amount)
                            .then((value) {
                          gettingData();
                        });
                      });
                    }

                  },
                  child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: grey)),
                      child: Icon(
                        Icons.remove,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child:
                      Text(cartList[index].amount.toString().padLeft(2, "0")),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      cartList[index].amount++;
                      totalCount++;
                      print("widget::${cartList[index].amount}");
                      Api(context)
                          .editcartApi(_scaffoldKey, cartList[index].productId,
                              cartList[index].amount)
                          .then((value) {
                        gettingData();
                      });
                    });
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: grey)),
                      child: Icon(
                        Icons.add,
                      )),
                ),
              ],
            ),
          ),
        ),
        Divider(),
      ],
    );
  }
}
