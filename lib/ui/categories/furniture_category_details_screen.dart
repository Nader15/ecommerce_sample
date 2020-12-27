
import 'package:ecommerce_sample/model/subCategory.dart';
import 'package:ecommerce_sample/utils/colors_file.dart';
import 'package:flutter/material.dart';

class CategoryDetails extends StatelessWidget {
  final SubCategory subCategory;

  const CategoryDetails({Key key, this.subCategory})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: subCategory.color.withOpacity(0.0),
        elevation: 0,
        leading: Icon(
          Icons.keyboard_backspace,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.shopping_cart,
            ),
          ),
        ],
      ),
      backgroundColor: subCategory.color,
      body: SingleChildScrollView(
        child: Body(
          subCategory: subCategory,
        ),
      ),
    );
  }
}

class Body extends StatelessWidget {
  final SubCategory subCategory;

  const Body({Key key, this.subCategory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 2.9),
                height: MediaQuery.of(context).size.height / 1.865,
                decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(25),
                      topLeft: Radius.circular(25),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Category Name",
                      style: TextStyle(color: whiteColor),
                    ),
                    Text(
                      "${subCategory.title}",
                      style: TextStyle(
                          color: whiteColor,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      children: <Widget>[
                        RichText(
                          text: TextSpan(children: [
                            TextSpan(text: "Price\n"),
                            TextSpan(
                                text: "\$${subCategory.price}",
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold)),
                          ]),
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        Expanded(
                          child: Container(
                            height: 180,
                            width: 160,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(30),
                                image: DecorationImage(
                                  image: AssetImage(subCategory.image),
                                  fit: BoxFit.cover,
                                )),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CartCounter(),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 100,
                      child: Text("${subCategory.description}",style: TextStyle(fontSize: 18),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 20),
                            height: 50,
                            width: 58,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: subCategory.color)),
                            child: Icon(
                              Icons.shopping_cart,
                              color: subCategory.color,
                              size: 25,
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 50,
                              child: FlatButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                color: subCategory.color,
                                onPressed: () {},
                                child: Text(
                                  "Buy Now",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: whiteColor,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class CartCounter extends StatefulWidget {
  @override
  _CartCounterState createState() => _CartCounterState();
}

class _CartCounterState extends State<CartCounter> {
  int noOfItems = 01;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        buildOutLineButton(
          Icons.remove,
          () {
            if (noOfItems > 1) {
              setState(() {
                noOfItems--;
              });
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(noOfItems.toString().padLeft(2, "0")),
        ),
        buildOutLineButton(
          Icons.add,
          () {
            setState(() {
              noOfItems++;
            });
          },
        ),
      ],
    );
  }
}

SizedBox buildOutLineButton(IconData icon, Function press) {
  return SizedBox(
    width: 40,
    height: 30,
    child: OutlineButton(
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      onPressed: press,
      child: Icon(icon),
    ),
  );
}
