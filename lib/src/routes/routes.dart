import 'package:flutter/cupertino.dart';
import 'package:product_store_app/src/pages/home_page.dart';
import 'package:product_store_app/src/pages/login_page.dart';
import 'package:product_store_app/src/pages/product_page.dart';
import 'package:product_store_app/src/pages/register_page.dart';
import 'package:product_store_app/src/routes/slide_from_right_animation.dart';
export 'package:product_store_app/src/pages/login_page.dart';

final navigationRoutes = {
  LoginPage.routeName: (_) => LoginPage(),
  RegisterPage.routeName: (_) => RegisterPage(),
  HomePage.routeName: (_) => HomePage(),
  ProductPage.routeName: (_) => ProductPage(),
};
