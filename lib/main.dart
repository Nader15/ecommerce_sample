import 'package:ecommerce_sample/TestPrinterArabic.dart';
import 'package:ecommerce_sample/ui/categories/categories.dart';
import 'package:ecommerce_sample/ui/home_screen.dart';
import 'package:ecommerce_sample/utils/colors_file.dart';
import 'package:flutter/material.dart';

void main()=>runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  title: "E-Commerce_sample",
  // home: TestArabicPrinter(),
  // home: TestArabicPrinter(),
  home: Categories(),
));
