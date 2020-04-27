import 'package:daruma/model/bill.dart';
import 'package:daruma/model/group.dart';
import 'package:daruma/model/participant.dart';
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

class CreateBillPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: new Text("Nuevo Gasto")),
      body: SingleChildScrollView(
        child:
          Container(
            color: white,
            child: Padding(
              padding: const EdgeInsets.only(left: 25.0, top: 15.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  NewBillForm()
                ],
              ),
            ),
          )
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
            idUser: store.state.firebaseState.firebaseUser.uid,
            group: store.state.groupState.group,
            bill: store.state.billState.bill);
      },
      builder: (BuildContext context, _ViewModel vm) {
        return _formView(context, vm);
      },
      onInit: (store) {
        this.nameDebtors = store.state.billState.bill.debtors.map((debtor) => debtor.name).toList();
        store.dispatch(StartCreatingBill(
            store.state.groupState.group,
            store.state.firebaseState.firebaseUser.uid
            ));
      },
    );
  }

  Widget _formView(BuildContext context, _ViewModel vm) {
    final halfMediaWidth = MediaQuery.of(context).size.width / 1.15;
    final format = DateFormat("yyyy-MM-dd");


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
            SizedBox(height: 15.0),
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
                      
                    },
                  )
                ],
              ),
            ),
            SizedBox(height: 15.0),
            Row(
              children: <Widget>[
                Text("Para quién"),
                ],
            ),
            SizedBox(height: 20.0),
            CheckboxGroup(
                labels: vm.bill.debtors.map((debtor) => debtor.name).toList(),
                checked: nameDebtors,
                onChange: (bool isChecked, String label, int index){
                  if(isChecked){
                    setState(() {
                      nameDebtors.add(label);                      
                    });
                    StoreProvider.of<AppState>(context)
                          .dispatch(BillDebtorWasAddedAction(index));
                  }
                  else{
                    setState(() {
                      nameDebtors.removeWhere((name) => name == label);                     
                    });
                    
                    StoreProvider.of<AppState>(context)
                          .dispatch(BillDebtorWasDeletedAction(index));
                  }
                },
                activeColor: redPrimaryColor,
                itemBuilder: (Checkbox cb, Text txt, int i){
                  return Row(
                    children: <Widget>[
                      Expanded(child: cb, flex: 1),
                      Expanded(child: txt, flex: 7),
                      vm.bill.debtors[i].money == -1 ? Expanded(child: Text('0.0'), flex: 2)  : Expanded(child: Text((vm.bill.debtors[i].money/100).toString()), flex: 2),
                    ],
                  );
                },
              ),

          RaisedButton(
            color: redPrimaryColor,
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();

                showDialog(
                    context: context,
                    child: new SimpleDialog(children: <Widget>[
                      PostBillDialog(bill: vm.bill),
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
          ),
          SizedBox(height: 15.0),
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
