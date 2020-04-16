import 'package:daruma/services/dynamic_link/dynamic_links.dart';
import 'package:daruma/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share/share.dart';

class GroupButton extends StatelessWidget {

  final String idGroup;
  final String name;

  const GroupButton({
    this.idGroup,
    this.name,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: redPrimaryColor,
      onPressed: () async {
        final RenderBox box = context.findRenderObject();
        final String urlLink = await getDynamicLinkForGroup(idGroup);
        Share.share(urlLink,
            sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          name,
          style: GoogleFonts.aBeeZee(
              fontSize: 22, textStyle: TextStyle(color: white)),
        ),
      ),
    );
  }

  Future<String> getDynamicLinkForGroup(String groupId) async{
    final AppDynamicLinks _appDynamicLinks = AppDynamicLinks();
    return _appDynamicLinks.createDynamicLink(groupId);
  }
}
