import 'package:ecommerce_sample/model/products.dart';
import 'package:ecommerce_sample/model/subCategory.dart';
import 'file:///C:/Users/nader/AndroidStudioProjects/GitHub/ecommerce_sample/lib/ui/categories_details/furniture_category_details_screen.dart';
import 'package:ecommerce_sample/utils/colors_file.dart';
import 'package:ecommerce_sample/utils/navigator.dart';
import 'package:flutter/material.dart';

class SubCategoryScreen extends StatelessWidget {
  final Product product;
  final SubCategory subCategory;
  final Function press;

  const SubCategoryScreen({Key key, this.product, this.press, this.subCategory})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: product.color.withOpacity(0),
        elevation: 0,
        leading: Icon(
          Icons.keyboard_backspace,
          color: whiteColor,
        ),
        title: Text("Sub-category"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: GridView.builder(
            itemCount: furnitureSubCategories.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: .5,
            ),
            itemBuilder: (context, index) {
              return SubCategories(
                subCategories: furnitureSubCategories[index],
                product: products[index],
                press: () => navigateAndKeepStack(
                    context,
                    CategoryDetails(
                        subCategory: furnitureSubCategories[index])),
              );
            },
          ),
        ),
      ),
    );
  }
}

class SubCategories extends StatelessWidget {
  final Product product;
  final SubCategory subCategories;
  final Function press;

  const SubCategories({Key key, this.product, this.subCategories, this.press})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: press,
        leading: Container(
          height: 80,
          width: 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              image: DecorationImage(
                image: AssetImage(subCategories.image),
                fit: BoxFit.cover,
              )),
        ),
        title: Text(
          subCategories.title,
          style: TextStyle(fontSize: 18, color: whiteColor),
        ),
        subtitle: Row(
          children: [
            Text(
              "Price ",
              style: TextStyle(fontSize: 18, color: whiteColor),
            ),
            Text(
              "\$ " + subCategories.price.toString(),
              style: TextStyle(fontSize: 20, color: whiteColor),
            ),
          ],
        ),
      trailing: Container(
        height: 40,
        width: 48,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color:whiteColor)),
        child: Icon(
          Icons.shopping_cart,
          color: whiteColor,
          size: 25,
        ),
      ),
    );
  }
}
