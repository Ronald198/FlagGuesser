// ignore_for_file: non_constant_identifier_names, file_names, no_leading_underscores_for_local_identifiers
import 'dart:convert';

// ignore: no_leading_underscores_for_library_prefixes, depend_on_referenced_packages
import 'package:path/path.dart' as _path;
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';

class FlagPreset{
  final int? presetID;
  final String presetName;
  final List<String> flags;

  FlagPreset({ this.presetID, required this.presetName, required this.flags });

  factory FlagPreset.fromMap(Map<String, dynamic> _json) => FlagPreset(
    presetID: _json['presetID'],
    presetName: _json['presetName'],
    flags: List<String>.from(json.decode(_json['flags'])),
  );

  Map<String, dynamic> toMap(){
    return {
      'presetID': presetID,
      'presetName': presetName,
      'flags': flags,
    };
  }
}

class DatabaseManager{
  DatabaseManager._privateConstructor();
  static final DatabaseManager instance = DatabaseManager._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase(); //if database doesnt exist, initialize db, else use the exsiting db

  Future<Database> _initDatabase() async{
    var databasesPath = await getDatabasesPath();
    String path = _path.join(databasesPath, 'flagguesser.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }
 
  // For testing purposes
  // Future<void> deleteDatabase() async {
  //   var databasesPath = await getDatabasesPath();
  //   String path = _path.join(databasesPath, 'flagguesser.db');

  //   await databaseFactory.deleteDatabase(path);
  // }

  // For testing purposes
  // Future<bool> existsDatabase() async {
  //   var databasesPath = await getDatabasesPath();
  //   String path = _path.join(databasesPath, 'flagguesser.db');
  //   print(path);
  //   return await databaseFactory.databaseExists(path);
  // }

  Future _onCreate(Database db, int version) async{
    await db.execute('''
      CREATE TABLE FlagPresets(
        presetID INTEGER PRIMARY KEY,
        presetName TEXT,
        flags TEXT
      );
    ''');

    await db.execute('''
      INSERT INTO FlagPresets VALUES(1, 'CustomPreset1', '');
    ''');
  }

  Future<List<FlagPreset>> getAllPresets() async { //SELECT * FROM FlagPresets
    Database db = await instance.database;
    var productsRaw = await db.query('FlagPresets'); 
    List<FlagPreset> productsData = productsRaw.isNotEmpty ? productsRaw.map((e) => FlagPreset.fromMap(e)).toList() : [];
    return productsData;
  }

  Future<int> updateCustomPreset(String flags, int presetID) async {
    Database db = await instance.database;
    try {
      return await db.rawUpdate('UPDATE FlagPresets SET flags = ? WHERE presetID = ?', [flags, presetID]);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

      return 0;
    }
  }

  Future<FlagPreset?> getFlagPresetById(int id) async {
    Database db = await instance.database;
    try {
      var resultRaw = await db.rawQuery('SELECT * FROM FlagPresets WHERE presetID = ?', [id]); 
      List<FlagPreset> result= resultRaw.isNotEmpty ? resultRaw.map((e) => FlagPreset.fromMap(e)).toList() : [];
      return result.first;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

      return null;
    }
  }
}