import 'package:daruma/redux/index.dart';
import 'package:daruma/redux/state.dart';

AppState mainReducer(AppState state, dynamic action) {
  FirebaseState firebaseState = _reduceFirebaseState(state, action);
  bool userIsNew = _reduceUserIsNew(state, action);

  return AppState(firebaseState: firebaseState, userIsNew: userIsNew);
}

FirebaseState _reduceFirebaseState(AppState state, dynamic action) {
  FirebaseState newState = state.firebaseState;

  if (action is UserLoadedAction) {

    newState = newState.copyWith(
        firebaseUser: action.firebaseUser, idTokenUser: action.idTokenUser);
  }
  return newState;
}

bool _reduceUserIsNew(AppState state, dynamic action) {
  bool userIsNew = state.userIsNew;

  if (action is UserIsNew) {

    userIsNew = action.userIsNew;
  }

  return userIsNew;
}