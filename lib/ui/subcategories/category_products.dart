import 'package:ecommerce_sample/ApiFunctions/Api.dart';
import 'package:ecommerce_sample/model/categories_model.dart' as categoryModel;
import 'package:ecommerce_sample/model/category_products_model.dart';
import 'file:///C:/Users/nader/AndroidStudioProjects/GitHub/ecommerce_sample/lib/ui/product_details/product_details.dart';
import 'package:ecommerce_sample/utils/colors_file.dart';
import 'package:ecommerce_sample/utils/navigator.dart';
import 'package:flutter/material.dart';

class CategoryProducts extends StatefulWidget {
  categoryModel.Success success;

  CategoryProducts(this.success);

  @override
  _CategoryProductsState createState() => _CategoryProductsState();
}

class _CategoryProductsState extends State<CategoryProducts> {
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
      Api(context).categoryProductsApi(_scaffoldKey).then((value) {
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
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.grey,
        elevation: 0,
        leading: IconButton(
          onPressed:(){
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.keyboard_backspace,
          ),
        ),
        title: Text("Sub-category"),
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
    return ListTile(
      onTap: () {
        navigateAndKeepStack(context, CategoryDetails(categoryProductsList[index]));
      },
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
        "${categoryProductsList[index].name}",
        style: TextStyle(fontSize: 18, color: whiteColor),
      ),
      subtitle: Row(
        children: [
          Text(
            "Price ",
            style: TextStyle(fontSize: 18, color: whiteColor),
          ),
          Text(
            "\$ " + "${categoryProductsList[index].price}",
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
