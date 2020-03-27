import 'dart:async';

import 'package:daruma/redux/index.dart';
import 'package:daruma/ui/widget/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:daruma/ui/pages/first.dart';
import 'package:flutter_redux/flutter_redux.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(converter: (store) {
      return new _ViewModel(
          user: store.state.firebaseState.firebaseUser,
          login: () {
            final result = LoginWithGoogleAction();

            store.dispatch(result);

            Future.wait([result.completer.future]).then((user) => {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return FirstScreen();
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
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlutterLogo(size: 150),
              SizedBox(height: 50),
              OAuthLoginButton(
                onPressed: vm.login,
                text: "Inicia Sesión con Google",
                assetName: "assets/google_logo.png",
                backgroundColor: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ViewModel {
  final FirebaseUser user;
  final Function() login;

  _ViewModel({
    @required this.user,
    @required this.login,
  });
}
