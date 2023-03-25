import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
//import 'package:flutter2g7/firebase_module/constants/status_enum.dart';
import 'package:firebase2_project/constants/status_enum.dart';
//import 'package:flutter2g7/firebase_module/helpers/category_helper.dart';
import 'package:firebase2_project/helpers/category_helper.dart';
//import 'package:flutter2g7/firebase_module/models/category_model.dart';
import 'package:firebase2_project/models/category_model.dart';

class CategoryLogic extends ChangeNotifier{
  List<CategoryModel> _categoryList = [];
  List<CategoryModel> get categoryList => _categoryList;

  MyStatus _status = MyStatus.none;
  MyStatus get status => _status;

  void setLoading(){
    _status = MyStatus.loading;
    notifyListeners();
  }

  Future readData() async{
    try{
      QuerySnapshot<Map<String, dynamic>> data = await CategoryHelper.getData();
      _categoryList = data.docs.map((e) => CategoryModel.fromSnapshot(e)).toList();
      _status = MyStatus.done;
    } catch(e){
      print("CategoryLogic error readData() method: ${e.toString()}");
      _status = MyStatus.error;
    }
    notifyListeners();
  }

}