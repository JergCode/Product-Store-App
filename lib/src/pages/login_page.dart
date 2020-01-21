import 'package:flutter/material.dart';
import 'package:product_store_app/src/blocs/provider.dart';
import 'package:product_store_app/src/pages/home_page.dart';

class LoginPage extends StatelessWidget {
  static const routeName = '/login';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[_buildBackground(context), _loginForm(context)],
    ));
  }

  Widget _buildBackground(BuildContext ctx) {
    final size = MediaQuery.of(ctx).size;
    final purpuleBg = Container(
      width: double.infinity,
      height: size.height * 0.4,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Color.fromRGBO(63, 63, 156, 1.0),
          Color.fromRGBO(90, 70, 168, 1.0),
        ]),
      ),
    );

    final circle = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Color.fromRGBO(255, 255, 255, 0.05)),
    );

    return Stack(
      children: <Widget>[
        purpuleBg,
        Positioned(child: circle, top: -50, left: size.width * 0.5),
        Positioned(child: circle, top: size.height * 0.1, left: size.width * 0.1),
        Positioned(child: circle, top: size.height * 0.2, left: size.width * 0.7),
        Positioned(child: circle, top: size.height * 0.35, left: -50),
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: size.height * 0.08),
          child: Column(
            children: <Widget>[
              Icon(
                Icons.person_pin_circle,
                color: Colors.white,
                size: size.height * 0.15,
              ),
              SizedBox(height: 10),
              Text(
                'Emmanuel Ramírez',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _loginForm(BuildContext context) {
    final bloc = Provider.of(context);
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(
            child: Container(
              height: size.height * 0.27,
              decoration: BoxDecoration(),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            width: size.width * 0.85,
            padding: const EdgeInsets.symmetric(vertical: 50.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                BoxShadow(
                  blurRadius: 3.0,
                  color: Colors.black26,
                  offset: Offset(0.0, 5.0),
                  spreadRadius: 3.0,
                )
              ],
            ),
            child: Column(
              children: <Widget>[
                Text(
                  'Ingreso',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 30.0),
                _buildEmail(bloc),
                SizedBox(height: 15.0),
                _buildpassword(bloc),
                SizedBox(height: 30.0),
                _buildButton(bloc),
              ],
            ),
          ),
          _buildRecoverPassword(),
          SizedBox(height: size.height * 0.05)
        ],
      ),
    );
  }

  Widget _buildEmail(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (context, AsyncSnapshot<String> snapshot) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            onChanged: bloc.changeEmail,
            decoration: InputDecoration(
              icon: Icon(
                Icons.alternate_email,
                color: Colors.deepPurple,
              ),
              hintText: 'example@email.com',
              labelText: 'E-mail',
              helperText: 'Type your email address',
              errorText: snapshot.error,
            ),
          ),
        );
      },
    );
  }

  Widget _buildpassword(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (context, snapshot) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            onChanged: bloc.changePassword,
            obscureText: true,
            decoration: InputDecoration(
              icon: Icon(
                Icons.lock_open,
                color: Colors.deepPurple,
              ),
              labelText: 'Password',
              helperText: 'Type your password',
              errorText: snapshot.error,
            ),
          ),
        );
      },
    );
  }

  Widget _buildButton(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (context, snapshot) {
        return RaisedButton(
          elevation: 0.0,
          color: Colors.deepPurple,
          textColor: Colors.white,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
            child: Text('Login'),
          ),
          onPressed: snapshot.hasData ? () => _login(bloc, context) : null,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        );
      },
    );
  }

  _login(LoginBloc bloc, BuildContext context) {
    print(bloc.emailValue);
    print(bloc.passwordValue);
    Navigator.pushReplacementNamed(context, HomePage.routeName);
  }

  Widget _buildRecoverPassword() {
    return FlatButton(
      child: Text(
        'Forgot your email?',
        style: TextStyle(color: Colors.deepPurple),
      ),
      onPressed: () {},
    );
  }
}
