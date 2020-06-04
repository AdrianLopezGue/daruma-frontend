import 'package:daruma/model/bill.dart';
import 'package:daruma/model/group.dart';
import 'package:daruma/model/participant.dart';
import 'package:daruma/ui/widget/members-button.widget.dart';
import 'package:daruma/ui/widget/number-form-field.widget.dart';
import 'package:daruma/ui/widget/post-bill-dialog.widget.dart';
import 'package:intl/intl.dart';
import 'package:daruma/redux/index.dart';
import 'package:daruma/ui/widget/text-form-field.widget.dart';
import 'package:daruma/util/colors.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateBillPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            color: white,
            child: Padding(
              padding: const EdgeInsets.only(left: 25.0, top: 15.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      BackButton(color: Colors.grey),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Añadir gasto',
                          style: GoogleFonts.aBeeZee(
                              fontSize: 30, textStyle: TextStyle(color: black)),
                        ),
                      ),
                    ],
                  ),
                  NewBillForm()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class NewBillForm extends StatefulWidget {
  @override
  _NewBillFormState createState() => _NewBillFormState();
}

class _NewBillFormState extends State<NewBillForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
      converter: (store) {
        return new _ViewModel(
            idUser: store.state.firebaseState.firebaseUser.uid,
            group: store.state.groupState.group,
            bill: store.state.billState.bill);
      },
      builder: (BuildContext context, _ViewModel vm) {
        return _formView(context, vm);
      },
      onInit: (store) {
        store.dispatch(StartCreatingBill(
            store.state.groupState.group.idGroup,
            store.state.firebaseState.firebaseUser.uid,
            store.state.groupState.group.members.first.idMember,
            store.state.groupState.group.currencyCode));
      },
    );
  }

  Widget _formView(BuildContext context, _ViewModel vm) {
    final halfMediaWidth = MediaQuery.of(context).size.width / 1.15;
    final format = DateFormat("yyyy-MM-dd");

    List<Participant> debtors = vm.group.members
        .map((member) => Participant(
            idParticipant: member.idMember, name: member.name, money: 0))
        .toList();
    List<Participant> selectedDebtors = [];

    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  Container(
                      alignment: Alignment.topCenter,
                      width: halfMediaWidth,
                      child: CustomTextFormField(
                        hintText: 'Titulo del gasto',
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Introduce nombre del recibo';
                          }
                          return null;
                        },
                        onSaved: (String value) {
                          StoreProvider.of<AppState>(context)
                              .dispatch(BillNameChangedAction(value));
                        },
                      )),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              child: Row(
                children: <Widget>[
                  Container(
                      alignment: Alignment.topCenter,
                      width: halfMediaWidth,
                      child: CustomNumberFormField(
                          hintText: '10.00',
                          validator: (String value) {
                            if (double.parse(value) < 0) {
                              return 'Valor negativo no permitido';
                            }

                            return null;
                          },
                          onChanged: (String value) {
                            var moneyNumber = double.parse(value) * 100;
                            StoreProvider.of<AppState>(context).dispatch(
                                new BillMoneyChangedAction(
                                    moneyNumber.toInt()));

                            selectedDebtors.map((debtor) => debtor.money =
                                ((double.parse(value) /
                                            selectedDebtors.length) *
                                        100)
                                    .toInt());
                          })),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              alignment: Alignment.topLeft,
              child: DateTimeField(
                format: format,
                decoration: InputDecoration(
                  hintText: vm.bill.date.toIso8601String().substring(0, 10),
                  contentPadding: EdgeInsets.all(15.0),
                  filled: true,
                  fillColor: white,
                ),
                onShowPicker: (context, currentValue) async {
                  DateTime date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2100));

                  StoreProvider.of<AppState>(context)
                      .dispatch(BillDateChangedAction(date));
                  return date;
                },
              ),
            ),
            SizedBox(height: 30.0),
            Container(
              alignment: Alignment.topCenter,
              child: Row(
                children: <Widget>[
                  Text("Pagado por "),
                  MembersButton(
                    members: vm.group.members,
                    selectedMembers: (nameMembers) {
                      List<Participant> payers = nameMembers.map((name) =>
                          new Participant(
                              idParticipant: vm.group.getMemberIdByName(name),
                              name: name,
                              money: vm.bill.money ~/ nameMembers.length)).toList();

                      StoreProvider.of<AppState>(context)
                          .dispatch(BillPayersChangedAction(payers));
                      print(vm.bill.payers);
                      
                    },
                  )
                ],
              ),
            ),
            SizedBox(height: 30.0),
            Row(
              children: <Widget>[
                Text("Para quién"),
                MembersButton(
                    members: vm.group.members,
                    selectedMembers: (nameMembers) {
                      List<Participant> debtors = nameMembers.map((name) =>
                          new Participant(
                              idParticipant: vm.group.getMemberIdByName(name),
                              name: name,
                              money: vm.bill.money ~/ nameMembers.length)).toList();

                      StoreProvider.of<AppState>(context)
                          .dispatch(BillDebtorsChangedAction(debtors));
                    },
                  )
                ],
            ),
            SizedBox(height: 20.0),

          RaisedButton(
            color: redPrimaryColor,
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();

                showDialog(
                    context: context,
                    child: new SimpleDialog(children: <Widget>[
                      PostBillDialog(),
                    ]));
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.done, color: white),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    'Guardar',
                    style: GoogleFonts.aBeeZee(
                        textStyle:
                            TextStyle(fontSize: 20, color: Colors.white)),
                  ),
                ],
              ),
            ),
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          )
          ],
        ));
  }
}

class _ViewModel {
  final String idUser;
  final Group group;
  final Bill bill;

  _ViewModel({
    @required this.idUser,
    @required this.group,
    @required this.bill,
  });
}
