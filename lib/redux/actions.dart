import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

class LoginWithGoogleAction {
  final Completer completer;

  LoginWithGoogleAction({Completer completer}): this.completer = completer ?? new Completer();
}

class LogoutAction {
  LogoutAction();
}

class UserLoadedAction {
  final FirebaseUser firebaseUser;

  UserLoadedAction(this.firebaseUser);
}