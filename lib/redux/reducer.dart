import 'package:daruma/redux/index.dart';
import 'package:daruma/redux/state.dart';

AppState mainReducer(AppState state, dynamic action) {

  FirebaseState firebaseState = _reduceFirebaseState(state, action);


  return AppState(
    firebaseState: firebaseState
  );
}

FirebaseState _reduceFirebaseState(AppState state, dynamic action){
  FirebaseState newState = state.firebaseState;
  
  if (action is UserLoadedAction) {
    newState = newState.copyWith(firebaseUser: action.firebaseUser);
  }
  return newState;
}