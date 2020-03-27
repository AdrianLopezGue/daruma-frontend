import 'package:daruma/redux/index.dart';
import 'package:daruma/redux/state.dart';
import 'package:redux/redux.dart';

Store<AppState> createStore() {
  return Store(
    mainReducer,
    middleware: [middleware].toList(),
    initialState: AppState.initial(),
  );
}
