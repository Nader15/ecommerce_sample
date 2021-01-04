import 'package:ecommerce_sample/utils/colors_file.dart';
import 'package:flutter/material.dart';

void CustomSnackBar(GlobalKey<ScaffoldState> scaffoldKey,String content){
  scaffoldKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        duration: Duration(seconds: 1),
        elevation: 6.0,
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: [
            Icon(Icons.insert_emoticon,
                color: blackColor),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child:  Text(
                "${content.toString()}",
                style: TextStyle(
                    color: blackColor),
              ) ,
            ),
          ],
        ),
      )
  );
}