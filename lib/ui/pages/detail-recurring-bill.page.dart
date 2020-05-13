import 'package:daruma/model/bill.dart';
import 'package:daruma/model/group.dart';
import 'package:daruma/model/recurring-bill.dart';
import 'package:daruma/ui/pages/group.page.dart';
import 'package:daruma/ui/widget/delete-recurring-bill-dialog.widget.dart';
import 'package:daruma/ui/widget/detail-bill-app-bar-title.widget.dart';
import 'package:daruma/ui/widget/detail-bill-flexible-app-bar.dart';
import 'package:daruma/ui/widget/edit-recurring-bill-dialog.widget.dart';
import 'package:daruma/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_buttons/grouped_buttons.dart';

class DetailRecurringBillPage extends StatefulWidget {
  final RecurringBill recurringBill;
  final Bill bill;
  final Group group;

  DetailRecurringBillPage({this.recurringBill, this.bill, this.group});

  @override
  _DetailRecurringBillPageState createState() => _DetailRecurringBillPageState();
}

class _DetailRecurringBillPageState extends State<DetailRecurringBillPage> {
  String _picked = "Diariamente";

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
            leading: BackButton(
              color: Colors.white,
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
            title: BillAppBarTitle(title: "Detalle del gasto recurrente"),
            pinned: true,
            expandedHeight: 210.0,
            flexibleSpace: FlexibleSpaceBar(
              background: BillFlexibleAppBar(title: this.widget.bill.name,
                price: (widget.bill.money / 100).toString() + " " + widget.bill.currencyCode,
                bottomLeftSubtitle: "Se cobrará\n" + this.widget.recurringBill.nextCreationDate.toIso8601String().substring(0, 10),
                bottomRightSubtitle:
                    "Fue creado\n" + this.widget.bill.date.toIso8601String().substring(0, 10),),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          // return object of type Dialog
                          return AlertDialog(
                            content: new Text("¿Seguro que quieres borrar este gasto recurrente?"),
                            actions: <Widget>[
                              new FlatButton(
                                child: new Text("BORRAR"),
                                onPressed: () {
                                  showDialog(
                                  context: context,
                                  builder: (__) {
                                    return DeleteRecurringBillDialog(recurringBillId: this.widget.recurringBill.id);
                                  });
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
              )
            ],
            ),
        SliverToBoxAdapter(
          child: Column(
            children: <Widget>[
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    SizedBox(height: 160.0),
                    RaisedButton(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(Icons.edit, color: Colors.white,),
                            SizedBox(width: 5.0),
                            Text('Editar periodicidad', style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                        fontSize: 20, color: Colors.white))),
                          ],
                        ),
                      ),
                      color: redPrimaryColor,
                      onPressed: () => _displayDialog(context),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    ));
  }

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        child: new SimpleDialog(
            title: Text('Selecciona la periodicidad'),
            children: <Widget>[
              RadioButtonGroup(
                  orientation: GroupedButtonsOrientation.VERTICAL,
                  margin: const EdgeInsets.only(left: 12.0),
                  onSelected: (String selected) => 
                  setState((){
                      this._picked = selected;
                  }),
                  labels: <String>[
                    "Diariamente",
                    "Semanalmente",
                    "Mensualmente",
                    "Anualmente",
                  ],
                  itemBuilder: (Radio rb, Text txt, int i){
                    return Row(
                      children: <Widget>[
                        rb,
                        txt,
                      ],
                    );
                  },
                ),
              FlatButton(
                  onPressed: () {
                    var period;
                    
                    switch(_picked){
                      case "Diariamente":{
                        period = 1;
                      }
                      break;

                      case "Semanalmente":{
                        period = 7;
                      }
                      break;

                      case "Mensualmente":{
                        period = 30;
                      }
                      break;

                      case "Anualmente":{
                        period = 365;
                      }
                      break;
                    }
                    showDialog(
                      context: context,
                      builder: (__) {
                        return EditRecurringBillDialog(recurringBillId: widget.recurringBill.id, period: period);
                      }
                  );
                  },
                  child: Text("Guardar")),
            ],
          )
        );
  }
}
