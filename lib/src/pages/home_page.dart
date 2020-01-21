import 'package:flutter/material.dart';
import 'package:product_store_app/src/blocs/provider.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home';
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('User: ${bloc.emailValue}'),
          SizedBox(
            width: double.infinity,
            height: 20,
          ),
          Text('Password: ${bloc.passwordValue}'),
        ],
      ),
    );
  }
}
