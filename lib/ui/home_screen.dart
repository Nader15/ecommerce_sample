import 'package:ecommerce_sample/model/products.dart';
import 'package:ecommerce_sample/ui/subcategories/furniture_subcategory_screen.dart';
import 'package:ecommerce_sample/utils/colors_file.dart';
import 'package:ecommerce_sample/utils/navigator.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Expanded(
              child: GridView.builder(
                itemCount: products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.70,
                  mainAxisSpacing: 0.3,
                  crossAxisSpacing: 20,
                ),
                itemBuilder: (context, index) {
                  return ItemCard(
                    product: products[index],
                    press: () => navigateAndKeepStack(
                        context, SubCategoryScreen(product: products[index])),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  final Product product;
  final Function press;

  const ItemCard({Key key, this.product, this.press}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        children: [
          Container(
            height: 180,
            width: 160,
            decoration: BoxDecoration(
                color: product.color,
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: AssetImage(product.image),
                  fit: BoxFit.cover,
                )),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            product.title,
            style: TextStyle(color: greyColorXd, fontSize: 17),
          )
        ],
      ),
    );
  }
}
