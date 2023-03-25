import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

List<ProductModel> getProductList(
    AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
  return snapshot.data!.docs.map((e) => ProductModel.fromSnapshot(e)).toList();
}

class ProductModel {
  static const collection = "products";
  static const nameField = "name";
  static const qtyField = "qty";
  static const priceField = "price";
  static const imageField = "image";
  static const categoryField = "category";

  late String name;
  late num qty;
  late num price;
  late String image;
  late String category;
  DocumentReference? reference;

  ProductModel({
    this.name = "no name",
    this.qty = 0,
    this.price = 0,
    this.image = "no image",
    this.category = "no category",
    this.reference,
  });

  ProductModel.fromMap(Object? object, {this.reference}) {
    Map<String, dynamic>? map = object as Map<String, dynamic>?;
    map ??= {};
    name = map[nameField];
    qty = map[qtyField];
    price = map[priceField];
    image = map[imageField];
    category = map[categoryField] ?? "no category";
  }

  ProductModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  Map<String, dynamic> get toMap => {
        nameField: name,
        qtyField: qty,
        priceField: price,
        imageField: image,
        categoryField: category,
      };
}
