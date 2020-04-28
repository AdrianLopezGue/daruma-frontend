import 'package:daruma/model/user.dart';
import 'package:daruma/redux/index.dart';
import 'package:daruma/services/dynamic_link/dynamic_links.dart';
import 'package:daruma/ui/pages/create-group.page.dart';
import 'package:daruma/ui/widget/groups-list.widget.dart';
import 'package:daruma/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:daruma/ui/pages/login.page.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    AppDynamicLinks.initDynamicLinks();
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(onInit: (store) {
      if (store.state.userIsNew == true) {
        store.dispatch(UserIsNew(false));
      }
    }, converter: (store) {
      return new _ViewModel(
        user: store.state.userState.user,
        photoUrl: store.state.userState.photoUrl,
        idToken: store.state.userState.idTokenUser,
        logout: () {
          store.dispatch(LogoutAction());
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) {
            return LoginPage();
          }), ModalRoute.withName('/'));
        },
      );
    }, builder: (BuildContext context, _ViewModel vm) {
      return _loginView(context, vm);
    });
  }

  Widget _loginView(BuildContext context, _ViewModel vm) {
    var scaffold = Scaffold(
      appBar: new AppBar(title: new Text("Daruma"), backgroundColor: redPrimaryColor, actions: <Widget>[
        PopupMenuButton<String>(
            onSelected: (choice) => handleClick(choice, context),
            itemBuilder: (BuildContext context) {
              return {'Crear grupo', 'Configuracion'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
      ],),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: redPrimaryColor,
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: redPrimaryColor,
                        backgroundImage: NetworkImage(vm.photoUrl),
                      )
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    children: <Widget>[
                      Text(
                        vm.user.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.0),
                  Row(children: <Widget>[
                    Text(
                        vm.user.email,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                  ],)
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Inicio'),
              onTap: (){
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configuración'),
            ),
            ListTile(
              leading: Icon(Icons.power_settings_new),
              title: Text('Cerrar sesión'),
              onTap: () {
                vm.logout();
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 25.0, top: 30.0),
              child: Row(
                children: <Widget>[
                  Text(
                    "Tus grupos",
                    style: GoogleFonts.roboto(
                        fontSize: 24, textStyle: TextStyle(color: black)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 25.0),
              child: Divider(
                color: black,
                endIndent: 25.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Row(
                children: <Widget>[
                  GroupsList(idToken: vm.idToken),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: redPrimaryColor,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return CreateGroupPage();
              },
            ),
          );
        },
      ),
    );
    return scaffold;
  }

  void handleClick(String value, BuildContext context) {
    switch (value) {
      case 'Crear grupo': {
        Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return CreateGroupPage();
              },
            ),
          );
      }
      break;
        
      case 'Configuración':
        break;
    }
}
}

class _ViewModel {
  final User user;
  final String photoUrl;
  final String idToken;
  final Function() logout;

  _ViewModel({
    @required this.user,
    @required this.photoUrl,
    @required this.idToken,
    @required this.logout,
  });
}
