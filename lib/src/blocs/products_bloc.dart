import 'dart:io';

import 'package:rxdart/rxdart.dart';

import 'package:product_store_app/src/providers/product_provider.dart';
import 'package:product_store_app/src/models/product_model.dart';

class ProductsBloc {
  final _productosController = new BehaviorSubject<List<ProductModel>>();
  final _loadingController = new BehaviorSubject<bool>();

  final _productsProvider = new ProductsProvider();

  Stream<List<ProductModel>> get productsStream => _productosController.stream;
  Stream<bool> get loading => _loadingController.stream;

  void loadProducts() async {
    final products = await _productsProvider.getProducts();
    _productosController.sink.add(products);
  }

  void addProduct(ProductModel product) async {
    _loadingController.sink.add(true);
    await _productsProvider.buildProduct(product);
    _loadingController.sink.add(false);
  }

  void updateProduct(ProductModel product) async {
    _loadingController.sink.add(true);
    await _productsProvider.updateProduct(product);
    _loadingController.sink.add(false);
  }

  Future<String> uploadPicture(File picture) async {
    _loadingController.sink.add(true);
    final photoUrl = await _productsProvider.uploadPicture(picture);
    _loadingController.sink.add(false);

    return photoUrl;
  }

  void deleteProduct(String id) async {
    await _productsProvider.deleteProduct(id);
  }

  dispose() {
    _productosController?.close();
    _loadingController?.close();
  }
}
