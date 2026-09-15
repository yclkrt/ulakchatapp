import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lingo_easy/lingo_easy.dart';
import 'package:ulakchatapp/core/features/auth/provider/auth_providers.dart';
import 'package:ulakchatapp/core/providers/firebase_providers.dart';
import 'package:ulakchatapp/core/router/app_router.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  Future<void> _signOut() async {
    await ref.read(authControllerProvider.notifier).signOut();
    if (!mounted) return;
    // authStateChanges redirect'i tetikler; garanti olması için manuel yönlendir.
    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final currentLang = context.currentLocale;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.ln('settings')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.language_rounded),
              title: Text(context.ln('language')),
              subtitle: Text(
                currentLang == 'tr' ? context.ln('turkish') : context.ln('english'),
              ),
              trailing: DropdownButton<String>(
                value: currentLang,
                underline: const SizedBox.shrink(),
                items: [
                  DropdownMenuItem(
                    value: 'tr',
                    child: Text(context.ln('turkish')),
                  ),
                  DropdownMenuItem(
                    value: 'en',
                    child: Text(context.ln('english')),
                  ),
                ],
                onChanged: (String? newLang) {
                  if (newLang != null) {
                    context.setLocale(newLang);
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.logout_rounded),
              title: const Text('Çıkış Yap'),
              subtitle: Text(ref.watch(authStateChangesProvider).valueOrNull?.email ?? ''),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: _signOut,
            ),
          ),
        ],
      ),
    );
  }
}

