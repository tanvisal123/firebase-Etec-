import 'package:flutter/material.dart';
//import 'package:flutter2g7/firebase_module/constants/status_enum.dart';
import 'package:firebase2_project/constants/status_enum.dart';
//import 'package:flutter2g7/firebase_module/helpers/category_helper.dart';
import 'package:firebase2_project/helpers/category_helper.dart';
//import 'package:flutter2g7/firebase_module/helpers/email_auth_helper.dart';
import 'package:firebase2_project/helpers/email_auth_helper.dart';
//import 'package:flutter2g7/firebase_module/logics/category_logic.dart';
import 'package:firebase2_project/logics/category_logic.dart';
//import 'package:flutter2g7/firebase_module/logics/product_logic.dart';
import 'package:firebase2_project/logics/product_logic.dart';
//import 'package:flutter2g7/firebase_module/models/category_model.dart';
import 'package:firebase2_project/models/category_model.dart';
//import 'package:flutter2g7/firebase_module/pages/product_adding_page.dart';
import 'package:firebase2_project/pages/product_adding_page.dart';
//import 'package:flutter2g7/firebase_module/pages/product_edit_page.dart';
import 'package:firebase2_project/pages/product_edit_page.dart';
//import 'package:flutter2g7/firebase_module/pages/signin_page.dart';
import 'package:firebase2_project/pages/signin_page.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<CategoryModel>? _categoryList;

  @override
  Widget build(BuildContext context) {
    MyStatus status = context.watch<CategoryLogic>().status;
    if (status == MyStatus.done) {
      _categoryList = context.watch<CategoryLogic>().categoryList;
    }

    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      drawer: _buildDrawer(),
    );
  }

  Widget _buildDrawer(){
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(child: Icon(Icons.wallet_giftcard, size: 100,),),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Sign out"),
            onTap: () async{
              await EmailAuthHelper.signOut();
              if(mounted){
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => SignInPage(),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text("Product Page"),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProductAddingPage(),
              ),
            );
          },
          icon: Icon(Icons.add),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Container(
      alignment: Alignment.center,
      child: _buildLoading(),
    );
  }

  Widget _buildLoading() {
    MyStatus status = context.watch<ProductLogic>().status;
    switch (status) {
      case MyStatus.none:
      case MyStatus.loading:
        return Center(child: CircularProgressIndicator());
      case MyStatus.error:
        return _buildError();
      case MyStatus.done:
        return _buildDisplay();
    }
  }

  Widget _buildError() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error),
        SizedBox(
          height: 20,
        ),
        Text("No Internet Connection or Server Down"),
        SizedBox(
          height: 20,
        ),
        ElevatedButton.icon(
          onPressed: () {
            context.read<ProductLogic>().setLoading();
            context.read<ProductLogic>().readData();
          },
          icon: Icon(Icons.refresh),
          label: Text("RETRY"),
        ),
      ],
    );
  }

  Widget _buildDisplay() {
    return Column(
      children: [
        _buildCategoryListView(),
        Expanded(child: _buildProductListView()),
      ],
    );
  }

  final _allCategories = "All Products";

  String? _catId;

  int _selectedCategoryIndex = -1;

  Widget _buildCategoryListView() {
    if (_categoryList == null) return SizedBox();

    return Container(
      height: 80,
      alignment: Alignment.centerLeft,
      color: Colors.blueAccent.withOpacity(0.2),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemCount: _categoryList!.length + 2,
        itemBuilder: (context, index) {
          --index;

          if (index == -1) {
            return _buildAllCatItem(selected: _selectedCategoryIndex == index);
          } else if (index < _categoryList!.length) {
            return _buildCatItem(
              _categoryList![index],
              selected: _selectedCategoryIndex == index,
              index: index,
            );
          } else {
            return _buildOtherCatItem(
              selected: _selectedCategoryIndex == index,
              index: index,
            );
          }
        },
      ),
    );
  }

  Widget _buildCatItem(CategoryModel item,
      {bool selected = false, required int index}) {
    Color color = selected ? Colors.yellow : Colors.white;

    return InkWell(
      onTap: () {
        setState(() {
          _catId = item.reference!.id;
          _selectedCategoryIndex = index;
        });
        print("_selectedCategoryIndex: $_selectedCategoryIndex");
      },
      child: Container(
        alignment: Alignment.center,
        color: color,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        child: Text(item.name),
      ),
    );
  }

  Widget _buildAllCatItem({bool selected = false}) {
    Color color = selected ? Colors.yellow : Colors.white;

    return InkWell(
      onTap: () {
        setState(() {
          _catId = null;
          _selectedCategoryIndex = -1;
        });
        print("_selectedCategoryIndex: $_selectedCategoryIndex");
      },
      child: Container(
        alignment: Alignment.center,
        color: color,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        child: Text(_allCategories),
      ),
    );
  }

  Widget _buildOtherCatItem({bool selected = false, required int index}) {
    Color color = selected ? Colors.yellow : Colors.white;

    return InkWell(
      onTap: () {
        setState(() {
          //_catId = ProductModel.noCategory;
          _selectedCategoryIndex = index;
        });
        print("_selectedCategoryIndex: $_selectedCategoryIndex");
      },
      child: Container(
        alignment: Alignment.center,
        color: color,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        //child: Text(ProductModel.noCategory),
      ),
    );
  }

  Widget _buildProductListView() {
    List<ProductModel> items =
        context.watch<ProductLogic>().filterProductListByCategory(_catId);

    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _buildProductItem(items[index]);
      },
    );
  }

  Widget _buildProductItem(ProductModel item) {
    CategoryModel? category =
        CategoryHelper.selectCat(_categoryList, item.category);

    return Container(
      margin: EdgeInsets.all(10),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.center,
            child: Image.network(
              item.image,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 10,),
          Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              title: Text(item.name),
              subtitle: Text("USD ${item.price} \n${item.qty} In Stock"),
              trailing: IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProductEditPage(item),
                    ),
                  );
                },
                icon: Icon(Icons.edit),
              ),
            ),
          ),
          SizedBox(height: 10),
      //     Container(
      //       color: Colors.blueAccent.withOpacity(0.8),
      //       padding: EdgeInsets.all(10),
      //   //    child: Text(
      //       //  category == null ? ProductModel.noCategory : "${category.name}",
      //         //style: TextStyle(color: Colors.white),
      //       //),
      //     //),
      // //    SizedBox(height: 20),
      //   //],
      // ),
    ]),
    );

  }
}
