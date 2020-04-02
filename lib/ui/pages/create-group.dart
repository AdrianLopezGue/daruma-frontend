import 'package:daruma/model/group.dart';
import 'package:daruma/ui/widget/currency-button-widget.dart';
import 'package:daruma/ui/widget/post-dialog-widget.dart';
import 'package:daruma/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

class CreateGroupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: white,
          child: Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 15.0),
            child: Column(
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
                        'Crear un grupo',
                        style: GoogleFonts.aBeeZee(
                            fontSize: 30, textStyle: TextStyle(color: black)),
                      ),
                    ),
                  ],
                ),
                NewGroupForm()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NewGroupForm extends StatefulWidget {
  @override
  _NewGroupFormState createState() => _NewGroupFormState();
}

class _NewGroupFormState extends State<NewGroupForm> {
  final _formKey = GlobalKey<FormState>();
  Group group = Group();

  @override
  void initState() {
    var uuid = new Uuid();
    group.idGroup = uuid.v4();
    group.currencyCode = 'EUR';
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    final halfMediaWidth = MediaQuery.of(context).size.width / 2.0;
    
    return Form(
      key: _formKey,
      child: Column(        
        children: <Widget>[
          Container(
            alignment: Alignment.topCenter,            
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  alignment: Alignment.topCenter,
                  width: halfMediaWidth,
                  child: MyTextFormField(
                    hintText: 'Nombre del grupo',
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Introduce nombre al grupo';
                      }
                      return null;
                    },
                    onSaved: (String value) {
                      group.name = value;
                    },
                  ),
                ),
                CurrencyButton(
                  currentCurrencyCode: group.currencyCode,
                  selectedCode: (currencyCode){
                  setState(() {
                    group.currencyCode = currencyCode;
                  });
                }),
              ],
            ),
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
                      PostDialog(group: group),
                    ]));
              }
            },
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.done, color: white),
                    SizedBox(width: 5.0,),
                    Text(
                      'Guardar',
                      style: GoogleFonts.aBeeZee(
                                textStyle: TextStyle(fontSize: 20, color: Colors.white)                            
                                ),
                    ),
                  ],
                ),
              ),            
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          )
        ],
      ),
    );
  }
}

class MyTextFormField extends StatelessWidget {
  final String hintText;
  final Function validator;
  final Function onSaved;

  MyTextFormField({
    this.hintText,
    this.validator,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: EdgeInsets.all(15.0),
          filled: true,
          fillColor: white,
        ),
        validator: validator,
        onSaved: onSaved,
      );
  }
}
