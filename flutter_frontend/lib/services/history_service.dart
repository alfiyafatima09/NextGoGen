import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/file_history.dart';

class HistoryService {
  static const String _storageKey = 'file_upload_history';

  Future<void> addToHistory(FileHistory entry) async {
    final prefs = await SharedPreferences.getInstance();
    List<FileHistory> history = await getHistory();
    history.insert(0, entry); // Add new entry at the beginning

    // Store only last 50 entries
    if (history.length > 50) {
      history = history.sublist(0, 50);
    }

    final jsonList = history.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_storageKey, jsonList);
  }

  Future<List<FileHistory>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_storageKey) ?? [];

    return jsonList
        .map((str) => FileHistory.fromJson(jsonDecode(str)))
        .toList();
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}
