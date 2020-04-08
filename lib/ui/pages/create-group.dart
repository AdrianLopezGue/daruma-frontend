import 'package:contacts_service/contacts_service.dart';
import 'package:daruma/model/group.dart';
import 'package:daruma/model/member.dart';
import 'package:daruma/ui/pages/add-members.dart';
import 'package:daruma/ui/widget/currency-button-widget.dart';
import 'package:daruma/ui/widget/post-dialog-widget.dart';
import 'package:daruma/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

class CreateGroupPage extends StatefulWidget {
  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
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
                  NewGroupForm(),
                ],
              ),
            ),
          )
        ],
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
  List<Contact> members = new List<Contact>();

  @override
  void initState() {
    var uuid = new Uuid();
    group.idGroup = uuid.v4();
    group.currencyCode = 'EUR';
    group.members = new List<Member>();
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
                    selectedCode: (currencyCode) {
                      setState(() {
                        group.currencyCode = currencyCode;
                      });
                    }),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 15.0),
            child: Row(
              children: <Widget>[
                Text(
                  'Miembros del grupo',
                  style: GoogleFonts.aBeeZee(
                      fontSize: 18, textStyle: TextStyle(color: black)),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          members.isNotEmpty
              ? ConstrainedBox(
                  constraints: BoxConstraints(minHeight: 50.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: members?.length,
                    itemBuilder: (BuildContext context, int index) {
                      Contact _member = members[index];
                      var _phonesList = _member.phones.toList();

                      return _buildListTile(_member, _phonesList);
                    },
                  ),
                )
              : Container(),
          SizedBox(height: 20.0),
          new MaterialButton(
              color: redPrimaryColor,
              child: new Text(
                'Añadir personas al grupo',
                style: GoogleFonts.aBeeZee(
                    fontSize: 18, textStyle: TextStyle(color: white)),
              ),
              onPressed: () async {
                List<Contact> result;
                if (await Permission.contacts.request().isGranted) {
                  result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AddMembersPage(title: "Añadir miembros")),
                  );

                  bool sameMember = false;
                  if (result != null) {
                    for (var i = 0; i < result.length; i++) {
                      for (var j = 0; j < members.length; j++) {
                        if (result[i].displayName == members[j].displayName) {
                          sameMember = true;
                        }
                      }
                      if (!sameMember) {
                        members.add(result[i]);

                        setState(() {
                          var uuid = new Uuid();
                          Member member = Member();

                          member.idMember = uuid.v4();
                          member.name = result[i].displayName;
                          group.members.add(member);
                        });

                      }
                      sameMember = false;
                    }
                  }
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Oops!'),
                      content: const Text(
                          'No se han otorgado los permisos necesarios para explorar los contactos.'),
                      actions: <Widget>[
                        FlatButton(
                          child: const Text('OK'),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  );
                }
              }),
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
      ),
    );
  }

  ListTile _buildListTile(Contact c, List<Item> list) {
    return ListTile(
      leading: (c.avatar != null)
          ? CircleAvatar(backgroundImage: MemoryImage(c.avatar))
          : CircleAvatar(
              child: Text((c.displayName[0] + c.displayName[1].toUpperCase()),
                  style: TextStyle(color: Colors.white)),
            ),
      title: Text(c.displayName ?? ""),
      subtitle: list.length >= 1 && list[0]?.value != null
          ? Text(list[0].value)
          : Text(''),
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
