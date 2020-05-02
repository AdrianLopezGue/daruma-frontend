import 'dart:async';

import 'package:daruma/model/member.dart';
import 'package:daruma/services/networking/index.dart';
import 'package:daruma/services/repository/member.repository.dart';
import 'package:rxdart/rxdart.dart';

class MemberBloc {
  MemberRepository _memberRepository;
  StreamController _memberController;

  StreamSink<Response<bool>> get memberSink => _memberController.sink;
  Stream<Response<bool>> get memberStream => _memberController.stream;

  MemberBloc() {
    _memberController = BehaviorSubject<Response<bool>>();
    _memberRepository = MemberRepository();
  }

  addMember(Member member, String groupId, String idToken) async {
    memberSink.add(Response.loading('Add new member.'));
    try {
      bool memberResponse = await _memberRepository.addMember(member, groupId, idToken);
      memberSink.add(Response.completed(memberResponse));
    } catch (e) {
      memberSink.add(Response.error(e.toString()));
      print(e);
    }
  }

  deleteMember(String idMember, String idToken) async {
    memberSink.add(Response.loading('Delete member.'));
    try {
      bool memberResponse = await _memberRepository.deleteMember(idMember, idToken);
      memberSink.add(Response.completed(memberResponse));
    } catch (e) {
      memberSink.add(Response.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _memberController?.close();
  }
}