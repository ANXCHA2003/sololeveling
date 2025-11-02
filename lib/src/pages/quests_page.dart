import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/quest_provider.dart';
import '../widgets/quest_tile.dart';

class QuestsPage extends ConsumerWidget {
  const QuestsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quests = ref.watch(questProvider);
    final completedQuests = quests.where((q) => q.completed).length;
    final totalQuests = quests.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('เควสของฉัน'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/quest-form'),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primaryContainer,
                  Theme.of(context).colorScheme.secondaryContainer,
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.emoji_events, size: 40),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ความคืบหน้าวันนี้',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$completedQuests / $totalQuests เควสสำเร็จ',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                CircularProgressIndicator(
                  value: totalQuests > 0 ? completedQuests / totalQuests : 0,
                  backgroundColor: Colors.white24,
                  strokeWidth: 6,
                ),
              ],
            ),
          ),
          Expanded(
            child:
                quests.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.assignment_outlined,
                            size: 80,
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'ยังไม่มีเควส',
                            style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'กดปุ่ม + เพื่อเพิ่มเควสใหม่',
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    )
                    : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemCount: quests.length,
                      itemBuilder:
                          (context, index) => QuestTile(quest: quests[index]),
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                    ),
          ),
        ],
      ),
    );
  }
}
