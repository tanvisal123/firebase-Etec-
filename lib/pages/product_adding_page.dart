import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter2g7/firebase_module/helpers/product_helper.dart';
import 'package:firebase2_project/helpers/product_helper.dart';
//import 'package:flutter2g7/firebase_module/models/product_model.dart';
import 'package:firebase2_project/models/product_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const String _blankImage =
    "https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1665px-No-Image-Placeholder.svg.png";

class ProductAddingPage extends StatefulWidget {
  const ProductAddingPage({Key? key}) : super(key: key);

  @override
  State<ProductAddingPage> createState() => _ProductAddingPageState();
}

class _ProductAddingPageState extends State<ProductAddingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text("Product Adding Page"),
      actions: [
        _buildSaveButton(),
      ],
    );
  }

  Widget _buildBody() {
    return Container(
      alignment: Alignment.center,
      child: _buildTextFieldListView(),
    );
  }

  var _formKey = GlobalKey<FormState>();

  Widget _buildTextFieldListView() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.all(20),
        children: [
          _buildNameTextField(),
          SizedBox(height: 20),
          _buildPriceTextField(),
          SizedBox(height: 20),
          _buildQtyTextField(),
          SizedBox(height: 20),
          _buildImageTextField(),
          SizedBox(height: 50),
          _buildImageFrame(),
        ],
      ),
    );
  }

  var _nameCtrl = TextEditingController();

  Widget _buildNameTextField() {
    return TextFormField(
      controller: _nameCtrl,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        icon: Icon(Icons.title),
        hintText: "Enter name",
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    );
  }

  var _priceCtrl = TextEditingController();

  Widget _buildPriceTextField() {
    return TextFormField(
      controller: _priceCtrl,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        icon: Icon(FontAwesomeIcons.dollarSign),
        hintText: "Enter price",
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    );
  }

  var _qtyCtrl = TextEditingController();

  Widget _buildQtyTextField() {
    return TextFormField(
      controller: _qtyCtrl,
      keyboardType: TextInputType.numberWithOptions(),
      decoration: InputDecoration(
        icon: Icon(Icons.wallet_giftcard),
        hintText: "Enter qty",
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    );
  }

  var _imageCtrl = TextEditingController();

  Widget _buildImageTextField() {
    return TextFormField(
      textCapitalization: TextCapitalization.words,
      controller: _imageCtrl,
      decoration: InputDecoration(
        icon: Icon(Icons.image),
        hintText: "Enter image url",
        suffixIcon: IconButton(
          onPressed: () {
            if (_imageCtrl.text.isNotEmpty) {
              setState(() {
                _imageUrl = _imageCtrl.text.trim();
              });
            }
          },
          icon: Icon(CupertinoIcons.camera_viewfinder),
        ),
      ),
      maxLines: 3,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    );
  }

  String _imageUrl = _blankImage;

  Widget _buildImageFrame() {
    return SizedBox(
      height: 300,
      // child: Image.network(_imageUrl),
      child: CachedNetworkImage(
        imageUrl: _imageUrl,
        placeholder: (context, url) => Container(
          color: Colors.grey[800],
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey,
          child: Icon(
            Icons.error,
            size: 70,
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          ProductModel productModel = ProductModel(
            name: _nameCtrl.text.trim(),
            price: num.parse(_priceCtrl.text.trim()),
            qty: num.parse(_qtyCtrl.text.trim()),
            image: _imageCtrl.text.trim(),
          );
          await ProductHelper.insertRecord(productModel);
          Navigator.of(context).pop();
        }
      },
      child: Text("SAVE"),
    );
  }
}
