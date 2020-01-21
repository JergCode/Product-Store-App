import 'package:product_store_app/src/pages/home_page.dart';
import 'package:product_store_app/src/pages/login_page.dart';
export 'package:product_store_app/src/pages/login_page.dart';

final navigationRoutes = {
  LoginPage.routeName: (_) => LoginPage(),
  HomePage.routeName: (_) => HomePage(),
};
