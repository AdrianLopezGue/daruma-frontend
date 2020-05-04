import 'dart:async';

import 'package:daruma/model/member.dart';
import 'package:daruma/services/networking/index.dart';
import 'package:daruma/services/repository/member.repository.dart';
import 'package:rxdart/rxdart.dart';

class MemberBloc {
  MemberRepository _memberRepository;
  StreamController _memberController;
  StreamController _memberControllerMembers;

  StreamSink<Response<bool>> get memberSink => _memberController.sink;
  Stream<Response<bool>> get memberStream => _memberController.stream;

  StreamSink<Response<List<Member>>> get memberSinkMembers =>
      _memberControllerMembers.sink;
  Stream<Response<List<Member>>> get memberStreamMembers =>
      _memberControllerMembers.stream;

  MemberBloc() {
    _memberController = BehaviorSubject<Response<bool>>();
    _memberRepository = MemberRepository();
    _memberControllerMembers = BehaviorSubject<Response<List<Member>>>();
  }

  addMember(Member member, String groupId, String idToken) async {
    memberSink.add(Response.loading('Add new member.'));
    try {
      bool memberResponse =
          await _memberRepository.addMember(member, groupId, idToken);
      memberSink.add(Response.completed(memberResponse));
    } catch (e) {
      memberSink.add(Response.error(e.toString()));
      print(e);
    }
  }

  deleteMember(String idMember, String idToken) async {
    memberSink.add(Response.loading('Delete member.'));
    try {
      bool memberResponse =
          await _memberRepository.deleteMember(idMember, idToken);
      memberSink.add(Response.completed(memberResponse));
    } catch (e) {
      memberSink.add(Response.error(e.toString()));
      print(e);
    }
  }

  getMembers(String idGroup, String idToken) async {
    memberSinkMembers.add(Response.loading('Get members.'));
    try {
      List<Member> memberResponse =
          await _memberRepository.getMembers(idGroup, idToken);

      memberSinkMembers.add(Response.completed(memberResponse));
    } catch (e) {
      memberSinkMembers.add(Response.error(e.toString()));
      print(e);
    }
  }

  setUserIdToMember(String idMember, String idUser, String idToken) async {
    memberSink.add(Response.loading('Set User Id to member.'));
    try {
      bool memberResponse =
          await _memberRepository.setUserIdToMember(idMember, idUser, idToken);
      memberSink.add(Response.completed(memberResponse));
    } catch (e) {
      memberSink.add(Response.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _memberController?.close();
    _memberControllerMembers?.close();
  }
}
