import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/product_model.dart';
import '../models/wishlist_item_model.dart';

class WishlistController {
  static Database? _db;

  String get _userId =>
      FirebaseAuth.instance.currentUser!.uid;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'wishlist.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, _) async {
        await db.execute('''
          CREATE TABLE wishlist (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userId TEXT,
            productId TEXT,
            name TEXT,
            price REAL,
            image TEXT
          )
        ''');
      },
    );
  }

  // 🔹 Add to wishlist
  Future<void> add(Product product) async {
    final db = await database;
    await db.insert(
      'wishlist',
      {
        'userId': _userId,
        'productId': product.id,
        'name': product.name,
        'price': product.price,
        'image': product.image,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // 🔹 Remove from wishlist
  Future<void> remove(String productId) async {
    final db = await database;
    await db.delete(
      'wishlist',
      where: 'productId = ? AND userId = ?',
      whereArgs: [productId, _userId],
    );
  }

  // 🔹 Check favorite
  Future<bool> isFavorite(String productId) async {
    final db = await database;
    final res = await db.query(
      'wishlist',
      where: 'productId = ? AND userId = ?',
      whereArgs: [productId, _userId],
    );
    return res.isNotEmpty;
  }

  // 🔹 Get wishlist for current user
  Future<List<WishlistItem>> getAll() async {
    final db = await database;
    final res = await db.query(
      'wishlist',
      where: 'userId = ?',
      whereArgs: [_userId],
    );

    return res.map((e) => WishlistItem(
      productId: e['productId'] as String,
      name: e['name'] as String,
      price: e['price'] as double,
      image: e['image'] as String,
    )).toList();
  }
}
