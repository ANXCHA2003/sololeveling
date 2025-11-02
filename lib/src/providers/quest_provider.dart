import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/quest.dart';
import 'player_provider.dart';

final _uuid = Uuid();
const _questsPrefsKey = 'quests_v1';

List<Quest> _generateDaily() {
  final today = DateTime.now();
  return [
    Quest(
      id: _uuid.v4(),
      title: 'วิ่งเช้า',
      description: 'วิ่งเบา 20 นาที',
      xpReward: 20,
      completed: false,
      date: today,
      difficulty: QuestDifficulty.medium,
      category: 'ออกกำลังกาย',
    ),
    Quest(
      id: _uuid.v4(),
      title: 'Push-up',
      description: '3 เซ็ต 12 ครั้ง',
      xpReward: 10,
      completed: false,
      date: today,
      difficulty: QuestDifficulty.easy,
      category: 'ออกกำลังกาย',
    ),
    Quest(
      id: _uuid.v4(),
      title: 'ดื่มน้ำ 8 แก้ว',
      description: 'ดื่มน้ำให้ครบ 2 ลิตร',
      xpReward: 10,
      completed: false,
      date: today,
      difficulty: QuestDifficulty.easy,
      category: 'สุขภาพ',
    ),
  ];
}

class QuestNotifier extends StateNotifier<List<Quest>> {
  final Ref ref;
  QuestNotifier(this.ref) : super([]) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_questsPrefsKey);
    if (raw == null) {
      state = _generateDaily();
      _save();
      return;
    }

    try {
      final list = jsonDecode(raw) as List<dynamic>;
      state =
          list.map((e) => Quest.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      state = _generateDaily();
      _save();
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final list = state.map((q) => q.toJson()).toList();
    await prefs.setString(_questsPrefsKey, jsonEncode(list));
  }

  void addQuest(Quest quest) {
    state = [...state, quest];
    _save();
  }

  void deleteQuest(String id) {
    state = state.where((q) => q.id != id).toList();
    _save();
  }

  void updateQuest(Quest quest) {
    state = state.map((q) => q.id == quest.id ? quest : q).toList();
    _save();
  }

  void toggle(String id) {
    state =
        state.map((q) {
          if (q.id != id) return q;
          final toggled = q.copyWith(completed: !q.completed);
          if (toggled.completed) {
            // reward XP when completed
            ref.read(playerProvider.notifier).addXp(toggled.xpReward);
          }
          return toggled;
        }).toList();
    _save();
  }
}

final questProvider = StateNotifierProvider<QuestNotifier, List<Quest>>((ref) {
  return QuestNotifier(ref);
});
