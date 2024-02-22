import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/plan.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'plans.db');

    return await openDatabase(
      path,
      version: 2, // Veritabanı sürümünü güncelledik
      onCreate: (db, version) async {
        await db.execute('''
  CREATE TABLE plans(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    planName TEXT,
    location TEXT,
    area TEXT,
    selectedDate TEXT
  )
''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // Eski sürüm için güncelleme işlemleri buraya eklenebilir
        // Şu anda basit bir sürüm yükseltme işlemi yapıyoruz
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE plans ADD COLUMN selectedDate TEXT');
        }
      },
    );
  }

  Future<int> insertPlan(Plan plan) async {
    Database db = await database;
    return await db.insert('plans', plan.toMap());
  }

  Future<int> updatePlan(Plan plan) async {
    Database db = await this.database;
    return await db
        .update('plans', plan.toMap(), where: 'id = ?', whereArgs: [plan.id]);
  }

  Future<int> deletePlan(int id) async {
    Database db = await database;
    return await db.delete('plans', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Plan>> getAllPlans() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('plans');
    return List.generate(maps.length, (index) {
      return Plan.fromMap(maps[index]);
    });
  }

  Future<Plan?> getMatchingPlan(String cityName, DateTime selectedDate) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'plans',
      where: 'location = ? AND selectedDate = ?',
      whereArgs: [cityName, selectedDate.toString()],
    );
    if (maps.isEmpty) {
      return null;
    } else {
      return Plan.fromMap(maps.first);
    }
  }
}
