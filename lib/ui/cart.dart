import 'package:ecommerce_sample/ApiFunctions/Api.dart';
import 'package:ecommerce_sample/model/add_to_cart_model.dart';

import 'package:ecommerce_sample/model/cart_content_model.dart';
import 'package:ecommerce_sample/model/cart_content_model.dart'as cartContent;
import 'package:ecommerce_sample/model/category_products_model.dart';
import 'package:ecommerce_sample/utils/colors_file.dart';
import 'package:ecommerce_sample/utils/navigator.dart';
import 'package:flutter/material.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  CartContentModel cartContentModel;
  List<cartContent.Success> cartList = List();

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
      Api(context).cartContent(_scaffoldKey).then((value) {
        cartContentModel = value;
        cartContentModel.success.forEach((element) {
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
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.keyboard_backspace,
            ),
          ),
          actions: [
            Center(child: Text(cartList.length.toString())),
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
              : Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: GridView.builder(
                      itemCount: cartList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        childAspectRatio: 4,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: .5,
                      ),
                      itemBuilder: (context, index) {
                        return CartList(index);
                      },
                    ),
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
                "\$${cartList[index].product.price}",
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
                  image: NetworkImage(
                      "https://forums.oscommerce.com/uploads/monthly_2017_12/C_member_309126.png"),
                  fit: BoxFit.cover,
                )),
          ),
          title: Text(
            "${cartList[index].product.name}",
            style: TextStyle(fontSize: 18, color: blackColor),
          ),
          trailing: GestureDetector(
            onTap: (){},
            child: Container(
              height: 40,
              width: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${cartList[index].amount}",
                    style: TextStyle(fontSize: 20, color: blackColor),
                  ),
                  Container(
                    width: 40,
                    height: 50,
                    child: CartCounter(index: index),
                  ),
                ],
              ),
            ),
          ),
        ),
        Divider(),
      ],
    );
  }
}

class CartCounter extends StatefulWidget {
  int index ;
  CartCounter({this.index});

  @override
  _CartCounterState createState() => _CartCounterState();
}
class _CartCounterState extends State<CartCounter> {
  int noOfItems = 00;
  AddToCartModel cart;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ProductsModel productsModel;
  List<Data> categoryProductsList = List();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: (){
            if (noOfItems > 0) {
              setState(() {
                noOfItems--;
              });
            }
          },
          child: Container(
            width: 20,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: grey)
              ),
              child: Icon(Icons.remove,size: 15,)
          ),
        ),
        Padding(
          padding:EdgeInsets.zero,
          child: Text(noOfItems.toString().padLeft(2, "0")),
        ),
        GestureDetector(
          onTap: (){
            setState(() {
              noOfItems++;
              Api(context)
                  .addToCart(_scaffoldKey, categoryProductsList[1].id)
                  .then((value) {
                if (value is AddToCartModel) {
                  cart = value;
                }
              });
            });
          },
          child: Container(
            width: 20,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: grey)
              ),
              child: Icon(Icons.add,size: 15,)
          ),
        ),
      ],
    );
  }
}
