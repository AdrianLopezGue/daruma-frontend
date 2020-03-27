import 'package:daruma/model/group.dart';
import 'package:daruma/services/networking/index.dart';

class GroupRepository {
  ApiProvider _provider = ApiProvider();

  Future<Group> createGroup(Group group) async {
    final String parameterUrl = "/groups/";
    
    final response = await _provider.post(parameterUrl, group.convertToString());

    return response;
  }
}