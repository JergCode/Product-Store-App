import 'package:flutter/cupertino.dart';
import 'package:product_store_app/src/blocs/login_bloc.dart';
export 'package:product_store_app/src/blocs/login_bloc.dart';

class Provider extends InheritedWidget {
  final loginBloc = LoginBloc();

  static Provider _singleton;

  factory Provider({Key key, Widget child}) =>
      _singleton == null ? _singleton = Provider._internal(key: key, child: child) : _singleton;
  // Provider({Key key, @required Widget child}) : super(key: key, child: child);

  Provider._internal({Key key, @required Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>().loginBloc;
  }
}
