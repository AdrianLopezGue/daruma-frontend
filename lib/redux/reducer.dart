import 'package:daruma/model/participant.dart';
import 'package:daruma/redux/index.dart';
import 'package:daruma/redux/state.dart';
import 'package:uuid/uuid.dart';

AppState mainReducer(AppState state, dynamic action) {
  FirebaseState firebaseState = _reduceFirebaseState(state, action);
  GroupState groupState = _reduceGroupState(state, action);
  BillState billState = _reduceBillState(state, action);
  bool userIsNew = _reduceUserIsNew(state, action);

  return AppState(
      firebaseState: firebaseState,
      groupState: groupState,
      billState: billState,
      userIsNew: userIsNew);
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
    newState = newState.copyWith(isLoading: true, loadingError: false);
  } else if (action is LoadingGroupSuccessAction) {
    newState = newState.copyWith(group: action.group, isLoading: false, loadingError: false);
  } else if (action is LoadingGroupFailedAction) {
    newState =
        newState.copyWith(group: null, isLoading: false, loadingError: true);
  }
  return newState;
}

BillState _reduceBillState(AppState state, dynamic action) {
  BillState newState = state.billState;

  if (action is StartCreatingBill) {
    newState = BillState.initial();

    var uuid = new Uuid();
    Participant firstPayer =
        new Participant(idParticipant: action.idFirstPayer, money: 0);

    newState = newState.copyWith(
      bill: newState.bill.copyWith(
        idBill: uuid.v4(),
        idGroup: action.idGroup,
        currencyCode: action.currencyCode,
        payers: [firstPayer],
        idCreator: action.idCreator,
        money: 0
      )
    );
  } else if (action is BillNameChangedAction) {
    newState =
        newState.copyWith(bill: newState.bill.copyWith(name: action.newName));
  } else if (action is BillDateChangedAction) {
    newState =
        newState.copyWith(bill: newState.bill.copyWith(date: action.newDate));
  } else if (action is BillMoneyChangedAction) {
    newState =
        newState.copyWith(bill: newState.bill.copyWith(money: action.newMoney));
  } else if (action is BillPayersChangedAction) {
    newState = newState.copyWith(
        bill: newState.bill.copyWith(payers: action.newPayers));
  } else if (action is BillDebtorsChangedAction) {
    newState = newState.copyWith(
        bill: newState.bill.copyWith(debtors: action.newDebtors));
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
