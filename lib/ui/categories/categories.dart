import 'package:ecommerce_sample/ApiFunctions/Api.dart';
import 'package:ecommerce_sample/model/categories_model.dart'as category;
import 'package:ecommerce_sample/ui/subcategories/category_products.dart';
import 'package:ecommerce_sample/utils/colors_file.dart';
import 'package:ecommerce_sample/utils/navigator.dart';
import 'package:flutter/material.dart';
import 'package:xs_progress_hud/xs_progress_hud.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  category.CategoriesModel categoriesModel;
  List <category.Success> categoriesList=List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed( Duration(milliseconds: 0), () {
      gettingData();

    });
//    showHud();
  }
  gettingData(){
    setState(() {
      Api(context).categoriesApi(_scaffoldKey).then((value) {

        categoriesModel=value;
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
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        leading: Icon(
          Icons.keyboard_backspace,
          color: greyColorXd,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
              color: greyColorXd,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.shopping_cart,
              color: greyColorXd,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Categories",
              style: TextStyle(
                  color: blackColor, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30,
            ),
            categoriesList.length==0
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
    );
  }
  Widget Category(int index){
    return GestureDetector(
      onTap: (){
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
                  image: NetworkImage("https://forums.oscommerce.com/uploads/monthly_2017_12/C_member_309126.png"),
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
