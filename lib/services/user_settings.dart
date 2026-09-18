import 'package:flutter/foundation.dart';
import 'split_engine.dart';

/// App settings model managing user preferences in memory.
/// Offline-first and privacy-focused: zero persistent analytics or third-party sync.
class UserSettings extends ChangeNotifier {
  static final UserSettings instance = UserSettings._internal();
  UserSettings._internal();

  double _defaultCap = 1999.0;
  TrancheStrategy _defaultStrategy = TrancheStrategy.maxCap;
  String _defaultPayerName = 'You';
  String _defaultNote = 'SplitPee bill split';
  bool _hapticsEnabled = true;

  double get defaultCap => _defaultCap;
  TrancheStrategy get defaultStrategy => _defaultStrategy;
  String get defaultPayerName => _defaultPayerName;
  String get defaultNote => _defaultNote;
  bool get hapticsEnabled => _hapticsEnabled;

  void setDefaultCap(double cap) {
    if (cap <= 0 || cap > 1999.0) return;
    _defaultCap = cap;
    notifyListeners();
  }

  void setDefaultStrategy(TrancheStrategy strategy) {
    _defaultStrategy = strategy;
    notifyListeners();
  }

  void setDefaultPayerName(String name) {
    _defaultPayerName = name.trim().isEmpty ? 'You' : name.trim();
    notifyListeners();
  }

  void setDefaultNote(String note) {
    _defaultNote = note.trim().isEmpty ? 'SplitPee bill split' : note.trim();
    notifyListeners();
  }

  void setHapticsEnabled(bool enabled) {
    _hapticsEnabled = enabled;
    notifyListeners();
  }

  void resetDefaults() {
    _defaultCap = 1999.0;
    _defaultStrategy = TrancheStrategy.maxCap;
    _defaultPayerName = 'You';
    _defaultNote = 'SplitPee bill split';
    _hapticsEnabled = true;
    notifyListeners();
  }
}
