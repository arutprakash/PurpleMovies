import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yellow_movies/auth/models/user_model.dart';
import 'package:yellow_movies/auth/auth_status_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserProvider extends ChangeNotifier {
  UserModel currentUser = UserModel();
  FirebaseAuth auth = FirebaseAuth.instance;
  late Status authStatus;
  GoogleSignIn googleSignIn = GoogleSignIn();
  bool isAuthenticating = false;
  bool newNotif = false;

  UserProvider() {
    autoLogin();
  }

  void autoLogin() async {
    authStatus = Status.autoLogin;
    notifyListeners();
    var prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('userUid');
    print(uid);

    if (prefs.getString('firstTimeUser') != null) {
      if (uid != null) {
        if (await getUserData(uid)) {
          authStatus = Status.authenticated;
          await checkIfNotifExists();
        }
      } else {
        authStatus = Status.unauthenticated;
      }
    }
    print(authStatus);
    notifyListeners();
  }


  Future<bool> getUserCredsAfterSignIn(User firebaseUser) async {
    if (firebaseUser != null) {
      currentUser = UserModel.fromFirebaseUser(firebaseUser);
      await writeToDatabase();
      return true;
    } else
      return false;
  }

  Future<bool> getUserData(uid) async {
    bool isSuccessful = false;
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .get()
        .then((user) {
      currentUser = UserModel.fromJson(user.get(user));
      print(currentUser.name.toString() + "-------------------------------");
      isSuccessful = true;
    }).catchError((e) {
      print(e);
      isSuccessful = false;
    });
    return isSuccessful;
  }

  Future<void> writeToDatabase() async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser.uid)
        .set(currentUser.toJson());
    saveUserDataLocally();
  }

  void saveUserDataLocally() async {
    var prefs;
    prefs = await SharedPreferences.getInstance();
    prefs.setString('userUid', currentUser.uid);
  }

  Future<bool> logout() async {
    await auth.signOut();
    await googleSignIn.signOut();
    var prefs = await SharedPreferences.getInstance();
    authStatus = Status.unauthenticated;
    notifyListeners();
    return prefs.remove('userUid');
  }

  Future<void> googleAuth() async {
    isAuthenticating = true;
    notifyListeners();
    await googleSignIn.signOut();
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult =
    await auth.signInWithCredential(credential);
    final User? user = authResult.user;

    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User? currentUser = auth.currentUser;
      assert(user.uid == currentUser!.uid);

      print('signInWithGoogle succeeded: $user');

      if (!await checkIfUserExists(user.uid)) {
        print("new user");
        if (await getUserCredsAfterSignIn(user)) {
          Fluttertoast.showToast(msg : "Signed in Successfully");
          isAuthenticating = false;
          authStatus = Status.newUser;
          notifyListeners();
          await checkIfNotifExists();
          notifyListeners();
        } else {
          Fluttertoast.showToast(msg : "Something went wrong please try again");
          isAuthenticating = false;
          authStatus = Status.unauthenticated;
          notifyListeners();
        }
      } else {
        saveUserDataLocally();
        Fluttertoast.showToast(msg : "Signed in Successfully");
        isAuthenticating = false;
        authStatus = Status.authenticated;
        notifyListeners();
      }
    } else {
      Fluttertoast.showToast(msg : "Something went wrong please try again");
      authStatus = Status.unauthenticated;
      isAuthenticating = false;
      notifyListeners();
    }
  }

  Future<bool> checkIfUserExists(String uid) async {
    bool isExists = false;
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .get()
        .then((user) {
      if (user.exists) {
        currentUser = UserModel.fromJson(user.get(user));
        isExists = true;
      }
    });
    return isExists;
  }

  checkIfNotifExists() async {
    var prefs ;
    prefs = await SharedPreferences.getInstance();
    var timeStamp = 0;
    if(prefs.getString('arrivalTime')== null) timeStamp =0;
    else timeStamp = int.parse(prefs.getString('arrivalTime'));
    await FirebaseFirestore.instance
        .collection("Notifications")
        .where('arrivalTime',isGreaterThan: timeStamp)
        .limit(1)
        .get()
        .then((snap) {
      if (snap.docs.isNotEmpty) {
        newNotif = true;
      } else {
        newNotif = false;
      }
    });
    notifyListeners();
  }

}
