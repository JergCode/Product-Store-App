import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:product_store_app/src/blocs/products_bloc.dart';
import 'package:product_store_app/src/blocs/provider.dart';

import 'package:product_store_app/src/models/product_model.dart';
import 'package:product_store_app/src/providers/product_provider.dart';
import 'package:product_store_app/src/utils/validators_utils.dart' as utils;

class ProductPage extends StatefulWidget {
  static const routeName = '/product';

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  File pic;

  ProductsBloc productsBloc;
  var product = ProductModel();
  var _saving = false;

  @override
  Widget build(BuildContext context) {
    productsBloc = Provider.ofProdBloc(context);
    final ProductModel prodFromArgs = ModalRoute.of(context).settings.arguments;
    product = prodFromArgs ?? product;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: () => _selectPicture(ImageSource.gallery),
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () => _selectPicture(ImageSource.camera),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                _showPicture(),
                _buildProduct(),
                _buildPrice(),
                _buildOnStock(context),
                SizedBox(height: 20),
                _buildFormButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProduct() {
    return TextFormField(
      initialValue: product.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Product'),
      onSaved: (value) {
        product.titulo = value;
      },
      validator: (value) {
        if (value.length <= 3) {
          return 'Product name must have at least 3 characters';
        } else {
          return null;
        }
      },
    );
  }

  Widget _buildPrice() {
    return TextFormField(
      initialValue: product.valor.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: 'Price'),
      onSaved: (value) => product.valor = double.parse(value),
      inputFormatters: [
        WhitelistingTextInputFormatter(RegExp(r'[\d.]')),
      ],
      validator: (value) {
        if (value.isEmpty) return 'This field is required';
        if (utils.isNumeric(value)) return null;
        return 'Value must only have numbers';
      },
    );
  }

  Widget _buildOnStock(BuildContext context) {
    return SwitchListTile(
      value: product.disponible,
      title: Text('On Stock'),
      activeColor: Theme.of(context).primaryColor,
      onChanged: (value) => setState(() => product.disponible = value),
    );
  }

  Widget _buildFormButton(BuildContext context) {
    return RaisedButton.icon(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      color: Theme.of(context).primaryColor,
      textColor: Colors.white,
      onPressed: _saving ? null : _submit,
      label: _saving ? Text('Save') : Text('Save'),
      icon: _saving ? Icon(Icons.refresh) : Icon(Icons.save),
    );
  }

  void _submit() async {
    if (!formKey.currentState.validate()) return;

    // if form is valid, then
    formKey.currentState.save();

    setState(() {
      _saving = true;
    });
    if (pic != null) {
      product.fotoUrl = await productsBloc.uploadPicture(pic).catchError((e) {
        print(e);
        setState(() {
          _saving = false;
        });
      });

      if (product.fotoUrl == null) {
        print('Error trying to get image url');

        return;
      }

      print(product.fotoUrl);
    }

    if (product.id == null)
      productsBloc.addProduct(product);
    // productProvider.buildProduct(product);
    else
      productsBloc.updateProduct(product);
    // productProvider.updateProduct(product);

    await showSnackbar('Product saved');
    Navigator.pop(context);
  }

  Future<int> showSnackbar(String message) async {
    final snackbar = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 1500),
    );

    final algo = await scaffoldKey.currentState.showSnackBar(snackbar).closed;
    return algo.index;
  }

  _showPicture() {
    if (product.fotoUrl != null) {
      return FadeInImage(
        image: NetworkImage(product.fotoUrl),
        placeholder: AssetImage('assets/images/jar-loading.gif'),
        fadeInDuration: Duration(milliseconds: 300),
        height: 300,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else {
      return Image(
        image: pic != null ? FileImage(pic) : AssetImage('assets/images/no-image.png'),
        width: double.infinity,
        height: 300,
        fit: BoxFit.cover,
      );
    }
  }

  _selectPicture(ImageSource imageSource) async {
    pic = await ImagePicker.pickImage(source: imageSource);
    if (pic != null) {
      product.fotoUrl = null;
      // limpieza
    }
    print(pic.path);
    setState(() {});
  }
}
