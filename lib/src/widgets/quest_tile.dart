import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/quest.dart';
import '../providers/quest_provider.dart';

class QuestTile extends ConsumerWidget {
  final Quest quest;

  const QuestTile({super.key, required this.quest});

  Color _getDifficultyColor(QuestDifficulty difficulty) {
    switch (difficulty) {
      case QuestDifficulty.easy:
        return Colors.green;
      case QuestDifficulty.medium:
        return Colors.blue;
      case QuestDifficulty.hard:
        return Colors.orange;
      case QuestDifficulty.epic:
        return Colors.purple;
    }
  }

  String _getCategoryIcon(String category) {
    switch (category) {
      case 'ออกกำลังกาย':
        return '💪';
      case 'การเรียน':
        return '📚';
      case 'งานบ้าน':
        return '🏠';
      case 'สุขภาพ':
        return '❤️';
      case 'งานอดิเรก':
        return '🎨';
      default:
        return '📋';
    }
  }

  void _showOptions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('แก้ไข'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/quest-form', extra: quest);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text('ลบ', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context);
                    ref.read(questProvider.notifier).deleteQuest(quest.id);
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('ลบเควสแล้ว')));
                  },
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: quest.completed ? 0 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: _getDifficultyColor(quest.difficulty).withOpacity(0.3),
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () => ref.read(questProvider.notifier).toggle(quest.id),
        onLongPress: () => _showOptions(context, ref),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color:
                      quest.completed
                          ? Colors.green.withOpacity(0.2)
                          : _getDifficultyColor(
                            quest.difficulty,
                          ).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  quest.completed
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color:
                      quest.completed
                          ? Colors.green
                          : _getDifficultyColor(quest.difficulty),
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(_getCategoryIcon(quest.category)),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            quest.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              decoration:
                                  quest.completed
                                      ? TextDecoration.lineThrough
                                      : null,
                              color:
                                  quest.completed
                                      ? Theme.of(
                                        context,
                                      ).colorScheme.onSurface.withOpacity(0.5)
                                      : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (quest.description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        quest.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.7),
                          decoration:
                              quest.completed
                                  ? TextDecoration.lineThrough
                                  : null,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getDifficultyColor(
                              quest.difficulty,
                            ).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '+${quest.xpReward} XP',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: _getDifficultyColor(quest.difficulty),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          quest.category,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
