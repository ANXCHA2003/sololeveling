enum QuestDifficulty { easy, medium, hard, epic }

class Quest {
  final String id;
  final String title;
  final String description;
  final int xpReward;
  final bool completed;
  final DateTime date;
  final QuestDifficulty difficulty;
  final String category;

  Quest({
    required this.id,
    required this.title,
    required this.description,
    required this.xpReward,
    required this.completed,
    required this.date,
    this.difficulty = QuestDifficulty.medium,
    this.category = 'ทั่วไป',
  });

  Quest copyWith({
    bool? completed,
    String? title,
    String? description,
    int? xpReward,
    QuestDifficulty? difficulty,
    String? category,
  }) {
    return Quest(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      xpReward: xpReward ?? this.xpReward,
      completed: completed ?? this.completed,
      date: date,
      difficulty: difficulty ?? this.difficulty,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'xpReward': xpReward,
    'completed': completed,
    'date': date.toIso8601String(),
    'difficulty': difficulty.index,
    'category': category,
  };

  factory Quest.fromJson(Map<String, dynamic> json) => Quest(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    xpReward: json['xpReward'] as int,
    completed: json['completed'] as bool,
    date: DateTime.parse(json['date'] as String),
    difficulty: QuestDifficulty.values[json['difficulty'] as int? ?? 1],
    category: json['category'] as String? ?? 'ทั่วไป',
  );
}
