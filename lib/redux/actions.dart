import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

class LoginWithGoogleAction {
  final Completer completer;

  LoginWithGoogleAction({Completer completer})
      : this.completer = completer ?? Completer();
}

class LogoutAction {
  LogoutAction();
}

class UserLoadedAction {
  final FirebaseUser firebaseUser;
  final IdTokenResult idTokenUser;

  UserLoadedAction(this.firebaseUser, this.idTokenUser);
}
