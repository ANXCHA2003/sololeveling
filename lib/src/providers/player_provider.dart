import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/player.dart';

const _playerPrefsKey = 'player_v1';

int xpToLevel(int level) => 100 + (level - 1) * 25;

class PlayerNotifier extends StateNotifier<Player> {
  PlayerNotifier() : super(const Player(name: 'Rookie', level: 1, xp: 0)) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_playerPrefsKey);
    if (raw == null) return;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      state = Player.fromJson(map);
    } catch (_) {
      // ignore malformed data and keep defaults
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_playerPrefsKey, jsonEncode(state.toJson()));
  }

  void register(String name, String characterClass) {
    state = state.copyWith(
      name: name,
      characterClass: characterClass,
      isRegistered: true,
    );
    _save();
  }

  void updateStats({
    int? strength,
    int? agility,
    int? intelligence,
    int? vitality,
  }) {
    state = state.copyWith(
      strength: strength,
      agility: agility,
      intelligence: intelligence,
      vitality: vitality,
    );
    _save();
  }

  void addXp(int amount) {
    var newXp = state.xp + amount;
    var level = state.level;

    while (newXp >= xpToLevel(level)) {
      newXp -= xpToLevel(level);
      level++;
    }

    state = state.copyWith(level: level, xp: newXp);
    _save();
  }
}

final playerProvider = StateNotifierProvider<PlayerNotifier, Player>((ref) {
  return PlayerNotifier();
});
