import 'package:shared_preferences/shared_preferences.dart';

final class LocalStoreRepository {
  final SharedPreferences _ref;

  const LocalStoreRepository({required SharedPreferences ref}) : _ref = ref;

  Future<void> setData<T extends Object>(String key, T data) =>
      switch (data.runtimeType) {
        int => _ref.setInt(key, data as int),
        double => _ref.setDouble(key, data as double),
        String => _ref.setString(key, data as String),
        bool => _ref.setBool(key, data as bool),
        List => _ref.setStringList(key, data as List<String>),
        _ => _ref.reload(),
      };
      

  bool getBool(String key) => _ref.getBool(key) ?? false;

  double getDouble(String key) => _ref.getDouble(key) ?? 0;

  int getInt(String key) => _ref.getInt(key) ?? 0;

  String getString(String key) => _ref.getString(key) ?? '';

  bool checkKey(String key) => _ref.containsKey(key);

  Future<bool> removeKey(String key) => _ref.remove(key);

  List<String> getList(String key) => _ref.getStringList(key) ?? [];
}
