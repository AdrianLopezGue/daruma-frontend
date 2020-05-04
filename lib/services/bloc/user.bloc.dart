import 'dart:async';
import 'package:daruma/services/networking/index.dart';
import 'package:daruma/services/repository/user.repository.dart';
import 'package:rxdart/subjects.dart';

class UserBloc {
  UserRepository _userRepository;
  StreamController _userController;

  StreamSink<Response<bool>> get userSink => _userController.sink;

  Stream<Response<bool>> get userStream => _userController.stream;

  UserBloc() {
    _userController = BehaviorSubject<Response<bool>>();
    _userRepository = UserRepository();
  }

  updateUser(String userId, String name, String paypal, String tokenId) async {
    userSink.add(Response.loading('Update user.'));
    try {
      bool userResponse =
          await _userRepository.updateUser(userId, name, paypal, tokenId);
      userSink.add(Response.completed(userResponse));
    } catch (e) {
      userSink.add(Response.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _userController?.close();
  }
}
