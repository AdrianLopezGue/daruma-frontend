import 'package:daruma/model/transaction.dart';
import 'package:daruma/redux/state.dart';
import 'package:daruma/services/bloc/transaction.bloc.dart';
import 'package:daruma/services/networking/index.dart';
import 'package:daruma/ui/pages/group.page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class PostTransferDialog extends StatelessWidget {

  final Transaction transaction;

  PostTransferDialog({this.transaction});

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(converter: (store) {
      return new _ViewModel(
        idToken: store.state.userState.idTokenUser,
      );
    }, builder: (BuildContext context, _ViewModel vm) {
      return _postDialogView(context, vm);
    });
  }

  Widget _postDialogView(BuildContext context, _ViewModel vm) {
    final TransactionBloc _bloc = TransactionBloc();

    _bloc.postTransaction(
        this.transaction,
        vm.idToken);

    return StreamBuilder<Response<bool>>(
        stream: _bloc.transactionStream,
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
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return GroupPage();
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
  final String idToken;

  _ViewModel({
    @required this.idToken
  });
}
