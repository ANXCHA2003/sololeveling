import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/player_provider.dart';

class RegistrationPage extends ConsumerStatefulWidget {
  const RegistrationPage({super.key});

  @override
  ConsumerState<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends ConsumerState<RegistrationPage> {
  final _nameController = TextEditingController();
  String _selectedClass = 'Warrior';
  int _currentStep = 0;

  final _classes = {
    'Warrior': {
      'icon': '⚔️',
      'description': 'นักรบผู้แข็งแกร่ง\nโฟกัสพลังและความทนทาน',
      'stats': {'STR': 15, 'AGI': 8, 'INT': 7, 'VIT': 15},
    },
    'Assassin': {
      'icon': '🗡️',
      'description': 'มือสังหารที่รวดเร็ว\nโฟกัสความคล่องตัวและความแม่นยำ',
      'stats': {'STR': 10, 'AGI': 15, 'INT': 10, 'VIT': 10},
    },
    'Mage': {
      'icon': '🔮',
      'description': 'นักเวทย์ผู้ชาญฉลาด\nโฟกัสสติปัญญาและพลังเวทย์',
      'stats': {'STR': 7, 'AGI': 10, 'INT': 15, 'VIT': 8},
    },
    'Tank': {
      'icon': '🛡️',
      'description': 'ผู้พิทักษ์ที่แข็งแกร่ง\nโฟกัสการป้องกันและความทนทาน',
      'stats': {'STR': 12, 'AGI': 7, 'INT': 8, 'VIT': 18},
    },
  };

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _register() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('กรุณากรอกชื่อของคุณ')));
      return;
    }

    final stats = _classes[_selectedClass]!['stats'] as Map<String, int>;
    ref
        .read(playerProvider.notifier)
        .register(_nameController.text.trim(), _selectedClass);
    ref
        .read(playerProvider.notifier)
        .updateStats(
          strength: stats['STR'],
          agility: stats['AGI'],
          intelligence: stats['INT'],
          vitality: stats['VIT'],
        );

    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.8),
              Theme.of(context).colorScheme.secondary.withOpacity(0.6),
            ],
          ),
        ),
        child: SafeArea(
          child: Stepper(
            currentStep: _currentStep,
            onStepContinue: () {
              if (_currentStep == 0) {
                if (_nameController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('กรุณากรอกชื่อของคุณ')),
                  );
                  return;
                }
                setState(() => _currentStep = 1);
              } else {
                _register();
              }
            },
            onStepCancel: () {
              if (_currentStep > 0) {
                setState(() => _currentStep--);
              }
            },
            controlsBuilder: (context, details) {
              return Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: details.onStepContinue,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                      ),
                      child: Text(_currentStep == 1 ? 'เริ่มผจญภัย' : 'ถัดไป'),
                    ),
                    if (_currentStep > 0) ...[
                      const SizedBox(width: 12),
                      TextButton(
                        onPressed: details.onStepCancel,
                        child: const Text('ย้อนกลับ'),
                      ),
                    ],
                  ],
                ),
              );
            },
            steps: [
              Step(
                title: const Text('ข้อมูลผู้เล่น'),
                isActive: _currentStep >= 0,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ยินดีต้อนรับสู่โลกแห่งการผจญภัย!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'เริ่มต้นการเดินทางของคุณด้วยการสร้างตัวละคร',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'ชื่อของคุณ',
                        hintText: 'ใส่ชื่อที่คุณต้องการ',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                      ),
                      textCapitalization: TextCapitalization.words,
                    ),
                  ],
                ),
              ),
              Step(
                title: const Text('เลือกคลาส'),
                isActive: _currentStep >= 1,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'เลือกคลาสของคุณ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._classes.entries.map((entry) {
                      final isSelected = _selectedClass == entry.key;
                      final classData = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap:
                              () => setState(() => _selectedClass = entry.key),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? Theme.of(
                                        context,
                                      ).colorScheme.primaryContainer
                                      : Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color:
                                    isSelected
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  classData['icon'] as String,
                                  style: const TextStyle(fontSize: 40),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        entry.key,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        classData['description'] as String,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withOpacity(0.7),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Wrap(
                                        spacing: 8,
                                        children:
                                            (classData['stats']
                                                    as Map<String, int>)
                                                .entries
                                                .map(
                                                  (stat) => Chip(
                                                    label: Text(
                                                      '${stat.key}: ${stat.value}',
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    padding: EdgeInsets.zero,
                                                    visualDensity:
                                                        VisualDensity.compact,
                                                  ),
                                                )
                                                .toList(),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  Icon(
                                    Icons.check_circle,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    size: 32,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
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
