import 'package:daruma/model/participant.dart';
import 'package:daruma/redux/index.dart';
import 'package:daruma/redux/state.dart';
import 'package:uuid/uuid.dart';

AppState mainReducer(AppState state, dynamic action) {
  UserState userState = _reduceUserState(state, action);
  GroupState groupState = _reduceGroupState(state, action);
  BillState billState = _reduceBillState(state, action);
  bool userIsNew = _reduceUserIsNew(state, action);

  return AppState(
      userState: userState,
      groupState: groupState,
      billState: billState,
      userIsNew: userIsNew);
}

UserState _reduceUserState(AppState state, dynamic action) {
  UserState newState = state.userState;

  if (action is UserLoadedAction) {
    newState = newState.copyWith(
        user: action.user, idTokenUser: action.idTokenUser, photoUrl: action.photoUrl);
  }
  return newState;
}

GroupState _reduceGroupState(AppState state, dynamic action) {
  GroupState newState = state.groupState;

  if (action is StartLoadingGroupAction) {
    newState = newState.copyWith(isLoading: true, loadingError: false);
  } else if (action is LoadingGroupSuccessAction) {
    newState = newState.copyWith(
        group: action.group, isLoading: false, loadingError: false);
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
    Participant firstPayer = new Participant(
        idParticipant: action.group.members.first.idMember, money: 0);

    newState = newState.copyWith(
        bill: newState.bill.copyWith(
            idBill: uuid.v4(),
            idGroup: action.group.idGroup,
            currencyCode: action.group.currencyCode,
            payers: [firstPayer],
            debtors: action.group.members
                .map((member) => Participant(
                    idParticipant: member.idMember,
                    name: member.name,
                    money: 0))
                .toList(),
            idCreator: action.idCreator,
            money: 0));
  } else if (action is BillNameChangedAction) {
    newState =
        newState.copyWith(bill: newState.bill.copyWith(name: action.newName));
  } else if (action is BillDateChangedAction) {
    newState =
        newState.copyWith(bill: newState.bill.copyWith(date: action.newDate));
  } else if (action is BillMoneyChangedAction) {
    var count =
        newState.bill.debtors.where((debtor) => debtor.money != -1).length;

    List<Participant> newDebtors = newState.bill.debtors.map((debtor) {
      if (debtor.money != -1) {
        return Participant(
            idParticipant: debtor.idParticipant,
            name: debtor.name,
            money: (action.newMoney ~/ count));
      } else {
        return Participant(
            idParticipant: debtor.idParticipant, name: debtor.name, money: -1);
      }
    }).toList();

    List<Participant> newPayers = newState.bill.payers
        .map((payer) => Participant(
            idParticipant: payer.idParticipant,
            name: payer.name,
            money: action.newMoney ~/ newState.bill.payers.length))
        .toList();

    newState = newState.copyWith(
        bill: newState.bill.copyWith(
            money: action.newMoney, debtors: newDebtors, payers: newPayers));
  } else if (action is BillDebtorWasDeletedAction) {
    newState.bill.debtors[action.index].money = -1;
    var count =
        newState.bill.debtors.where((debtor) => debtor.money != -1).length;

    List<Participant> newDebtors = newState.bill.debtors.map((debtor) {
      if (debtor.money != -1) {
        return Participant(
            idParticipant: debtor.idParticipant,
            name: debtor.name,
            money: (newState.bill.money ~/ count));
      } else {
        return Participant(
            idParticipant: debtor.idParticipant, name: debtor.name, money: -1);
      }
    }).toList();
    newState =
        newState.copyWith(bill: newState.bill.copyWith(debtors: newDebtors));
  } else if (action is BillDebtorWasAddedAction) {
    newState.bill.debtors[action.index].money = 0;
    var count =
        newState.bill.debtors.where((debtor) => debtor.money != -1).length;

    List<Participant> newDebtors = newState.bill.debtors.map((debtor) {
      if (debtor.money != -1) {
        return Participant(
            idParticipant: debtor.idParticipant,
            name: debtor.name,
            money: (newState.bill.money ~/ count));
      } else {
        return Participant(
            idParticipant: debtor.idParticipant, name: debtor.name, money: -1);
      }
    }).toList();
    newState =
        newState.copyWith(bill: newState.bill.copyWith(debtors: newDebtors));
  } else if (action is BillPayersChangedAction) {
    newState = newState.copyWith(
        bill: newState.bill.copyWith(payers: action.newPayers));
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
