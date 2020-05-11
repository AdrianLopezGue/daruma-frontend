import 'package:daruma/model/group.dart';
import 'package:daruma/services/bloc/group.bloc.dart';
import 'package:daruma/services/networking/response.dart';
import 'package:daruma/ui/widget/group-button.widget.dart';
import 'package:daruma/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GroupsList extends StatelessWidget {
  final String tokenId;

  GroupsList({this.tokenId});

  Widget build(BuildContext context) {
    final GroupBloc _bloc = GroupBloc();
    _bloc.getGroups(tokenId);

    return StreamBuilder<Response<List<Group>>>(
        stream: _bloc.groupStreamGroups,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return Center(child: CircularProgressIndicator());
                break;

              case Status.COMPLETED:
                return Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.data.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0,
                              right: 25.0,
                              top: 8.0,
                              bottom: 8.0),
                          child: GroupButton(
                              groupId: snapshot.data.data[index].groupId,
                              name: snapshot.data.data[index].name),
                        );
                      }),
                );
                break;
              case Status.ERROR:
                return Card(
                  color: redPrimaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "No hay grupos:(",
                      style: GoogleFonts.roboto(
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
