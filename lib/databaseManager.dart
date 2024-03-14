// ignore_for_file: non_constant_identifier_names, file_names, avoid_print, no_leading_underscores_for_local_identifiers
import 'dart:convert';

// ignore: no_leading_underscores_for_library_prefixes, depend_on_referenced_packages
import 'package:path/path.dart' as _path;
import 'package:sqflite/sqflite.dart';

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

  // Future<void> deleteDatabase() async {
  //   var databasesPath = await getDatabasesPath();
  //   String path = _path.join(databasesPath, 'easybar.db');

  //   await databaseFactory.deleteDatabase(path);
  // }

  // Future<bool> existsDatabase() async {
  //   var databasesPath = await getDatabasesPath();
  //   String path = _path.join(databasesPath, 'easybar.db');
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
      INSERT INTO FlagPresets VALUES(1, 'NotFound', '');
    ''');

    // await db.execute('''
    //   CREATE TABLE Receipts(
    //     receiptID INTEGER PRIMARY KEY,
    //     products BLOB,
    //     receiptDate INTEGER,
    //     receiptTotalPrice REAL,
    //     tableNr INTEGER
    //   );
    // ''');
  }

  Future<List<FlagPreset>> getAllPresets() async { //SELECT * FROM FlagPresets
    Database db = await instance.database;
    var productsRaw = await db.query('FlagPresets'); 
    List<FlagPreset> productsData = productsRaw.isNotEmpty ? productsRaw.map((e) => FlagPreset.fromMap(e)).toList() : [];
    return productsData;
  }

  // Future<int> insertNewProduct() async{ //INSERTS INTO FlagPresets(...) VALUES(of object)
  //   Database db = await instance.database;
  //   try {
  //     List<FlagPreset> products = await instance.getProductByName(product.productName);

  //     if(products.isNotEmpty) {
  //       return -1;
  //     }

  //     return await db.insert('Products', product.toMap());
  //   } catch (e) {
  //     print(e);
  //     return 0;
  //   }
  // }

  Future<int> updateCustomPreset(String flags, int presetID) async{
    Database db = await instance.database;
    try {
      return await db.rawUpdate('UPDATE FlagPresets SET flags = ? WHERE presetID = ?', [flags, presetID]);
    } catch (e) {
      print(e);
      return 0;
    }
  }

  // Future<void> getProductByName(String productName) async { //SELECT * FROM FlagPresets WHERE productName = ?
  //   Database db = await instance.database;
  //   var productsRaw = await db.rawQuery('SELECT * FROM Products WHERE productName = ?', [productName]); 
  //   List<Product> productsData = productsRaw.isNotEmpty ? productsRaw.map((e) => Product.fromMap(e)).toList() : [];
  //   return productsData;
  // }

  // Future<int> insertNewPhoto(Photo photo) async{ 
  //   Database db = await instance.database;
  //   try {
  //     return await db.insert('Photos', photo.toMap());
  //   } catch (e) {
  //     print(e);
  //     return 0;
  //   }
  // }

  Future<FlagPreset> getFlagPresetById(int id) async{ //SELECT * FROM Places WHERE placeName = ?
    Database db = await instance.database;
    try {
      var resultRaw = await db.rawQuery('SELECT * FROM FlagPresets WHERE presetID = ?', [id]); 
      List<FlagPreset> result= resultRaw.isNotEmpty ? resultRaw.map((e) => FlagPreset.fromMap(e)).toList() : [];
      return result.first;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // Future<List<Place>> getAllLikedPlaces() async{ //SELECT * FROM Places WHERE likedOrNot = 1
  //   Database db = await instance.database;
  //   try {
  //     var resultRaw = await db.rawQuery('SELECT * FROM Places WHERE likedOrNot = 1'); 
  //     List<Place> result= resultRaw.isNotEmpty ? resultRaw.map((e) => Place.fromMap(e)).toList() : [];
  //     return result;
  //   } catch (e) {
  //     print(e);
  //     rethrow;
  //   }
  // }

  // Future<Place> getPlaceByproductPrice(int productPrice) async{ //SELECT * FROM Places WHERE placeName = ?
  //   Database db = await instance.database;
  //   try {
  //     var resultRaw = await db.rawQuery('SELECT * FROM Places WHERE productPrice = ?', [productPrice]); 
  //     List<Place> result= resultRaw.isNotEmpty ? resultRaw.map((e) => Place.fromMap(e)).toList() : [];
  //     return result.first;
  //   } catch (e) {
  //     print(e);
  //     rethrow;
  //   }
  // }

  // Future<List<Photo>> getAllPhotosByproductPrice(int productPrice) async{ //SELECT * FROM Photos WHERE productPrice = ?
  //   Database db = await instance.database;
  //   try {
  //     var resultRaw = await db.rawQuery('SELECT * FROM Photos WHERE productPrice = ?', [productPrice]); 
  //     List<Photo> result= resultRaw.isNotEmpty ? resultRaw.map((e) => Photo.fromMap(e)).toList() : [];
  //     return result;
  //   } catch (e) {
  //     print(e);
  //     rethrow;
  //   }
  // }

  // Future<int> ratePlaceFromproductPrice(int? productPrice, double reviewPoints, int reviewCount) async{
  //   Database db = await instance.database;
  //   try {
  //     return await db.rawUpdate('UPDATE Places SET reviewPoints = ?, reviewCount = ? WHERE productPrice = ?', [reviewPoints, reviewCount, productPrice]);
  //   } catch (e) {
  //     print(e);
  //     return 0;
  //   }
  // }

  // Future<int> likeOrDislikeByproductPrice(int productPrice, int newValue) async{
  //   Database db = await instance.database;
  //   try {
  //     return await db.rawUpdate('UPDATE Places SET likedOrNot = ? WHERE productPrice = ?', [newValue, productPrice]);
  //   } catch (e) {
  //     print(e);
  //     return 0;
  //   }
  // }

  // Future<int> deletePlaceFromID(int? id) async{
  //   Database db = await instance.database;
  //   try {
  //     return await db.delete('Places', where: 'productPrice = ?', whereArgs: [id]);
  //   } catch (e) {
  //     print(e);
  //     return 0;
  //   }
  // }
}