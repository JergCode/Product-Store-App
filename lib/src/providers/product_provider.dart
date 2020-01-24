import 'dart:convert';
import 'dart:io';
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

import 'package:product_store_app/src/models/product_model.dart';
import 'package:product_store_app/src/preferences/user_preferences.dart';

class ProductsProvider {
  static const _URL = 'https://flutter-productsapp-f4787.firebaseio.com';
  final _prefs = UserPreferences();

  Future<bool> buildProduct(ProductModel product) async {
    final url = '$_URL/products.json?auth=${_prefs.token}';

    final resp = await http.post(url, body: productoModelToJson(product));

    final decodedData = json.decode(resp.body);

    print(decodedData);
    return true;
  }

  Future<bool> updateProduct(ProductModel product) async {
    final url = '$_URL/products/${product.id}.json?auth=${_prefs.token}';

    final resp = await http.put(url, body: productoModelToJson(product));

    final decodedData = json.decode(resp.body);

    print(decodedData);
    return true;
  }

  Future<List<ProductModel>> getProducts() async {
    final url = '$_URL/products.json?auth=${_prefs.token}';
    final resp = await http.get(url);

    final Map<String, dynamic> decodedData = json.decode(resp.body);

    if (decodedData == null || decodedData['error'] != null) return [];

    // if (decodedData['error'] != null) return [];
    final products = List<ProductModel>();
    decodedData.forEach((dbId, dbProd) {
      var pTemp = ProductModel.fromJson(dbProd);
      pTemp.id = dbId;
      products.add(pTemp);
    });

    return products;
  }

  Future<int> deleteProduct(String id) async {
    final url = '$_URL/products/$id.json?auth=${_prefs.token}';
    final resp = await http.delete(url);
    print(resp.contentLength);

    final decodedData = json.decode(resp.body);

    print(decodedData);

    return 1;
  }

  Future<String> uploadPicture(File pic) async {
    String fileName = p.basename(pic.path);
    String ext = p.extension(pic.path);
    print('ext = $ext');
    if (ext == '') {
      fileName += '.jpg';
    }
    print(fileName);
    String mimeType = mime(fileName);
    print(mimeType);

    final url = Uri.https('api.cloudinary.com', '/v1_1/jergsistemas/image/upload', {'upload_preset': 'kt5tkxxj'});

    final imageUploadRequest = http.MultipartRequest('POST', url);
    final file = await http.MultipartFile.fromPath(
      'file',
      pic.path,
      contentType: MediaType(mimeType[0], mimeType[1]),
    );

    imageUploadRequest.files.add(file);

    final streamResp = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResp);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('something went wrong');
      print(resp.body);
      return null;
    }

    final decodedData = json.decode(resp.body);

    print(decodedData);

    return decodedData['secure_url'];
  }
}
