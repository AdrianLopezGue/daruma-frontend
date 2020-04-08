import 'package:daruma/model/currency-list.dart';
import 'package:daruma/services/bloc/currency-list-bloc.dart';
import 'package:daruma/services/networking/response.dart';
import 'package:flutter/material.dart';

class CurrenciesList extends StatefulWidget {
  final String currentCurrencyCode;
  final ValueChanged<String> selectedCurrency;

  CurrenciesList({Key key, this.currentCurrencyCode, this.selectedCurrency})
      : super(key: key);

  @override
  _CurrenciesListState createState() => _CurrenciesListState();
}

class _CurrenciesListState extends State<CurrenciesList> {
  CurrencyListBloc _bloc;
  String _selectedCurrency;

  @override
  void initState() {
    super.initState();
    _selectedCurrency = widget.currentCurrencyCode;
    _bloc = CurrencyListBloc();
  }

  @override
  Widget build(BuildContext context) {
    _bloc.fetchCurrencyList();

    return StreamBuilder<Response<CurrencyList>>(
        stream: _bloc.currencyListStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return Center(child: CircularProgressIndicator());
                break;

              case Status.COMPLETED:
                return Container(
                  height: 300.0, // Change as per your requirement
                  width: 300.0,
                  child: ListView.builder(
                      itemCount: snapshot.data.data.rates.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                            title: Text(snapshot.data.data.rates[index].name),
                            subtitle:
                                Text(snapshot.data.data.rates[index].code),
                            onTap: () {
                              setState(() {
                                _selectedCurrency =
                                    snapshot.data.data.rates[index].code;
                              });

                              widget.selectedCurrency(_selectedCurrency);
                              Navigator.pop(context, true);
                            });
                      }),
                );
                break;
              case Status.ERROR:
                return Center(child: CircularProgressIndicator());
                break;
            }
          }
          return Container();
        });
  }
}
