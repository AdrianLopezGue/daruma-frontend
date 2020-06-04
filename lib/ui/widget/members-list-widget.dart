import 'package:daruma/model/group.dart';
import 'package:daruma/services/bloc/group-bloc.dart';
import 'package:daruma/services/networking/response.dart';
import 'package:daruma/util/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GroupsList extends StatelessWidget {
  final FirebaseUser user;
  final String idToken;

  GroupsList({this.user, this.idToken});

  Widget build(BuildContext context) {
    final GroupBloc _bloc = GroupBloc();
    _bloc.getGroups(idToken);

    return StreamBuilder<Response<List<Group>>>(
        stream: _bloc.groupStreamGroups,
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
                        itemCount: snapshot.data.data.length,
                        itemBuilder: (context, index) {
                          return Card(
                            color: redPrimaryColor,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                snapshot.data.data[index].name,
                                style: GoogleFonts.aBeeZee(
                                    fontSize: 22,
                                    textStyle: TextStyle(color: white)),
                              ),
                            ),
                          );
                        }));
                break;
              case Status.ERROR:
                return Card(
                  color: redPrimaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "No hay grupos:(",
                      style: GoogleFonts.aBeeZee(
                          fontSize: 22, textStyle: TextStyle(color: white)),
                    ),
                  ),
                );
                break;
            }
          }
          return Container();
        });
  }
}
