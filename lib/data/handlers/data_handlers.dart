import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// DataHandlers Singleton class
class DataHandlers {
  static final DataHandlers _internalSingleton = DataHandlers._internal();
  factory DataHandlers() => _internalSingleton;
  DataHandlers._internal();

  Future<String> fetchJson(String path) async =>
      await rootBundle.loadString(path);

  Future<T> fetchJsonCompute<T>(
      String path, T Function(Map<String, dynamic>) fromJson) async {
    final jsonString = await rootBundle.loadString(path);
    final jsonResponse = await compute(json.decode, jsonString);
    if (jsonResponse is! Map<String, dynamic>) {
      throw Exception('JSON is not a Map<String, dynamic>');
    }
    final data = await compute(fromJson, jsonResponse);
    return data;
  }
}
