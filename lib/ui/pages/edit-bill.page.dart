import 'package:daruma/model/bill.dart';
import 'package:daruma/model/group.dart';
import 'package:daruma/model/participant.dart';
import 'package:daruma/ui/widget/edit-bill-dialog.widget.dart';
import 'package:daruma/ui/widget/members-button.widget.dart';
import 'package:daruma/ui/widget/number-form-field.widget.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:intl/intl.dart';
import 'package:daruma/redux/index.dart';
import 'package:daruma/ui/widget/text-form-field.widget.dart';
import 'package:daruma/util/colors.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money2/money2.dart';

class EditBillPage extends StatelessWidget {
  final Bill bill;

  EditBillPage({this.bill});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: new Text("Editar Gasto"), leading: BackButton(
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pop();
            },
          )),
      body: SingleChildScrollView(
          child: Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.only(left: 5.0, top: 5.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
                EditBillForm(bill: bill)
              ],
          ),
        ),
      )),
    );
  }
}

class EditBillForm extends StatefulWidget {
  final Bill bill;

  EditBillForm({this.bill});

  @override
  _EditBillFormState createState() => _EditBillFormState();
}

class _EditBillFormState extends State<EditBillForm> {
  final _formKey = GlobalKey<FormState>();
  List<String> nameDebtors = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
      converter: (store) {
        return new _ViewModel(
            group: store.state.groupState.group,
            bill: store.state.billState.bill);
      },
      builder: (BuildContext context, _ViewModel vm) {
        return _formView(context, vm);
      },
      onInit: (store) {
        store.dispatch(StartEditingBillAction(
            widget.bill, store.state.groupState.group));

        for(int i = 0; i<store.state.billState.bill.debtors.length; i++){
          if(store.state.billState.bill.debtors[i].money != -1){
            this.nameDebtors.add(store.state.billState.bill.debtors[i].name);
          }
        }
      },
    );
  }

  Widget _formView(BuildContext context, _ViewModel vm) {
    final halfMediaWidth = MediaQuery.of(context).size.width / 1.02;
    final format = DateFormat("yyyy-MM-dd");

    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                    alignment: Alignment.topCenter,
                    width: halfMediaWidth,
                    child: Card(
                        child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                            children: <Widget>[
                              Text("Titulo del gasto"),
                            ],
                          ),
                            CustomTextFormField(
                              hintText: 'Titulo del gasto',
                              initialValue: vm.bill.name,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'Introduce nombre del gasto';
                                }
                                return null;
                              },
                              onSaved: (String value) {
                                StoreProvider.of<AppState>(context)
                                    .dispatch(BillNameChangedAction(value));
                              },
                            ),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                    alignment: Alignment.topCenter,
                    width: halfMediaWidth,
                    child: Card(
                        child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text("Cantidad"),
                              ],
                            ),
                            CustomNumberFormField(
                                hintText: '10.00',
                                initialValue: (vm.bill.money/100).toString(),
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
                                }),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  width: halfMediaWidth,
                  child: Card(
                      child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text("Fecha del gasto"),
                            ],
                          ),
                          DateTimeField(
                            initialValue: vm.bill.date,
                            format: format,
                            decoration: InputDecoration(
                              hintText: vm.bill.date.toIso8601String().substring(0, 10),
                              contentPadding: EdgeInsets.only(top: 15.0),
                              filled: true,
                              fillColor: Colors.transparent,
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
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.0),
            Row(
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  width: halfMediaWidth,
                  child: Card(
                      child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text("Quién ha pagado"),
                            ],
                          ),
                          MembersButton(
                            members: vm.group.members,
                            selectedMembers: (nameMembers) {
                              final Currency currencyCode = Currency.create(vm.bill.currencyCode, 2);
                              final value = Money.fromInt(vm.bill.money, currencyCode);
                              final allocation = value.allocationTo(nameMembers.length);

                              List<Participant> payers = [];

                              for(int i = 0; i < nameMembers.length ; i++){
                                payers.add(new Participant(
                                      participantId: vm.group.getMemberIdByName(nameMembers[i]),
                                      name: nameMembers[i],
                                      money: (allocation[i].minorUnits).toInt()));
                              }

                              StoreProvider.of<AppState>(context)
                                  .dispatch(BillPayersChangedAction(payers));
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  width: halfMediaWidth,
                  child: Card(
                      child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text("Para quién"),
                            ],
                          ),
                          CheckboxGroup(
                            labels: vm.bill.debtors.map((debtor) => debtor.name).toList(),
                            checked: nameDebtors,
                            onChange: (bool isChecked, String label, int index) {
                              if (isChecked) {
                                setState(() {
                                  nameDebtors.add(label);
                                });
                                StoreProvider.of<AppState>(context)
                                    .dispatch(BillDebtorWasAddedAction(index));
                              } else {
                                setState(() {
                                  nameDebtors.removeWhere((name) => name == label);
                                });

                                StoreProvider.of<AppState>(context)
                                    .dispatch(BillDebtorWasDeletedAction(index));
                              }
                            },
                            activeColor: redPrimaryColor,
                            itemBuilder: (Checkbox cb, Text txt, int i) {
                              return Row(
                                children: <Widget>[
                                  Expanded(child: cb, flex: 1),
                                  Expanded(child: txt, flex: 7),
                                  vm.bill.debtors[i].money == -1
                                      ? Expanded(child: Text('0.0'), flex: 2)
                                      : Expanded(
                                          child: Text(
                                              (vm.bill.debtors[i].money / 100).toStringAsFixed(2) + " " + vm.group.currencyCode),
                                          flex: 2),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.0),
            RaisedButton(
              color: redPrimaryColor,
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();

                  showDialog(
                      context: context,
                      builder: (__) {
                        return EditBillDialog(bill: vm.bill);
                      }
                  );
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
                      'Actualizar',
                      style: GoogleFonts.roboto(
                          textStyle:
                              TextStyle(fontSize: 20, color: Colors.white)),
                    ),
                  ],
                ),
              ),
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
            ),
            SizedBox(height: 15.0),
          ],
        ));
  }
}

class _ViewModel {
  final Group group;
  final Bill bill;

  _ViewModel({
    @required this.group,
    @required this.bill,
  });
}
