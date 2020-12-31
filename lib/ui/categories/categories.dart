import 'package:ecommerce_sample/ApiFunctions/Api.dart';
import 'package:ecommerce_sample/ApiFunctions/sharedPrefClass.dart';
import 'package:ecommerce_sample/model/categories_model.dart' as category;
import 'package:ecommerce_sample/ui/AttendAndGo/DrawerWidget.dart';
 import 'package:ecommerce_sample/ui/cart.dart';
import 'package:ecommerce_sample/ui/subcategories/category_products.dart';
import 'package:ecommerce_sample/utils/colors_file.dart';
import 'package:ecommerce_sample/utils/global_vars.dart';
import 'package:ecommerce_sample/utils/navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xs_progress_hud/xs_progress_hud.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  category.CategoriesModel categoriesModel;
  List<category.Success> categoriesList = List();
  Future<bool> onWillPop(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Container(
          height: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ListTile(
                title: Text(
                  "Are you sure to logOut",
                  style: TextStyle(fontFamily: "BoutrosAsma_Regular"),
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 5, bottom: 5),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          border: Border.all(
                              width: 1,
                              color: Colors
                                  .grey //                   <--- border width here
                          ),
                        ),
                        child: Text(
                          "Exit",
                          style: TextStyle(color: Colors.white),
                        )),
                    onTap: () {
                      SystemChannels.platform
                          .invokeMethod('SystemNavigator.pop');
                    },
                  ),
                  GestureDetector(
                    child: Container(
                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 5, bottom: 5),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          border: Border.all(
                              width: 1,
                              color: Colors
                                  .grey //                   <--- border width here
                          ),
                        ),
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: Colors.white),
                        )),
                    onTap: () {
                      print('Tappped');
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 0), () {
      getUserAttend(context).then((value) {
        gettingData();
      });

    });
//    showHud();
  }

  gettingData() {
    setState(() {
      Api(context).categoriesApi(_scaffoldKey).then((value) {
        categoriesModel = value;
        categoriesModel.success.forEach((element) {
          setState(() {
            categoriesList.add(element);
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onWillPop(context),

      child: Scaffold(
        drawer: Container(
            width: MediaQuery.of(context).size.width/2,
            child: DrawerWidget()),
        key: _scaffoldKey,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),

          backgroundColor: whiteColor,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "categories",
            style: TextStyle(color: Colors.black),
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

        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              categoriesList.length == 0
                  ? Center(
                      child: Container(
                        child: Text("No data found"),
                      ),
                    )
                  : Expanded(
                      child: GridView.builder(
                        itemCount: categoriesList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.70,
                          mainAxisSpacing: 0.3,
                          crossAxisSpacing: 20,
                        ),
                        itemBuilder: (context, index) {
                          return Category(index);
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget Category(int index) {
    return GestureDetector(
      onTap: () {
        navigateAndKeepStack(context, CategoryProducts(categoriesList[index]));
      },
      child: Column(
        children: [
          Container(
            height: 180,
            width: 160,
            decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: NetworkImage(
                      categoriesList[index].logo==null?
                      "https://forums.oscommerce.com/uploads/monthly_2017_12/C_member_309126.png"

                          : dataBaseUrl+  categoriesList[index].logo

                  ),
                  fit: BoxFit.cover,
                )),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "${categoriesList[index].name}",
            style: TextStyle(color: greyColorXd, fontSize: 17),
          )
        ],
      ),
    );
  }

  Future<void> showMessageHud() async {
    XsProgressHud.showMessage(context, "Flutter app");
  }

  Future<void> showHud() async {
    XsProgressHud.show(context);
    Future.delayed(Duration(milliseconds: 2000)).then((val) {
      showMessageHud();
    });
  }
}
