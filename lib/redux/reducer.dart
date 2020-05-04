import 'package:daruma/model/group.dart';
import 'package:daruma/model/member.dart';
import 'package:daruma/model/participant.dart';
import 'package:daruma/model/user.dart';
import 'package:daruma/redux/index.dart';
import 'package:daruma/redux/state.dart';
import 'package:money2/money2.dart';
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
        user: action.user,
        idTokenUser: action.idTokenUser,
        photoUrl: action.photoUrl);
  } else if (action is UserUpdatedAction) {
    User newUser =
        newState.user.copyWith(name: action.name, paypal: action.paypal);
    newState = newState.copyWith(user: newUser);
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
  } else if (action is GroupNameUpdatedAction) {
    Group newGroup = newState.group.copyWith(name: action.name);
    newState = newState.copyWith(group: newGroup);
  } else if (action is AddMemberToGroupAction) {
    List<Member> newMembers = newState.group.members;
    newMembers.add(action.member);

    Group newGroup = newState.group.copyWith(members: newMembers);
    newState = newState.copyWith(group: newGroup);
  } else if (action is DeleteMemberToGroupAction) {
    List<Member> newMembers = newState.group.members;
    newMembers
        .removeWhere((member) => member.idMember == action.member.idMember);

    Group newGroup = newState.group.copyWith(members: newMembers);
    newState = newState.copyWith(group: newGroup);
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

    final Currency currencyCode =
        Currency.create(newState.bill.currencyCode, 2);
    final value = Money.fromInt(action.newMoney, currencyCode);
    final allocation = value.allocationTo(count);

    List<Participant> newDebtors = [];

    for (int i = 0; i < newState.bill.debtors.length; i++) {
      if (newState.bill.debtors[i].money != -1) {
        newDebtors.add(new Participant(
            idParticipant: newState.bill.debtors[i].idParticipant,
            name: newState.bill.debtors[i].name,
            money: (allocation[i].minorUnits).toInt()));
      } else {
        newDebtors.add(new Participant(
            idParticipant: newState.bill.debtors[i].idParticipant,
            name: newState.bill.debtors[i].name,
            money: -1));
      }
    }

    final allocationPayers = value.allocationTo(newState.bill.payers.length);

    List<Participant> newPayers = [];

    for (int i = 0; i < newState.bill.payers.length; i++) {
      newPayers.add(new Participant(
          idParticipant: newState.bill.payers[i].idParticipant,
          name: newState.bill.payers[i].name,
          money: (allocationPayers[i].minorUnits).toInt()));
    }

    newState = newState.copyWith(
        bill: newState.bill.copyWith(
            money: action.newMoney, debtors: newDebtors, payers: newPayers));
  } else if (action is BillDebtorWasDeletedAction) {
    newState.bill.debtors[action.index].money = -1;
    var count =
        newState.bill.debtors.where((debtor) => debtor.money != -1).length;

    final Currency currencyCode =
        Currency.create(newState.bill.currencyCode, 2);
    final value = Money.fromInt(newState.bill.money, currencyCode);
    final allocation = value.allocationTo(count);

    List<Participant> newDebtors = [];

    for (int i = 0; i < newState.bill.debtors.length; i++) {
      if (newState.bill.debtors[i].money != -1) {
        newDebtors.add(new Participant(
            idParticipant: newState.bill.debtors[i].idParticipant,
            name: newState.bill.debtors[i].name,
            money: (allocation[i].minorUnits).toInt()));
      } else {
        newDebtors.add(new Participant(
            idParticipant: newState.bill.debtors[i].idParticipant,
            name: newState.bill.debtors[i].name,
            money: -1));
      }
    }

    newState =
        newState.copyWith(bill: newState.bill.copyWith(debtors: newDebtors));
  } else if (action is BillDebtorWasAddedAction) {
    newState.bill.debtors[action.index].money = 0;
    var count =
        newState.bill.debtors.where((debtor) => debtor.money != -1).length;

    final Currency currencyCode =
        Currency.create(newState.bill.currencyCode, 2);
    final value = Money.fromInt(newState.bill.money, currencyCode);
    final allocation = value.allocationTo(count);

    List<Participant> newDebtors = [];

    for (int i = 0; i < newState.bill.debtors.length; i++) {
      if (newState.bill.debtors[i].money != -1) {
        newDebtors.add(new Participant(
            idParticipant: newState.bill.debtors[i].idParticipant,
            name: newState.bill.debtors[i].name,
            money: (allocation[i].minorUnits).toInt()));
      } else {
        newDebtors.add(new Participant(
            idParticipant: newState.bill.debtors[i].idParticipant,
            name: newState.bill.debtors[i].name,
            money: -1));
      }
    }
    
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
