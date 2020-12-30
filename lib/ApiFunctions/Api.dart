import 'dart:convert';
import 'dart:io';
import 'package:ecommerce_sample/ApiFunctions/sharedPrefClass.dart';
import 'package:ecommerce_sample/model/AttendListModel.dart';
import 'package:ecommerce_sample/model/add_to_cart_model.dart';
import 'package:ecommerce_sample/model/cart_content_model.dart';
import 'package:ecommerce_sample/model/categories_model.dart';
import 'package:ecommerce_sample/model/category_products_model.dart';
import 'package:ecommerce_sample/ui/error401_page.dart';
import 'package:ecommerce_sample/ui/home_screen.dart';
import 'package:ecommerce_sample/utils/custom_widgets/cusstom_snackBar.dart';
import 'package:ecommerce_sample/utils/navigator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xs_progress_hud/xs_progress_hud.dart';

class Api {
  String baseUrl = 'https://cafeshs.herokuapp.com/api/';
  final String categories = "categories";
  final String products = "products";
  final String addToCartLink = "add/cart";
  final String cartLink = "cart";
  final String attend = "add/attends";
  final String attends = "attends";
   BuildContext context;

  Api(@required this.context);

  Future categoriesApi(GlobalKey<ScaffoldState> _scaffoldKey) async {
    XsProgressHud.show(context);

    final String completeUrl = baseUrl + categories;

    final response = await http.post(
      completeUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    Map<String, dynamic> dataContent = json.decode(response.body);
    XsProgressHud.hide();
    if (response.statusCode == 200) {
      return CategoriesModel.fromJson(dataContent);
    } else if (response.statusCode == 401) {
      clearAllData();

      navigateAndClearStack(context, Error401Page());
    } else {
      CustomSnackBar(_scaffoldKey, json.decode(response.body).toString());
      return false;
    }
  }
  Future getAttendanceApi(GlobalKey<ScaffoldState> _scaffoldKey) async {
    XsProgressHud.show(context);

    final String completeUrl = baseUrl + attends;

    final response = await http.get(
      completeUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    Map<String, dynamic> dataContent = json.decode(response.body);
    XsProgressHud.hide();
    if (response.statusCode == 200) {
      return AttendListModel.fromJson(dataContent);
    } else if (response.statusCode == 401) {
      clearAllData();

      navigateAndClearStack(context, Error401Page());
    } else {
      CustomSnackBar(_scaffoldKey, json.decode(response.body).toString());
      return false;
    }
  }
  Future categoryProductsApi(GlobalKey<ScaffoldState> _scaffoldKey) async {
    XsProgressHud.show(context);

    final String completeUrl = baseUrl + products;

    final response = await http.post(
      completeUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    Map<String, dynamic> dataContent = json.decode(response.body);
    XsProgressHud.hide();
    if (response.statusCode == 200) {
      return ProductsModel.fromJson(dataContent);
    } else if (response.statusCode == 401) {
      // clearAllData();

      navigateAndClearStack(context, Error401Page());
    } else {
      CustomSnackBar(_scaffoldKey, json.decode(response.body).toString());
      return false;
    }
  }

  Future cartContent(GlobalKey<ScaffoldState> _scaffoldKey) async {
    XsProgressHud.show(context);
    final String apiUrl = baseUrl + cartLink;
    var data = {
      "user_id": "12321"
    };
    var userToJson = json.encode(data);
    final response = await http.post(
      apiUrl,
      headers: {"Content-Type": "application/json"},
      body: userToJson,
    );
    Map<String, dynamic> dataContent = json.decode(response.body);
    XsProgressHud.hide();
    if (response.statusCode == 200) {
      print( "body :"+json.decode(response.body).toString());
      return CartContentModel.fromJson(dataContent);
    } else {
      print( "body :"+json.decode(response.body).toString());
      CustomSnackBar(_scaffoldKey,
          json.decode(response.body).toString());
      return false;
    }
  }

  Future attendAndGo(GlobalKey<ScaffoldState> _scaffoldKey,String type) async {
    XsProgressHud.show(context);
    final String apiUrl = baseUrl + attend;
    var data = {
      "time":DateTime.now().toString(),
      "type":type
    };
    var userToJson = json.encode(data);
    final response = await http.post(
      apiUrl,
      headers: {"Content-Type": "application/json"},
      body: userToJson,
    );
    Map<String, dynamic> dataContent = json.decode(response.body);
    XsProgressHud.hide();
    if (response.statusCode == 200) {
      print( "body :"+json.decode(response.body).toString());
      return true;
    } else {
      print( "body :"+json.decode(response.body).toString());
      CustomSnackBar(_scaffoldKey,
          json.decode(response.body).toString());
      return false;
    }
  }

  Future addToCart(GlobalKey<ScaffoldState> _scaffoldKey,int productId) async {
    XsProgressHud.show(context);
    final String apiUrl = baseUrl + addToCartLink;
    var data = {
      "user_id": "12321",
      "product_id": productId,
      "amount": 1
    };
    var userToJson = json.encode(data);
    final response = await http.post(
      apiUrl,
      headers: {"Content-Type": "application/json"},
      body: userToJson,
    );
    Map<String, dynamic> dataContent = json.decode(response.body);
    XsProgressHud.hide();
    if (response.statusCode == 200) {
      CustomSnackBar(_scaffoldKey,
          json.decode(response.body)['success'].toString());
      print(json.decode(response.body));
      return AddToCartModel.fromJson(dataContent);
    } else {
      CustomSnackBar(_scaffoldKey,
          json.decode(response.body).toString());
      return false;
    }
  }
}
