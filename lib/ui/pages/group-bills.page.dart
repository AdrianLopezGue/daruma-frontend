import 'package:daruma/ui/pages/bills-history.page.dart';
import 'package:daruma/ui/pages/recurring-bills.page.dart';
import 'package:daruma/util/colors.dart';
import 'package:flutter/material.dart';

class TabsExample extends StatelessWidget {
  const TabsExample({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _kTabPages = <Widget>[
      BillsHistory(),
      RecurringBills(),
    ];
    final _kTabs = <Tab>[
      Tab(child: Text('Historial', style: TextStyle(color: redPrimaryColor))),
      Tab(child: Text('Gastos recurrentes', style: TextStyle(color: redPrimaryColor))),
    ];
    return DefaultTabController(
      length: _kTabs.length,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 60),
          child: TabBar(
            indicatorColor: redPrimaryColor,
            tabs: _kTabs,
          ),
        ),
        body: TabBarView(
          children: _kTabPages,
        ),
      ),
    );
  }
}