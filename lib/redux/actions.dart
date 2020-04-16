import 'dart:async';

import 'package:daruma/model/group.dart';
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
  final String idTokenUser;

  UserLoadedAction(this.firebaseUser, this.idTokenUser);
}

class UserIsNew {
  final bool userIsNew;

  UserIsNew(this.userIsNew);
}

class StartLoadingGroupAction {
  StartLoadingGroupAction();
}

class LoadingGroupSuccessAction {
  final Group group;

  LoadingGroupSuccessAction(this.group);
}

class LoadingGroupFailedAction {
  LoadingGroupFailedAction();
}
