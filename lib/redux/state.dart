import 'package:daruma/model/bill.dart';
import 'package:daruma/model/group.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppState {
  final FirebaseState firebaseState;
  final GroupState groupState;
  final BillState billState;
  final bool userIsNew;

  const AppState({
    @required this.firebaseState,
    @required this.groupState,
    @required this.billState,
    @required this.userIsNew,
  });

  AppState copyWith({FirebaseState firebaseState, GroupState groupState, BillState billState}) {
    return new AppState(
        firebaseState: firebaseState ?? this.firebaseState,
        groupState: groupState ?? this.groupState,
        billState: billState ?? this.billState,
        userIsNew: userIsNew ?? this.userIsNew);
  }

  factory AppState.initial() {
    return AppState(
        firebaseState: FirebaseState.initial(),
        groupState: GroupState.initial(),
        billState: BillState.initial(),
        userIsNew: false);
  }
}

@immutable
class FirebaseState {
  final FirebaseUser firebaseUser;
  final String idTokenUser;

  const FirebaseState(
      {@required this.firebaseUser, @required this.idTokenUser});

  factory FirebaseState.initial() {
    return new FirebaseState(firebaseUser: null, idTokenUser: null);
  }

  FirebaseState copyWith({FirebaseUser firebaseUser, String idTokenUser}) {
    return new FirebaseState(
        firebaseUser: firebaseUser ?? this.firebaseUser,
        idTokenUser: idTokenUser ?? this.idTokenUser);
  }
}

@immutable
class GroupState {
  final Group group;
  final bool isLoading;
  final bool loadingError;

  GroupState({
    @required this.group,
    @required this.isLoading,
    @required this.loadingError,
  });

  factory GroupState.initial() {
    return new GroupState(group: null, isLoading: false, loadingError: false);
  }

  GroupState copyWith({bool isLoading, bool loadingError, Group group}) {
    return new GroupState(
      group: group ?? this.group,
      isLoading: isLoading ?? this.isLoading,
      loadingError: loadingError ?? this.loadingError,
    );
  }
}

@immutable
class BillState {
  final Bill bill;

  BillState({
    @required this.bill,
  });

  factory BillState.initial() {
    return new BillState(
      bill: Bill.initial()
    );
  }

  BillState copyWith(
      {Bill bill}) {
    return new BillState(
      bill: bill ?? this.bill
    );
  }
}
