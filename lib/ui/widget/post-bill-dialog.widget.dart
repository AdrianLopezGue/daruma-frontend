import 'package:daruma/model/bill.dart';
import 'package:daruma/redux/state.dart';
import 'package:daruma/services/bloc/bill.bloc.dart';
import 'package:daruma/services/networking/index.dart';
import 'package:daruma/ui/pages/group-history.page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class PostBillDialog extends StatelessWidget {

  PostBillDialog();

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(converter: (store) {
      return new _ViewModel(
        bill: store.state.billState.bill,
        idToken: store.state.firebaseState.idTokenUser,
      );
    }, builder: (BuildContext context, _ViewModel vm) {
      return _postDialogView(context, vm);
    });
  }

  Widget _postDialogView(BuildContext context, _ViewModel vm) {
    final BillBloc _bloc = BillBloc();

    _bloc.postGroup(
        vm.bill,
        vm.idToken);

    return StreamBuilder<Response<bool>>(
        stream: _bloc.billStream,
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
                  child: Row(
                    children: <Widget>[
                      Text("Post completed!"),
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return GroupHistory();
                              },
                            ),
                          );
                        },
                        child: Text(
                          "Exit",
                        ),
                      )
                    ],
                  ),
                );
                break;
              case Status.ERROR:
                return Container(
                  height: 300.0, // Change as per your requirement
                  width: 300.0,
                  child: Row(
                    children: <Widget>[
                      Text("Post ERROR!"),
                      FlatButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: Text(
                          "Exit",
                        ),
                      )
                    ],
                  ),
                );
                break;
            }
          }
          return Container();
        });
  }
}

class _ViewModel {
  final Bill bill;
  final String idToken;

  _ViewModel({
    @required this.bill,
    @required this.idToken
  });
}
