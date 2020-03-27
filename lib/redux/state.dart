import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppState {
  final FirebaseState firebaseState;

  const AppState({
    this.firebaseState = const FirebaseState(),
  });

  AppState copyWith({FirebaseState firebaseState}) {
    return new AppState(firebaseState: firebaseState ?? this.firebaseState);
  }

  factory AppState.initial() => AppState();
}

@immutable
class FirebaseState {
  final FirebaseUser firebaseUser;
  final IdTokenResult idTokenUser;

  const FirebaseState({this.firebaseUser, this.idTokenUser});

  FirebaseState copyWith(
      {FirebaseUser firebaseUser, IdTokenResult idTokenUser}) {
    return new FirebaseState(
        firebaseUser: firebaseUser ?? this.firebaseUser,
        idTokenUser: idTokenUser ?? this.idTokenUser);
  }
}
