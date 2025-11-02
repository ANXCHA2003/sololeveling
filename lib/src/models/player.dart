class Player {
  final String name;
  final int level;
  final int xp;
  final int strength;
  final int agility;
  final int intelligence;
  final int vitality;
  final String? characterClass;
  final bool isRegistered;

  const Player({
    required this.name,
    required this.level,
    required this.xp,
    this.strength = 10,
    this.agility = 10,
    this.intelligence = 10,
    this.vitality = 10,
    this.characterClass,
    this.isRegistered = false,
  });

  Player copyWith({
    String? name,
    int? level,
    int? xp,
    int? strength,
    int? agility,
    int? intelligence,
    int? vitality,
    String? characterClass,
    bool? isRegistered,
  }) {
    return Player(
      name: name ?? this.name,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      strength: strength ?? this.strength,
      agility: agility ?? this.agility,
      intelligence: intelligence ?? this.intelligence,
      vitality: vitality ?? this.vitality,
      characterClass: characterClass ?? this.characterClass,
      isRegistered: isRegistered ?? this.isRegistered,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'level': level,
    'xp': xp,
    'strength': strength,
    'agility': agility,
    'intelligence': intelligence,
    'vitality': vitality,
    'characterClass': characterClass,
    'isRegistered': isRegistered,
  };

  factory Player.fromJson(Map<String, dynamic> json) => Player(
    name: json['name'] as String? ?? 'Rookie',
    level: json['level'] as int? ?? 1,
    xp: json['xp'] as int? ?? 0,
    strength: json['strength'] as int? ?? 10,
    agility: json['agility'] as int? ?? 10,
    intelligence: json['intelligence'] as int? ?? 10,
    vitality: json['vitality'] as int? ?? 10,
    characterClass: json['characterClass'] as String?,
    isRegistered: json['isRegistered'] as bool? ?? false,
  );

  @override
  String toString() => 'Player(name: $name, level: $level, xp: $xp)';
}
