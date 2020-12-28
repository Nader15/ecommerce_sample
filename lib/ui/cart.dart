import 'package:ecommerce_sample/ApiFunctions/Api.dart';
import 'package:ecommerce_sample/model/cart_model.dart' ;
import 'package:ecommerce_sample/model/cart_model.dart';
import 'package:ecommerce_sample/utils/colors_file.dart';
import 'package:ecommerce_sample/utils/navigator.dart';
import 'package:flutter/material.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  CartModel cartModel;
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
      Api(context).cartDetails(_scaffoldKey).then((value) {
        cartModel = value;
        cartModel.success.forEach((element) {
          setState(() {
            cartList.add(element);
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.grey,
          elevation: 0,
          leading: Icon(
            Icons.keyboard_backspace,
          ),
         title: Text("Cart"),
          centerTitle: true,
        ),
        body: Container(
          child:  cartList.length==0
              ? Center(
            child: Container(
              child: Text("No data found"),
            ),
          )
              : Expanded(
                  child: GridView.builder(
                    itemCount: cartList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.70,
                      mainAxisSpacing: 0.3,
                      crossAxisSpacing: 20,
                    ),
                    itemBuilder: (context, index) {
                      return CartList(index);
                    },
                  ),
                ),
        ));
  }

  Widget CartList(int index) {
    return ListTile(
      onTap: () {},
      leading: Container(
        height: 80,
        width: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            image: DecorationImage(
              image: NetworkImage(
                  "https://forums.oscommerce.com/uploads/monthly_2017_12/C_member_309126.png"),
              fit: BoxFit.cover,
            )),
      ),
      title: Text(
        "${cartList[index].productId}",
        style: TextStyle(fontSize: 18, color: whiteColor),
      ),
      subtitle: Row(
        children: [
          Text(
            "Amount ",
            style: TextStyle(fontSize: 18, color: whiteColor),
          ),
          Text(
            "${cartList[index].amount}",
            style: TextStyle(fontSize: 20, color: whiteColor),
          ),
        ],
      ),
      trailing: Container(
        height: 40,
        width: 48,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: whiteColor)),
        child: Icon(
          Icons.shopping_cart,
          color: whiteColor,
          size: 25,
        ),
      ),
    );
  }
}
