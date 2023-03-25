import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter2g7/firebase_module/models/product_model.dart';
import 'package:firebase2_project/models/product_model.dart';

class ProductHelper {
  static Stream<QuerySnapshot> streamData() {
    return FirebaseFirestore.instance
        .collection(ProductModel.collection)
        .snapshots();
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getData() {
    return FirebaseFirestore.instance
        .collection(ProductModel.collection)
        .get();
  }

  static Future insertRecord(ProductModel record) {
    return FirebaseFirestore.instance.runTransaction((trx) async {
      CollectionReference colRef =
          FirebaseFirestore.instance.collection(ProductModel.collection);
      await colRef.add(record.toMap);
    }).then((x) => print("product inserted"));
  }

  static Future updateRecord(ProductModel record) {
    return FirebaseFirestore.instance.runTransaction((trx) async {
      trx.update(record.reference!, record.toMap);
    }).then((x) => print("product updated"));
  }

  static Future deleteRecord(ProductModel record) {
    return FirebaseFirestore.instance.runTransaction((trx) async {
      trx.delete(record.reference!);
    }).then((x) => print("product deleted"));
  }
}
