import 'dart:async';

import 'package:product_store_app/src/blocs/validators.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  // Recover stream data
  Stream<String> get emailStream => _emailController.stream.transform(emailValidation);
  Stream<String> get passwordStream => _passwordController.stream.transform(passwordValidation);

  Stream<bool> get formValidStream => CombineLatestStream.combine2(emailStream, passwordStream, (e, p) => true);

  // GETTERS & SETTERS
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  String get emailValue {
    return _emailController.value;
  }

  String get passwordValue {
    return _passwordController.value;
  }

  dispose() {
    _emailController?.close();
    _passwordController?.close();
  }
}
