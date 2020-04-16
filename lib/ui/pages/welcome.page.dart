import 'package:daruma/model/user.dart';
import 'package:daruma/redux/index.dart';
import 'package:daruma/services/dynamic_link/dynamic_links.dart';
import 'package:daruma/services/repository/user.repository.dart';
import 'package:daruma/ui/pages/create-group.page.dart';
import 'package:daruma/ui/widget/groups-list.widget.dart';
import 'package:daruma/util/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        UserRepository userRepository = new UserRepository();

        User user = new User();
        user.idUser = store.state.firebaseState.firebaseUser.uid;
        user.name = store.state.firebaseState.firebaseUser.displayName;
        user.email = store.state.firebaseState.firebaseUser.email;

        userRepository.createUser(user, store.state.firebaseState.idTokenUser);

        store.dispatch(UserIsNew(false));
      }
    }, converter: (store) {
      return new _ViewModel(
        user: store.state.firebaseState.firebaseUser,
        idToken: store.state.firebaseState.idTokenUser,
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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 40),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          'Bienvenido,',
                          style: GoogleFonts.aBeeZee(
                              fontSize: 30, textStyle: TextStyle(color: black)),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          vm.user.displayName,
                          style: GoogleFonts.aBeeZee(
                              fontSize: 20,
                              textStyle: TextStyle(color: redPrimaryColor)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 15.0),
              child: Row(
                children: <Widget>[
                  Text(
                    "Tus grupos",
                    style: GoogleFonts.aBeeZee(
                        fontSize: 25,
                        textStyle: TextStyle(color: black),
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Row(
                children: <Widget>[
                  GroupsList(user: vm.user, idToken: vm.idToken),
                ],
              ),
            ),
            RaisedButton(
              onPressed: () {
                vm.logout();
              },
              color: Colors.deepPurple,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Sign Out',
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
              ),
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
            )
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
}

class _ViewModel {
  final FirebaseUser user;
  final String idToken;
  final Function() logout;

  _ViewModel({
    @required this.user,
    @required this.idToken,
    @required this.logout,
  });
}
