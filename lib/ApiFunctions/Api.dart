import 'dart:convert';
import 'dart:io';
import 'package:ecommerce_sample/ApiFunctions/sharedPrefClass.dart';
import 'package:ecommerce_sample/model/categories_model.dart';
import 'package:ecommerce_sample/model/category_products_model.dart';
import 'package:ecommerce_sample/ui/error401_page.dart';
import 'package:ecommerce_sample/ui/home_screen.dart';
import 'package:ecommerce_sample/utils/custom_widgets/cusstom_snackBar.dart';
import 'package:ecommerce_sample/utils/navigator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:xs_progress_hud/xs_progress_hud.dart';

class Api {
  String baseUrl = 'https://cafeshs.herokuapp.com/api/';
  final String categories = "categories";
  final String products = "products";

  BuildContext context;

  Api(@required this.context);


  Future categoriesApi(GlobalKey<ScaffoldState>_scaffoldKey) async {
    XsProgressHud.show(context);

    final String completeUrl =  baseUrl + categories;

    final response =  await http.post(
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
    }  else if(response.statusCode == 401){
      clearAllData();

      navigateAndClearStack(context, Error401Page());
    }else {
      CustomSnackBar(
          _scaffoldKey, json.decode(response.body).toString());
      return false;
    }

  }

  Future categoryProductsApi(GlobalKey<ScaffoldState>_scaffoldKey) async {
    XsProgressHud.show(context);

    final String completeUrl =  baseUrl + products;

    final response =  await http.post(
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
    }  else if(response.statusCode == 401){
      // clearAllData();

      navigateAndClearStack(context, Error401Page());
    }else {
      CustomSnackBar(
          _scaffoldKey, json.decode(response.body).toString());
      return false;
    }

  }

}
