import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter2g7/firebase_module/models/category_model.dart';
import 'package:firebase2_project/models/category_model.dart';

class CategoryHelper {
  static Stream<QuerySnapshot> streamData() {
    return FirebaseFirestore.instance
        .collection(CategoryModel.collection)
        .snapshots();
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getData() {
    return FirebaseFirestore.instance
        .collection(CategoryModel.collection)
        .get();
  }

  static CategoryModel? selectCat(List<CategoryModel>? categoryList, String id){
    if (categoryList != null) {
      List<CategoryModel> list = categoryList.where((element) => element.reference!.id == id).toList();
      if(list.isNotEmpty){
        return list.first;
      }
    }
    return null;
  }

  static Future insertRecord(CategoryModel record) {
    return FirebaseFirestore.instance.runTransaction((trx) async {
      CollectionReference colRef =
          FirebaseFirestore.instance.collection(CategoryModel.collection);
      await colRef.add(record.toMap);
    }).then((x) => print("category inserted"));
  }

  static Future updateRecord(CategoryModel record) {
    return FirebaseFirestore.instance.runTransaction((trx) async {
      trx.update(record.reference!, record.toMap);
    }).then((x) => print("category updated"));
  }

  static Future deleteRecord(CategoryModel record) {
    return FirebaseFirestore.instance.runTransaction((trx) async {
      trx.delete(record.reference!);
    }).then((x) => print("category deleted"));
  }
}
