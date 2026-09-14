import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_easy/lingo_easy.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
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
        ],
      ),
    );
  }
}
