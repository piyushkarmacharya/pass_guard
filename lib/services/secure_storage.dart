import "package:flutter_secure_storage/flutter_secure_storage.dart";
import 'package:flutter/material.dart';

class SecureStorage {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  store(String key, String value) async {
    await storage.write(key: key, value: value);
    debugPrint("stored in ss");
  }

  Future<String> read(String key) async {
    String value = await storage.read(key: key) ?? "no token";
    debugPrint("$key => $value");
    return value;
  }

  Future<Map<String, String>> readAll() async {
    Map<String, String> allValues = await storage.readAll();
    return allValues;
  }

  delete(String key) async {
    await storage.delete(key: key);
    debugPrint("deleted token");
  }

  deleteAll() async {
    await storage.deleteAll();
    debugPrint("deleted all token");
  }
}
