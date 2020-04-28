import 'dart:async';

import 'package:daruma/model/user.dart';
import 'package:daruma/redux/index.dart';
import 'package:daruma/ui/widget/index.dart';
import 'package:daruma/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:daruma/ui/pages/welcome.page.dart';
import 'package:flutter_redux/flutter_redux.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(converter: (store) {
      return new _ViewModel(
          user: store.state.userState.user,
          login: () {
            final result = LoginWithGoogleAction();

            store.dispatch(result);

            Future.wait([result.completer.future]).then((user) => {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return WelcomeScreen();
                      },
                    ),
                  )
                });
          });
    }, builder: (BuildContext context, _ViewModel vm) {
      return _loginView(context, vm);
    });
  }

  Widget _loginView(BuildContext context, _ViewModel vm) {
    return Scaffold(
      body: Container(
        color: redPrimaryColor,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage("assets/daruma-logo.jpg"),
                height: 200.0,
              ),
              SizedBox(height: 50),
              OAuthLoginButton(
                onPressed: vm.login,
                text: "Inicia Sesión con Google",
                assetName: "assets/google_logo.png",
                backgroundColor: white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ViewModel {
  final User user;
  final Function() login;

  _ViewModel({
    @required this.user,
    @required this.login,
  });
}
