import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

List<CategoryModel> getCategoryList(
    AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
  return snapshot.data!.docs.map((e) => CategoryModel.fromSnapshot(e)).toList();
}

class CategoryModel {
  static const collection = "categories";
  static const nameField = "name";
  static const orderField = "order";

  late String name;
  late num order;
  DocumentReference? reference;

  CategoryModel({
    this.name = "no name",
    this.order = 0,
    this.reference,
  });

  CategoryModel.fromMap(Object? object, {this.reference}) {
    Map<String, dynamic>? map = object as Map<String, dynamic>?;
    map ??= {};
    name = map[nameField];
    order = map[orderField];
  }

  CategoryModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  Map<String, dynamic> get toMap => {
    nameField: name,
    orderField: order,
  };

  @override
  String toString() {
    return toMap.toString();
  }
}