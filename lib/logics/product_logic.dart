import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
//import 'package:flutter2g7/firebase_module/constants/status_enum.dart';
import 'package:firebase2_project/constants/status_enum.dart';
//import 'package:flutter2g7/firebase_module/helpers/product_helper.dart';
import 'package:firebase2_project/helpers/product_helper.dart';
//import 'package:flutter2g7/firebase_module/models/product_model.dart';
import 'package:firebase2_project/models/product_model.dart';

class ProductLogic extends ChangeNotifier{
  List<ProductModel> _productList = [];
  List<ProductModel> get productList => _productList;

  List<ProductModel> filterProductListByCategory(String? catId){
    if(catId == null){
      return _productList;
    }
    else{
      return _productList.where((element) => element.category == catId).toList();
    }
  }

  MyStatus _status = MyStatus.none;
  MyStatus get status => _status;

  void setLoading(){
    _status = MyStatus.loading;
    notifyListeners();
  }

  Future readData() async{
    try{
      QuerySnapshot<Map<String, dynamic>> data = await ProductHelper.getData();
      _productList = data.docs.map((e) => ProductModel.fromSnapshot(e)).toList();
      _status = MyStatus.done;
    } catch(e){
      print("ProductLogic error readData() method: ${e.toString()}");
      _status = MyStatus.error;
    }
    notifyListeners();
  }
}