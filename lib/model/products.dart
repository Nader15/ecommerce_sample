import 'package:flutter/material.dart';

class Product {
  final String image, title;

  final int price, id, size;
  final Color color;

  Product({this.image, this.title, this.price, this.id, this.size, this.color});
}


List<Product> products = [
  Product(
    id: 1,
    title: "Furnitures",
    size: 12,
    image: "assets/images/furnitures.jpg",
    color: Colors.orange,
    price: 100
  ),
  Product(
      id: 2,
      title: "Shoes",
      size: 12,
      image: "assets/images/shoes.jpg",
      color: Colors.redAccent,
      price: 200
  ),
  Product(
      id: 3,
      title: "Drinks",
      size: 12,
      image: "assets/images/drinks.jpg",
      color: Colors.brown,
      price: 110
  ),
  Product(
      id: 4,
      title: "Clothes",
      size: 12,
      image: "assets/images/clothes.jpg",
      color: Colors.grey,
      price: 400
  ),
  Product(
      id: 5,
      title: "Smart Phones",
      size: 12,
      image: "assets/images/smartphones.jpg",
      color: Colors.pink,
      price: 130,
  ),
  Product(
      id: 6,
      title: "Laptops",
      size: 12,
      image: "assets/images/labtops.jpg",
      color: Colors.purple,
      price: 150
  ),
  Product(
      id: 7,
      title: "Sun Glasses",
      size: 12,
      image: "assets/images/sunglasses.jpg",
      color: Colors.white70,
      price: 100
  ),
  Product(
      id: 8,
      title: "Head Phones",
      size: 12,
      image: "assets/images/headphones.jpg",
      color: Colors.amber
  )
];

