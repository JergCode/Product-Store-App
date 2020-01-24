import 'package:flutter/material.dart';
import 'package:product_store_app/src/blocs/products_bloc.dart';
import 'package:product_store_app/src/blocs/provider.dart';
import 'package:product_store_app/src/models/product_model.dart';
import 'package:product_store_app/src/pages/product_page.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home';
  ProductsBloc productsBloc;
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    productsBloc = Provider.ofProdBloc(context);
    productsBloc.loadProducts();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: _buildProductsList(),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  _buildProductsList() {
    return StreamBuilder(
      stream: productsBloc.productsStream,
      builder: (context, AsyncSnapshot<List<ProductModel>> snapshot) {
        final products = snapshot.data;
        return !snapshot.hasData
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, i) => _buildItem(context, products[i]),
              );
      },
    );
  }

  _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () => Navigator.pushNamed(context, ProductPage.routeName),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  Widget _buildTile(BuildContext context, ProductModel product) {
    return ListTile(
      title: Text('${product.titulo} - ${product.valor}'),
      subtitle: Text(product.id),
      // subtitle: product.disponible ? Text('On Stock') : Text('Out of Stock'),
      // onTap: () => Navigator.pushNamed(context, ProductPage.routeName, arguments: product),
    );
  }

  Widget _showImage(String photoUrl) {
    return photoUrl == null
        ? Image(
            image: AssetImage('assets/images/no-image.png'),
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          )
        : FadeInImage(
            image: NetworkImage(photoUrl),
            placeholder: AssetImage('assets/images/jar-loading.gif'),
            fadeInDuration: Duration(milliseconds: 300),
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          );
  }

  Widget _buildItem(BuildContext context, ProductModel product) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(color: Colors.red),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            splashColor: Colors.deepPurple,
            borderRadius: BorderRadius.circular(5.0),
            onTap: () => Navigator.pushNamed(context, ProductPage.routeName, arguments: product),
            child: Column(
              children: <Widget>[
                _showImage(product.fotoUrl),
                _buildTile(context, product),
              ],
            ),
          ),
        ),
      ),
      onDismissed: (direction) => productsBloc.deleteProduct(product.id),
    );
  }
}
