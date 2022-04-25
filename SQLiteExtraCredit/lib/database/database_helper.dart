import 'dart:async';
import 'dart:io' as io;

import 'package:artist_manager/database/model/user.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  static Database? _db;

  Future<Database?> get db async {
    // ignore: unnecessary_null_comparison
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "main.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE User(id INTEGER PRIMARY KEY, firstname TEXT, lastname TEXT, dob TEXT)");
  }

  Future<int> saveUser(User user) async {
    var dbClient = await db;
    int res = await dbClient!.insert("User", user.toMap());
    return res;
  }

  Future<List<User>> getUser() async {
    var dbClient = await db;
    List<Map> list = await dbClient!.rawQuery('SELECT * FROM User ORDER BY id ASC LIMIT 10' );
    List<User> employees = [];
    for (int i = 0; i < list.length; i++) {
      var user =
          User(list[i]["firstname"], list[i]["lastname"], list[i]["dob"]);
      user.setUserId(list[i]["id"]);
      employees.add(user);
    }
    // ignore: avoid_print
    print(employees.length);
    return employees;
  }

  Future<List<User>> getUserRange(int x, int y) async {
     var dbClient = await db;
      List<Map> list = await dbClient!.rawQuery('SELECT * FROM User WHERE id BETWEEN ' + x.toString() + ' and ' + y.toString() + ' GROUP BY id HAVING id >= 0 LIMIT ' + (x - y).toString() );
    List<User> employees = [];
    for (int i = 0; i < list.length; i++) {
      var user =
          User(list[i]["firstname"], list[i]["lastname"], list[i]["dob"]);
      user.setUserId(list[i]["id"]);
      employees.add(user);
    }
    // ignore: avoid_print
    print(employees.length);
    return employees;
  }

  Future<List<User>> findNUllUser() async {
    var dbClient = await db;
    List<Map> list = await dbClient!.rawQuery('SELECT * FROM User WHERE firstname = NULL' );
    List<User> employees = [];
    for (int i = 0; i < list.length; i++) {
      var user =
          User(list[i]["firstname"], list[i]["lastname"], list[i]["dob"]);
      user.setUserId(list[i]["id"]);
      employees.add(user);
    }
    // ignore: avoid_print
    print(employees.length);
    return employees;
  }

  Future<List<User>> getSpecificUser(String name) async {
    var dbClient = await db;
    List<Map> list = await dbClient!.rawQuery('SELECT * FROM User WHERE id = (SELECT id FROM User WHERE firstname = ' + name + ')' );
    List<User> employees = [];
    for (int i = 0; i < list.length; i++) {
      var user =
          User(list[i]["firstname"], list[i]["lastname"], list[i]["dob"]);
      user.setUserId(list[i]["id"]);
      employees.add(user);
    }
    // ignore: avoid_print
    print(employees.length);
    return employees;
  }

  Future<List<User>> checkSpecificUser(String name) async {
    var dbClient = await db;
    List<Map> list = await dbClient!.rawQuery('SELECT * FROM User WEHRE EXISTS (SELECT id FROM User WHERE firstname = ' + name + ')' );
    List<User> employees = [];
    for (int i = 0; i < list.length; i++) {
      var user =
          User(list[i]["firstname"], list[i]["lastname"], list[i]["dob"]);
      user.setUserId(list[i]["id"]);
      employees.add(user);
    }
    // ignore: avoid_print
    print(employees.length);
    return employees;
  }

  Future<List<User>> getTopFive() async {
    var dbClient = await db;
    List<Map> list = await dbClient!.rawQuery('SELECT * FROM User CASE id WHEN id > 5 THEN FALSE ELSE TRUE' );
    List<User> employees = [];
    for (int i = 0; i < list.length; i++) {
      var user =
          User(list[i]["firstname"], list[i]["lastname"], list[i]["dob"]);
      user.setUserId(list[i]["id"]);
      employees.add(user);
    }
    // ignore: avoid_print
    print(employees.length);
    return employees;
  }

  Future<int> deleteUsers(User user) async {
    var dbClient = await db;

    int res =
        await dbClient!.rawDelete('DELETE FROM User WHERE id = ?', [user.id]);
    return res;
  }

   Future<int> deleteUserRange(User user, int x, int y) async {
    var dbClient = await db;

    int res =
        await dbClient!.rawDelete('DELETE FROM User WHERE id IN (' + x.toString() + ', ' + y.toString() + ')', [user.id]);
    return res;
  }

   Future<int> deleteUsersWithS() async {
    var dbClient = await db;

    int res =
        await dbClient!.rawDelete('DELETE FROM User WHERE firstname LIKE s%');
    return res;
  }

  Future<int> deleteUserMan() async {
    var dbClient = await db;

    int res =
        await dbClient!.rawDelete('DELETE FROM User WHERE firstname GLOB Man*');
    return res;
  }

  Future<bool> update(User user) async {
    var dbClient = await db;
    int res =   await dbClient!.update("User", user.toMap(),
        where: "id = ?", whereArgs: <int>[user.id]);
    return res > 0 ? true : false;
  }
}