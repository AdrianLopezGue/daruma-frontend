import 'package:daruma/model/group.dart';
import 'package:daruma/model/member.dart';
import 'package:daruma/ui/pages/group.page.dart';
import 'package:daruma/ui/widget/add-member-dialog.widget.dart';
import 'package:daruma/ui/widget/currency-button.widget.dart';
import 'package:daruma/ui/widget/delete-group-dialog.widget.dart';
import 'package:daruma/ui/widget/edit-group-dialog.widget.dart';
import 'package:daruma/ui/widget/members-list.widget.dart';
import 'package:daruma/ui/widget/text-form-field.widget.dart';
import 'package:daruma/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

class EditGroupPage extends StatefulWidget {
  final Group group;

  EditGroupPage({this.group});

  @override
  _EditGroupPageState createState() => _EditGroupPageState();
}

class _EditGroupPageState extends State<EditGroupPage> {
  final _formKey = GlobalKey<FormState>();
  final _formNewMemberKey = GlobalKey<FormState>();

  String groupId = "";
  String newName = "";
  String newCurrencyCode = "";
  String newMemberName = "";

  @override
  void initState() {
    groupId = widget.group.groupId;
    newName = widget.group.name;
    newCurrencyCode = widget.group.currencyCode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final halfMediaWidth = MediaQuery.of(context).size.width / 2.0;

    return Scaffold(
        appBar: new AppBar(
          title: new Text("Editar grupo"),
          backgroundColor: redPrimaryColor,
          leading: BackButton(
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
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Container(
                    alignment: Alignment.topLeft,
                    width: halfMediaWidth * 2.0,
                    child: Card(
                        child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Nombre del grupo",
                                      style: GoogleFonts.roboto(
                                          fontSize: 16,
                                          textStyle: TextStyle(color: Colors.grey)),
                                    ),
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
                                Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          "Divisa",
                                          style: GoogleFonts.roboto(
                                              fontSize: 16,
                                              textStyle:
                                                  TextStyle(color: Colors.grey)),
                                        )
                                      ],
                                    ),
                                    CurrencyButton(
                                        currentCurrencyCode: newCurrencyCode,
                                        selectedCode: (currencyCode) {
                                          setState(() {
                                            newCurrencyCode = currencyCode;
                                          });
                                        })
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                RaisedButton(
                                  color: redPrimaryColor,
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();

                                      if (newName != widget.group.name ||
                                          newCurrencyCode !=
                                              widget.group.currencyCode) {
                                        showDialog(
                                            context: context,
                                            builder: (__) {
                                              return EditGroupDialog(
                                                  name: newName,
                                                  currencyCode: newCurrencyCode);
                                            });
                                      }
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
                                              textStyle: TextStyle(
                                                  fontSize: 20, color: Colors.white)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40)),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.topLeft,
                          width: halfMediaWidth * 2.0,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        "Miembros de este grupo",
                                        style: GoogleFonts.roboto(
                                            fontSize: 16,
                                            textStyle:
                                                TextStyle(color: Colors.grey)),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      MembersList(),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Form(
                                        key: _formNewMemberKey,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  alignment:
                                                      Alignment.topCenter,
                                                  width: halfMediaWidth * 1.55,
                                                  child: CustomTextFormField(
                                                    hintText:
                                                        "Otro participante",
                                                    validator:
                                                        (String value) {
                                                      if (value.isEmpty) {
                                                        return 'El nombre no puede estar vacio';
                                                      }
                                                      return null;
                                                    },
                                                    onSaved: (String value) {
                                                      setState(() {
                                                        newMemberName = value;
                                                      });
                                                    },
                                                  ),
                                                ),
                                                Ink(
                                                    decoration: const ShapeDecoration(
                                                      color: redPrimaryColor,
                                                      shape: CircleBorder(),
                                                    ),
                                                    child: IconButton(icon: Icon(
                                                            Icons.person_add,
                                                            color: white,
                                                          ), onPressed: (){
                                                            if (_formNewMemberKey
                                                          .currentState
                                                          .validate()) {
                                                        _formNewMemberKey
                                                            .currentState
                                                            .save();
                                                        var uuid = new Uuid();

                                                        Member newMember =
                                                            new Member(
                                                                memberId:
                                                                    uuid.v4(),
                                                                name:
                                                                    newMemberName);

                                                        showDialog(
                                                            context: context,
                                                            builder: (__) {
                                                              return AddMemberDialog(
                                                                  member:
                                                                      newMember,
                                                                  groupId:
                                                                      groupId);
                                                            });
                                                      }
                                                          },),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.0,
                ),
                RaisedButton(
                  color: redPrimaryColor,
                  onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          // return object of type Dialog
                          return AlertDialog(
                            content: new Text("¿Seguro que quieres borrar el grupo?"),
                            actions: <Widget>[
                              new FlatButton(
                                child: new Text("BORRAR"),
                                onPressed: () {
                                  showDialog(
                                  context: context,
                                  builder: (__) {
                                    return DeleteDialog(groupId: groupId);
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
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.delete, color: white),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          'Borrar grupo',
                          style: GoogleFonts.roboto(
                              textStyle:
                                  TextStyle(fontSize: 20, color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                )
              ],
            ),
          ),
        ));
  }
}
