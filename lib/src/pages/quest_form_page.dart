import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../models/quest.dart';
import '../providers/quest_provider.dart';

const _uuid = Uuid();

class QuestFormPage extends ConsumerStatefulWidget {
  final Quest? quest;

  const QuestFormPage({super.key, this.quest});

  @override
  ConsumerState<QuestFormPage> createState() => _QuestFormPageState();
}

class _QuestFormPageState extends ConsumerState<QuestFormPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late QuestDifficulty _difficulty;
  late String _category;

  final _categories = [
    'ออกกำลังกาย',
    'การเรียน',
    'งานบ้าน',
    'สุขภาพ',
    'งานอดิเรก',
    'ทั่วไป',
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.quest?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.quest?.description ?? '',
    );
    _difficulty = widget.quest?.difficulty ?? QuestDifficulty.medium;
    _category = widget.quest?.category ?? 'ทั่วไป';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  int _getXpForDifficulty(QuestDifficulty difficulty) {
    switch (difficulty) {
      case QuestDifficulty.easy:
        return 10;
      case QuestDifficulty.medium:
        return 20;
      case QuestDifficulty.hard:
        return 35;
      case QuestDifficulty.epic:
        return 50;
    }
  }

  String _getDifficultyLabel(QuestDifficulty difficulty) {
    switch (difficulty) {
      case QuestDifficulty.easy:
        return 'ง่าย';
      case QuestDifficulty.medium:
        return 'ปานกลาง';
      case QuestDifficulty.hard:
        return 'ยาก';
      case QuestDifficulty.epic:
        return 'เอพิค';
    }
  }

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

  void _save() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('กรุณากรอกชื่อเควส')));
      return;
    }

    final quest = Quest(
      id: widget.quest?.id ?? _uuid.v4(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      xpReward: _getXpForDifficulty(_difficulty),
      completed: widget.quest?.completed ?? false,
      date: widget.quest?.date ?? DateTime.now(),
      difficulty: _difficulty,
      category: _category,
    );

    if (widget.quest == null) {
      ref.read(questProvider.notifier).addQuest(quest);
    } else {
      ref.read(questProvider.notifier).updateQuest(quest);
    }

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quest == null ? 'เพิ่มเควสใหม่' : 'แก้ไขเควส'),
        actions: [IconButton(icon: const Icon(Icons.check), onPressed: _save)],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'ชื่อเควส',
              hintText: 'เช่น วิ่งเช้า 30 นาที',
              prefixIcon: const Icon(Icons.flag),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
            ),
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: 'รายละเอียด',
              hintText: 'อธิบายเควสของคุณ',
              prefixIcon: const Icon(Icons.description),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
            ),
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 24),
          const Text(
            'หมวดหมู่',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                _categories.map((cat) {
                  final isSelected = _category == cat;
                  return FilterChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _category = cat);
                    },
                  );
                }).toList(),
          ),
          const SizedBox(height: 24),
          const Text(
            'ระดับความยาก',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...QuestDifficulty.values.map((diff) {
            final isSelected = _difficulty == diff;
            return RadioListTile<QuestDifficulty>(
              value: diff,
              groupValue: _difficulty,
              onChanged: (value) {
                if (value != null) {
                  setState(() => _difficulty = value);
                }
              },
              title: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: _getDifficultyColor(diff),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(_getDifficultyLabel(diff)),
                  const Spacer(),
                  Text(
                    '+${_getXpForDifficulty(diff)} XP',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              tileColor:
                  isSelected
                      ? Theme.of(
                        context,
                      ).colorScheme.primaryContainer.withOpacity(0.3)
                      : null,
            );
          }),
        ],
      ),
    );
  }
}
