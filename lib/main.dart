import 'package:flutter/material.dart';
import 'package:product_store_app/src/blocs/provider.dart';
import 'package:product_store_app/src/routes/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: LoginPage.routeName,
        routes: navigationRoutes,
        theme: ThemeData(primaryColor: Colors.deepPurple),
      ),
    );
  }
}
