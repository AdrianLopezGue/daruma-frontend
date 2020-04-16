import 'dart:async';

import 'package:daruma/model/group.dart';
import 'package:daruma/services/networking/index.dart';
import 'package:daruma/services/repository/group.repository.dart';
import 'package:rxdart/rxdart.dart';

class GroupBloc {
  GroupRepository _groupRepository;
  StreamController _groupController;
  StreamController _groupControllerGroups;

  StreamSink<Response<bool>> get groupSink => _groupController.sink;
  Stream<Response<bool>> get groupStream => _groupController.stream;

  StreamSink<Response<List<Group>>> get groupSinkGroups =>
      _groupControllerGroups.sink;
  Stream<Response<List<Group>>> get groupStreamGroups =>
      _groupControllerGroups.stream;

  GroupBloc() {
    _groupController = BehaviorSubject<Response<bool>>();
    _groupRepository = GroupRepository();
    _groupControllerGroups = BehaviorSubject<Response<List<Group>>>();
  }

  postGroup(Group group, String idToken) async {
    groupSink.add(Response.loading('Post new group.'));
    try {
      bool groupResponse = await _groupRepository.createGroup(group, idToken);
      groupSink.add(Response.completed(groupResponse));
    } catch (e) {
      groupSink.add(Response.error(e.toString()));
      print(e);
    }
  }

  getGroups(String idToken) async {
    groupSinkGroups.add(Response.loading('Get groups.'));
    try {
      List<Group> groupResponse = await _groupRepository.getGroups(idToken);

      groupSinkGroups.add(Response.completed(groupResponse));
    } catch (e) {
      groupSinkGroups.add(Response.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _groupController?.close();
    _groupControllerGroups?.close();
  }
}
