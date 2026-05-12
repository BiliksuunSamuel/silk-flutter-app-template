import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:silk/core/storage/key_value_store.dart';

part 'prefs_store.g.dart';

@Riverpod(keepAlive: true)
Future<PrefsStore> prefsStore(PrefsStoreRef ref) async {
  final prefs = await SharedPreferences.getInstance();
  return PrefsStore(prefs);
}

class PrefsStore implements KeyValueStore {
  PrefsStore(this._prefs);

  final SharedPreferences _prefs;

  @override
  Future<String?> getString(String key) async => _prefs.getString(key);

  @override
  Future<void> setString(String key, String value) =>
      _prefs.setString(key, value);

  @override
  Future<void> remove(String key) async => _prefs.remove(key);

  @override
  Future<void> clear() async => _prefs.clear();
}
