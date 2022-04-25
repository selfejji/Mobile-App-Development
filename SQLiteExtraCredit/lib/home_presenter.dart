import 'package:artist_manager/database/database_helper.dart';
import 'package:artist_manager/database/model/user.dart';
import 'dart:async';

abstract class HomeContract {
  void screenUpdate();
}

class HomePresenter {
  final HomeContract _view;
  var db = DatabaseHelper();
  HomePresenter(this._view);
  delete(User user) {
    var db = DatabaseHelper();
    db.deleteUsers(user);
    updateScreen();
  }

  Future<List<User>> getUser() {
    return db.getUser();
  }

  updateScreen() {
    _view.screenUpdate();

  }
}