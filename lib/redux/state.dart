import 'package:daruma/model/bill.dart';
import 'package:daruma/model/group.dart';
import 'package:daruma/model/user.dart';
import 'package:flutter/material.dart';

class AppState {
  final UserState userState;
  final GroupState groupState;
  final BillState billState;
  final bool userIsNew;

  const AppState({
    @required this.userState,
    @required this.groupState,
    @required this.billState,
    @required this.userIsNew,
  });

  AppState copyWith(
      {UserState userState, GroupState groupState, BillState billState}) {
    return new AppState(
        userState: userState ?? this.userState,
        groupState: groupState ?? this.groupState,
        billState: billState ?? this.billState,
        userIsNew: userIsNew ?? this.userIsNew);
  }

  factory AppState.initial() {
    return AppState(
        userState: UserState.initial(),
        groupState: GroupState.initial(),
        billState: BillState.initial(),
        userIsNew: false);
  }
}

@immutable
class UserState {
  final User user;
  final String photoUrl;
  final String tokenUserId;

  const UserState(
      {@required this.user,
      @required this.photoUrl,
      @required this.tokenUserId});

  factory UserState.initial() {
    return new UserState(user: null, photoUrl: null, tokenUserId: null);
  }

  UserState copyWith({User user, String photoUrl, String tokenUserId}) {
    return new UserState(
        user: user ?? this.user,
        photoUrl: photoUrl ?? this.photoUrl,
        tokenUserId: tokenUserId ?? this.tokenUserId);
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
    return new BillState(bill: Bill.initial());
  }

  BillState copyWith({Bill bill}) {
    return new BillState(bill: bill ?? this.bill);
  }
}
