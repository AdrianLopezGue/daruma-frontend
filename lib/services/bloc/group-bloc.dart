import 'dart:async';

import 'package:daruma/model/group.dart';
import 'package:daruma/services/networking/index.dart';
import 'package:daruma/services/repository/group-repository.dart';
import 'package:rxdart/rxdart.dart';

class GroupBloc {
  GroupRepository _groupRepository;
  StreamController _groupController;

  StreamSink<Response<Group>> get groupSink => _groupController.sink;

  Stream<Response<Group>> get groupStream => _groupController.stream;

  GroupBloc() {
    _groupController = BehaviorSubject<Response<Group>>();
    _groupRepository = GroupRepository();
  }

  postGroup(Group group, String idToken) async {
    groupSink.add(Response.loading('Post new group.'));
    try {
      Group groupResponse = await _groupRepository.createGroup(group, idToken);

      groupSink.add(Response.completed(groupResponse));
    } catch (e) {
      groupSink.add(Response.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _groupController?.close();
  }
}
