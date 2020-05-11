import 'package:daruma/model/bill.dart';
import 'package:daruma/model/group.dart';
import 'package:daruma/model/participant.dart';
import 'package:daruma/ui/pages/group.page.dart';
import 'package:daruma/ui/widget/members-button.widget.dart';
import 'package:daruma/ui/widget/number-form-field.widget.dart';
import 'package:daruma/ui/widget/post-bill-dialog.widget.dart';
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

class CreateBillPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
          title: new Text("Nuevo Gasto"),
          leading: IconButton(
            icon: Icon(Icons.clear),
            color: Colors.white,
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  // return object of type Dialog
                  return AlertDialog(
                    content: new Text("¿Quieres cancelar este gasto?"),
                    actions: <Widget>[
                      new FlatButton(
                        child: new Text("SALIR SIN GUARDAR"),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return GroupPage();
                              },
                            ),
                          );
                        },
                      ),
                      new FlatButton(
                        child: new Text("CANCELAR"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
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
            children: <Widget>[NewBillForm()],
          ),
        ),
      )),
    );
  }
}

class NewBillForm extends StatefulWidget {
  @override
  _NewBillFormState createState() => _NewBillFormState();
}

class _NewBillFormState extends State<NewBillForm> {
  final _formKey = GlobalKey<FormState>();
  List<String> nameDebtors = [];
  int period = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
      converter: (store) {
        return new _ViewModel(
            userId: store.state.userState.user.userId,
            group: store.state.groupState.group,
            bill: store.state.billState.bill);
      },
      builder: (BuildContext context, _ViewModel vm) {
        return _formView(context, vm);
      },
      onInit: (store) {
        store.dispatch(StartCreatingBillAction(
            store.state.groupState.group, store.state.userState.user.userId));

        this.nameDebtors = store.state.billState.bill.debtors
            .map((debtor) => debtor.name)
            .toList();
      },
    );
  }

  Widget _formView(BuildContext context, _ViewModel vm) {
    final halfMediaWidth = MediaQuery.of(context).size.width / 1.02;
    final format = DateFormat("yyyy-MM-dd");
    String dateTitle = "Fecha del gasto";

    if (this.period == 0) {
    } else {
      String addedPeriod = "";
      if (this.period == 1) {
        addedPeriod = "diariamente";
      } else if (this.period == 7) {
        addedPeriod = "semanalmente";
      } else if (this.period == 30) {
        addedPeriod = "mensualmente";
      } else if (this.period == 360) {
        addedPeriod = "una vez al año";
      }

      dateTitle += " - Repetir " + addedPeriod;
    }

    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
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
                              Text("Titulo del gasto"),
                            ],
                          ),
                          CustomTextFormField(
                            hintText: 'Uber desde el aeropuerto',
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
                child: Row(
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
                                    validator: (String value) {
                                      if (double.parse(value) < 0) {
                                        return 'Valor negativo no permitido';
                                      }

                                      return null;
                                    },
                                    onChanged: (String value) {
                                      var moneyNumber =
                                          double.parse(value) * 100;
                                      StoreProvider.of<AppState>(context)
                                          .dispatch(new BillMoneyChangedAction(
                                              moneyNumber.toInt()));
                                    }),
                              ],
                            ),
                          ),
                        )),
                  ],
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
                            Text("Quién ha pagado"),
                          ],
                        ),
                        MembersButton(
                          members: vm.group.members,
                          selectedMembers: (nameMembers) {
                            final Currency currencyCode =
                                Currency.create(vm.bill.currencyCode, 2);
                            final value =
                                Money.fromInt(vm.bill.money, currencyCode);
                            final allocation =
                                value.allocationTo(nameMembers.length);

                            List<Participant> payers = [];

                            for (int i = 0; i < nameMembers.length; i++) {
                              payers.add(new Participant(
                                  participantId: vm.group
                                      .getMemberIdByName(nameMembers[i]),
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
                          labels: vm.bill.debtors
                              .map((debtor) => debtor.name)
                              .toList(),
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
                                nameDebtors
                                    .removeWhere((name) => name == label);
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
                                            (vm.bill.debtors[i].money / 100)
                                                .toString()),
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
                            Text(dateTitle),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: DateTimeField(
                                format: format,
                                decoration: InputDecoration(
                                  hintText: vm.bill.date
                                      .toIso8601String()
                                      .substring(0, 10),
                                  contentPadding: EdgeInsets.only(top: 15.0),
                                  filled: true,
                                  fillColor: Colors.transparent,
                                ),
                                onShowPicker: (context, currentValue) async {
                                  DateTime date = await showDatePicker(
                                      context: context,
                                      firstDate: DateTime(1900),
                                      initialDate:
                                          currentValue ?? DateTime.now(),
                                      lastDate: DateTime(2100));

                                  StoreProvider.of<AppState>(context)
                                      .dispatch(BillDateChangedAction(date));
                                  return date;
                                },
                              ),
                            ),
                            SizedBox(width: 5.0),
                            PopupMenuButton(
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.autorenew),
                                  SizedBox(width: 5.0),
                                  Text("REPETIR")
                                ],
                              ),
                              itemBuilder: (_) => [
                                PopupMenuItem(
                                  child: Text('No repetir'),
                                  value: 0,
                                ),
                                PopupMenuItem(
                                  child: Text('Diariamente'),
                                  value: 1,
                                ),
                                PopupMenuItem(
                                    child: Text('Semanalmente'), value: 7),
                                PopupMenuItem(
                                    child: Text('Mensualmente'), value: 30),
                                PopupMenuItem(
                                    child: Text('Anualmente'), value: 360),
                              ],
                              onSelected: (value) {
                                setState(() {
                                  this.period = value;
                                });
                              },
                            )
                          ],
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
                      return PostBillDialog(bill: vm.bill, period: this.period);
                    });
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
                    style: GoogleFonts.roboto(
                        textStyle:
                            TextStyle(fontSize: 20, color: Colors.white)),
                  ),
                ],
              ),
            ),
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          ),
          SizedBox(height: 15.0),
        ],
      ),
    );
  }
}

class _ViewModel {
  final String userId;
  final Group group;
  final Bill bill;

  _ViewModel({
    @required this.userId,
    @required this.group,
    @required this.bill,
  });
}
