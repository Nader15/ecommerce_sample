import 'package:flutter/material.dart';

class SubCategory {
  final String image, title,description;
  final int price, id;
  final Color color;

  SubCategory({this.description, this.color, this.image, this.title, this.price, this.id});
}

List<SubCategory> furnitureSubCategories = [
  SubCategory(
    id: 1,
    title: "Desk",
    image: "assets/images/borcherding.jpg",
    price: 110,
    color: Colors.orange,
    description: "A desk or bureau is a piece of furniture with a flat table-style work surface used in a school, office, home or the like for academic, professional or domestic activities such as reading, writing, or using equipment such as a computer"
  ),
  SubCategory(
    id: 2,
    title: "Chair",
    image: "assets/images/chair.jpg",
    price: 120,
    color: Colors.grey,
    description: "a chair is a type of seat. Its primary features are two pieces of a durable material, attached as back and seat to one another at a 90° or slightly greater angle, with usually the four corners of the horizontal seat attached in turn to four legs—or other parts of the seat's underside attached to three legs or to a shaft about which a four-arm turnstile on rollers can turn"
  ),
  SubCategory(
    id: 3,
    title: "Cupboard",
    image: "assets/images/cupboard.jpg",
    price: 80,
    color: Colors.orange.shade800,
    description: "The term cupboard was originally used to describe an open-shelved side table for displaying dishware, more specifically plates, cups and saucers. These open cupboards typically had between one and three display tiers, and at the time, a drawer or multiple drawers fitted to them. The word cupboard gradually came to mean a closed piece of furniture"
  ),
  SubCategory(
    id: 4,
    title: "DiningTable",
    image: "assets/images/diningTable.jpg",
    price: 90,
    color: Colors.black.withOpacity(.9),
    description: "A table is an item of furniture with a flat top and one or more legs, used as a surface for working at, eating from or on which to place things.[1][2] Some common types of table are the dining room table, which is used for seated persons to eat meals; the coffee table, which is a low table used in living rooms to display items or serve refreshments"
  ),
];
List<SubCategory> shoesSubCategories = [
  SubCategory(
    id: 1,
    title: "boatRed",
    image: "assets/images/boatRed.jpg",
    price: 110,
    color: Colors.redAccent,
  ),
  SubCategory(
    id: 3,
    title: "nikePink",
    image: "assets/images/nikePink.jpg",
    price: 80,
    color: Colors.black54,
  ),
  SubCategory(
    id: 2,
    title: "nikeRed",
    image: "assets/images/nikeRed.jpg",
    price: 120,
    color: Colors.red.shade900,
  ),
  SubCategory(
    id: 4,
    title: "nikeblue",
    image: "assets/images/nikeblue.jpg",
    price: 90,
    color: Colors.blue.withOpacity(.9),
  ),
];
