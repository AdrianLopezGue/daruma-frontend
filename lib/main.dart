import 'package:daruma/redux/index.dart';
import 'package:daruma/redux/store.dart';
import 'package:daruma/ui/pages/group.page.dart';
import 'package:daruma/util/keys.dart';
import 'package:daruma/util/routes.dart';
import 'package:flutter/material.dart';

import 'package:daruma/ui/pages/login.page.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final Store<AppState> store = createStore();

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: this.store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: Keys.navKey,
        routes: {
          Routes.groupPage:(context){
            return GroupPage();
          }
        },
        title: 'Flutter Login',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: LoginPage(),
      ),
    );
  }
}
