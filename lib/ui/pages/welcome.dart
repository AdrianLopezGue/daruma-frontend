import 'package:daruma/redux/index.dart';
import 'package:daruma/ui/pages/create-group.dart';
import 'package:daruma/ui/widget/groups-list-widget.dart';
import 'package:daruma/util/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:daruma/ui/pages/login.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(converter: (store) {
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
    return Scaffold(
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
                                fontSize: 30,    
                                textStyle: TextStyle(color: black)                            
                                ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            vm.user.displayName,
                            style: GoogleFonts.aBeeZee(
                                fontSize: 20,    
                                textStyle: TextStyle(color: redPrimaryColor)                            
                                ),
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
                                fontWeight: FontWeight.bold                            
                                ),
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

