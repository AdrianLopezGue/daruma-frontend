import 'package:daruma/model/bill.dart';
import 'package:daruma/model/group.dart';
import 'package:daruma/model/participant.dart';
import 'package:daruma/ui/widget/members-list.widget.dart';
import 'package:daruma/ui/widget/number-form-field.widget.dart';
import 'package:daruma/ui/widget/payers-button.widget.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:intl/intl.dart';
import 'package:daruma/redux/index.dart';
import 'package:daruma/ui/widget/text-form-field.widget.dart';
import 'package:daruma/util/colors.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

class CreateBillPage extends StatefulWidget {
  @override
  _CreateBillPageState createState() => _CreateBillPageState();
}

class _CreateBillPageState extends State<CreateBillPage> {
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
  Bill bill = Bill();

  @override
  void initState() {
    var uuid = new Uuid();
    bill.idBill = uuid.v4();
    bill.money = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(converter: (store) {
      return new _ViewModel(
          idUser: store.state.firebaseState.firebaseUser.uid,
          group: store.state.groupState.group);
    }, builder: (BuildContext context, _ViewModel vm) {
      return _formView(context, vm);
    });
  }

  Widget _formView(BuildContext context, _ViewModel vm) {
    final halfMediaWidth = MediaQuery.of(context).size.width / 1.15;
    final format = DateFormat("yyyy-MM-dd");

    bill.idGroup = vm.group.idGroup;
    bill.idCreator = vm.idUser;
    bill.payers = [];
    bill.debtors = [];

    Participant creator = new Participant(
        idParticipant: vm.group.members.first.idMember, money: 0);

    bill.payers.add(creator);

    bill.date = DateTime.now();

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
                          setState(() {
                            bill.name = value;
                          });
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
                          if (int.parse(value) < 0) {
                            return 'Valor negativo no permitido';
                          }

                          return null;
                        },
                        onChanged: (String value) {
                            var moneyNumber = double.parse(value) * 100;
                            bill.money = moneyNumber.toInt();
                            bill.currencyCode = vm.group.currencyCode;                                                                          
                        },
                      )),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              alignment: Alignment.topLeft,
              child: DateTimeField(
                format: format,
                decoration: InputDecoration(
                  hintText: bill.date.toIso8601String().substring(0, 10),
                  contentPadding: EdgeInsets.all(15.0),
                  filled: true,
                  fillColor: white,
                ),
                onShowPicker: (context, currentValue) async {
                  bill.date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2100));

                  return bill.date;
                },
              ),
            ),
            SizedBox(height: 30.0),
            Container(
              alignment: Alignment.topCenter,
              child: Row(
                children: <Widget>[
                  Text("Pagado por "),
                  PayersButton(
                    money: bill.money,
                    payer: vm.group
                        .getMemberNameById(bill.payers.first.idParticipant),
                    members: vm.group.members,
                    selectedPayer: (idPayer) {
                      bill.payers.clear();
                      Participant billPayer = new Participant(
                          idParticipant: idPayer, money: bill.money);
                      bill.payers.add(billPayer);

                      print(bill.payers.first.idParticipant);
                      print(bill.payers.first.money);
                    },
                  )
                ],
              ),
            ),
            SizedBox(height: 30.0),
            Row(children: <Widget>[Text("Para quién")],),
            CheckboxGroup(
                labels: vm.group.members.map((member) => member.name).toList(),
                onChange: (bool isChecked, String label, int index) => print("isChecked: $isChecked   label: $label  index: $index"),
                onSelected: (List<String> checked) => print("checked: ${checked.toString()}"),
              )
          ],
        ));
  }
}

class _ViewModel {
  final String idUser;
  final Group group;

  _ViewModel({
    @required this.idUser,
    @required this.group,
  });
}
