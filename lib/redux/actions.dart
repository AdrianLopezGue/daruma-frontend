import 'dart:async';

import 'package:daruma/model/group.dart';
import 'package:daruma/model/participant.dart';
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

class StartCreatingBill{
  final String idGroup;
  final String idCreator;
  final String idFirstPayer;
  final String currencyCode;

  StartCreatingBill(this.idGroup, this.idCreator, this.idFirstPayer, this.currencyCode);
}

class BillNameChangedAction {
  final String newName;

  BillNameChangedAction(this.newName);
}

class BillDateChangedAction {
  final DateTime newDate;

  BillDateChangedAction(this.newDate);
}

class BillMoneyChangedAction {
  final int newMoney;

  BillMoneyChangedAction(this.newMoney);
}

class BillPayersChangedAction {
  final List<Participant> newPayers;

  BillPayersChangedAction(this.newPayers);
}

class BillDebtorsChangedAction {
  final List<Participant> newDebtors;

  BillDebtorsChangedAction(this.newDebtors);
}