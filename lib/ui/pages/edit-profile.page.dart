import 'package:daruma/ui/widget/edit-profile-dialog.widget.dart';
import 'package:daruma/ui/widget/text-form-field.widget.dart';
import 'package:daruma/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfilePage extends StatefulWidget {

  final String name;
  final String paypal;

  EditProfilePage({this.name, this.paypal});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  String newName = "";
  String newPaypal = "";

  @override
  void initState() {
    newName = widget.name;
    newPaypal = widget.paypal;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final halfMediaWidth = MediaQuery.of(context).size.width / 2.0;

    return Scaffold(
      appBar: new AppBar(title: new Text("Editar perfil"), backgroundColor: redPrimaryColor,),
      body: 
          SingleChildScrollView(
                child: SafeArea(
                child: Form(
                  key: _formKey,
                    child: Padding(
                    padding: const EdgeInsets.only(left: 25.0, top: 15.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              "Nombre",
                              style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  textStyle: TextStyle(color: Colors.grey)),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topCenter,
                              width: halfMediaWidth,
                              child: CustomTextFormField(
                                initialValue: newName,
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return 'El nuevo nombre no puede estar vacio';
                                  }
                                  return null;
                                },
                                onSaved: (String value) {
                                  setState(() {
                                    newName = value;
                                  });                                  
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 25.0,
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              "Cuenta de paypal",
                              style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  textStyle: TextStyle(color: Colors.grey)),
                            )
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topCenter,
                              width: halfMediaWidth,
                              child: CustomTextFormField(
                                initialValue: newPaypal,
                                onSaved: (String value) {
                                  newPaypal = value;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 25.0,
                        ),
                        RaisedButton(
                          color: redPrimaryColor,
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();

                              showDialog(
                                context: context,
                                child: new SimpleDialog(children: <Widget>[
                                  EditProfileDialog(name: newName, paypal: newPaypal),
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
                        )
                      ],
                    ),
                  ),
                ),
            ),
          )
    );
  }
}
