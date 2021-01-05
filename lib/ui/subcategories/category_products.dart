import 'package:ecommerce_sample/ApiFunctions/Api.dart';
import 'package:ecommerce_sample/model/add_to_cart_model.dart';
import 'package:ecommerce_sample/model/categories_model.dart' as categoryModel;
import 'package:ecommerce_sample/model/category_products_model.dart';
import 'package:ecommerce_sample/ui/cart.dart';
import 'package:ecommerce_sample/ui/product_details/product_details.dart';
import 'package:ecommerce_sample/utils/colors_file.dart';
import 'package:ecommerce_sample/utils/global_vars.dart';
import 'package:ecommerce_sample/utils/navigator.dart';
import 'package:flutter/material.dart';

class CategoryProducts extends StatefulWidget {
  categoryModel.Success success;

  CategoryProducts(this.success);

  @override
  _CategoryProductsState createState() => _CategoryProductsState();
}

class _CategoryProductsState extends State<CategoryProducts> {
  AddToCartModel cart;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ProductsModel productsModel;
  List<Data> categoryProductsList = List();

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
      Api(context).categoryProductsApi(_scaffoldKey,widget.success.id).then((value) {
        productsModel = value;
        productsModel.success.data.forEach((element) {
          setState(() {
            categoryProductsList.add(element);
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {},
        child: InkWell(
            onTap: () {
              navigateAndKeepStack(context, Cart());
            },
            child: Icon(Icons.add_shopping_cart)),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "products",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          Center(child: Text( totalCount.toString(),style: TextStyle(color: Colors.grey),)),
          IconButton(
            onPressed: () {
              navigateAndKeepStack(context, Cart());
            },
            icon: Icon(
              Icons.shopping_cart,color: Colors.grey,
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: categoryProductsList.length == 0
          ? Center(child: Container(child: Text("No data found")))
          : Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: GridView.builder(
                itemCount: categoryProductsList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: .5,
                ),
                itemBuilder: (context, index) {
                  return Products(index);
                },
              ),
            ),
    );
  }

  Widget Products(int index) {
    return Column(
      children: [
        ListTile(
          onTap: () {
          },
          leading: Container(
            height: 80,
            width: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                image: DecorationImage(
                  image: NetworkImage(

                      categoryProductsList[index].photo==null?
                      "https://forums.oscommerce.com/uploads/monthly_2017_12/C_member_309126.png"

                          : dataBaseUrl+  categoryProductsList[index].photo
                  ),
                  fit: BoxFit.cover,
                )),
          ),
          title: Text(
            "${categoryProductsList[index].nameAr}",
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          subtitle: Row(
            children: [
              Text(
                "Price ",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              Text(
                   "${categoryProductsList[index].price}",
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ],
          ),
          trailing: Container(
            width: 80,
            height: 50,
            child: Row(
              children: [
                GestureDetector(
                  onTap: (){
                    if (categoryProductsList[index].count > 0) {
                      setState(() {
                        totalCount--;
                        categoryProductsList[index].count--;

                        Api(context).editcartApi(_scaffoldKey, categoryProductsList[index].id, categoryProductsList[index].count).then((value) {

                        });
                      });
                    }
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: grey)
                      ),
                      child: Icon(Icons.remove,)
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(categoryProductsList[index].count.toString().padLeft(2, "0")),
                ),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      categoryProductsList[index].count++;
                     totalCount++;
                      print("widgetcount::  ${categoryProductsList[index].count}");
                      print("widgetcount::  ${categoryProductsList[index].count}");
                      Api(context)
                          .addToCart(_scaffoldKey, categoryProductsList[index].id)
                          .then((value) {
                        if (value is AddToCartModel) {
                          cart = value;
                        }
                      });
                    });
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: grey)
                      ),
                      child: Icon(Icons.add,)
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider()
      ],
    );
  }
}

