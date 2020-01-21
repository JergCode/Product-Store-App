import 'dart:async';

import 'dart:math';

class Validators {
  final passwordValidation = StreamTransformer<String, String>.fromHandlers(handleData: (password, sink) {
    if (password.length >= 6)
      sink.add(password);
    else
      sink.addError('Password must have at least 6 chars');
  });

  final emailValidation = StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);
    if (regExp.hasMatch(email))
      sink.add(email);
    else
      sink.addError('Not a valid E-mail');
  });
}
