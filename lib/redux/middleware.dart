import 'package:daruma/model/user.dart';
import 'package:daruma/redux/index.dart';
import 'package:daruma/redux/state.dart';
import 'package:daruma/services/repository/group.repository.dart';
import 'package:daruma/services/repository/member.repository.dart';
import 'package:daruma/services/repository/user.repository.dart';
import 'package:daruma/util/keys.dart';
import 'package:daruma/util/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();
final FacebookLogin facebookSignIn = new FacebookLogin();

middleware(Store<AppState> store, action, NextDispatcher next) {
  print(action.runtimeType);

  if (action is LoginWithGoogleAction) {
    _handleLoginWithGoogle(store, action, next);
  } else if (action is LoginWithFacebookAction) {
    _handleLoginWithFacebook(store, action, next);
  } else if (action is LogoutAction) {
    _handleLogoutAction(store, action);
  }

  next(action);
}

_handleLoginWithGoogle(Store<AppState> store, LoginWithGoogleAction action,
    NextDispatcher next) async {
  GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
  GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final AuthResult authResult = await _auth.signInWithCredential(credential);

  if (authResult.additionalUserInfo.isNewUser) {
    store.dispatch(UserIsNew(true));
    next(UserIsNew);
  }

  final FirebaseUser user = authResult.user;

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);

  final IdTokenResult token = await currentUser.getIdToken();

  UserRepository userRepository = new UserRepository();
  var systemUser = await userRepository.getUser(currentUser.uid, token.token);

  if (systemUser != null) {
    store.dispatch(
        UserLoadedAction(systemUser, currentUser.photoUrl, token.token));
  } else {
    User newUser = new User();
    newUser.userId = currentUser.uid;
    newUser.name = currentUser.displayName;
    newUser.email = currentUser.email;

    userRepository.createUser(newUser, token.token);

    store
        .dispatch(UserLoadedAction(newUser, currentUser.photoUrl, token.token));
  }

  action.completer.complete();
}

_handleLoginWithFacebook(Store<AppState> store, LoginWithFacebookAction action,
    NextDispatcher next) async {
final FacebookLoginResult result =
        await facebookSignIn.logInWithReadPermissions(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;

        AuthCredential credential =
            FacebookAuthProvider.getCredential(accessToken: accessToken.token);
        
        final authResult = await _auth.signInWithCredential(credential);

        if (authResult.additionalUserInfo.isNewUser) {
          store.dispatch(UserIsNew(true));
          next(UserIsNew);
        }

        final FirebaseUser user = authResult.user;

        assert(!user.isAnonymous);
        assert(await user.getIdToken() != null);

        final FirebaseUser currentUser = await _auth.currentUser();
        assert(user.uid == currentUser.uid);

        final IdTokenResult token = await currentUser.getIdToken();

        UserRepository userRepository = new UserRepository();
        var systemUser = await userRepository.getUser(currentUser.uid, token.token);

        if (systemUser != null) {
          store.dispatch(
              UserLoadedAction(systemUser, currentUser.photoUrl, token.token));
        } else {
          User newUser = new User();
          newUser.userId = currentUser.uid;
          newUser.name = currentUser.displayName;
          newUser.email = currentUser.email;

          userRepository.createUser(newUser, token.token);

          store
              .dispatch(UserLoadedAction(newUser, currentUser.photoUrl, token.token));

          action.completer.complete();          
        }

        break;
      case FacebookLoginStatus.cancelledByUser:
        print('Login cancelled by the user.');
        break;
      case FacebookLoginStatus.error:
        print('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        break;
    }
}

_handleLogoutAction(Store<AppState> store, LogoutAction action) async {
  await _googleSignIn.signOut();
}

ThunkAction loadGroup(String groupId, String tokenId) {
  GroupRepository _groupRepository = new GroupRepository();
  MemberRepository _memberRepository = new MemberRepository();

  return (Store store) async {
    new Future(() async {
      store.dispatch(new StartLoadingGroupAction());
      _groupRepository.getGroup(groupId, tokenId).then((group) async {
        var members = await _memberRepository.getMembers(groupId, tokenId);

        group = group.copyWith(members: members);
        store.dispatch(new LoadingGroupSuccessAction(group));
        Keys.navKey.currentState.pushNamed(Routes.groupPage);
      }, onError: (error) {
        store.dispatch(new LoadingGroupFailedAction());
      });
    });
  };
}
