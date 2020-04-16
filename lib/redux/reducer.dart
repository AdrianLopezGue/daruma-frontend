import 'package:daruma/redux/index.dart';
import 'package:daruma/redux/state.dart';

AppState mainReducer(AppState state, dynamic action) {
  FirebaseState firebaseState = _reduceFirebaseState(state, action);
  GroupState groupState = _reduceGroupState(state, action);
  bool userIsNew = _reduceUserIsNew(state, action);

  return AppState(firebaseState: firebaseState, groupState: groupState, userIsNew: userIsNew);
}

FirebaseState _reduceFirebaseState(AppState state, dynamic action) {
  FirebaseState newState = state.firebaseState;

  if (action is UserLoadedAction) {
    newState = newState.copyWith(
        firebaseUser: action.firebaseUser, idTokenUser: action.idTokenUser);
  }
  return newState;
}

GroupState _reduceGroupState(AppState state, dynamic action) {
  GroupState newState = state.groupState;

  if (action is StartLoadingGroupAction) {
    newState.copyWith(isLoading: true, loadingError: false);
  } else if(action is LoadingGroupSuccessAction){
    newState.copyWith(group: action.group, isLoading: false, loadingError: false);
  } else if(action is LoadingGroupFailedAction){
    newState.copyWith(group: null, isLoading: false, loadingError: true);
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
