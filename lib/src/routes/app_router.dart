import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/quest.dart';
import '../pages/home_page.dart';
import '../pages/status_page.dart';
import '../pages/classes_page.dart';
import '../pages/quests_page.dart';
import '../pages/registration_page.dart';
import '../pages/quest_form_page.dart';
import '../providers/player_provider.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final player = ref.watch(playerProvider);

  return GoRouter(
    initialLocation: player.isRegistered ? '/home' : '/',
    redirect: (context, state) {
      final isRegistered = player.isRegistered;
      final isOnRegistration = state.location == '/';

      if (!isRegistered && !isOnRegistration) {
        return '/';
      }
      if (isRegistered && isOnRegistration) {
        return '/home';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const RegistrationPage()),
      GoRoute(path: '/home', builder: (context, state) => const HomePage()),
      GoRoute(path: '/status', builder: (context, state) => const StatusPage()),
      GoRoute(
        path: '/classes',
        builder: (context, state) => const ClassesPage(),
      ),
      GoRoute(path: '/quests', builder: (context, state) => const QuestsPage()),
      GoRoute(
        path: '/quest-form',
        builder: (context, state) {
          final quest = state.extra as Quest?;
          return QuestFormPage(quest: quest);
        },
      ),
    ],
  );
});
