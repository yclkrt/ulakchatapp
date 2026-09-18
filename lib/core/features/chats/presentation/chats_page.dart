import 'package:dynamic_responsive_screen/dynamic_responsive_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_easy/lingo_easy.dart';
import 'package:ulakchatapp/core/features/chats/data/mock_chats.dart';
import 'package:ulakchatapp/core/features/chats/widgets/chat_list_tile.dart';
import 'package:ulakchatapp/core/features/chats/widgets/chats_empty_state.dart';
import 'package:ulakchatapp/core/features/chats/widgets/chats_header.dart';
import 'package:ulakchatapp/core/features/chats/widgets/chats_search_bar.dart';
import 'package:ulakchatapp/core/theme/app_colors.dart';

class ChatsPage extends ConsumerStatefulWidget {
  const ChatsPage({super.key});
  @override
  ConsumerState<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends ConsumerState<ChatsPage> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onChatTap(String id) {}

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final card = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final all = MockChats.items;
    final totalUnread = all.fold<int>(0, (s, c) => s + c.unreadCount);
    final q = _query.trim().toLowerCase();
    final filtered = q.isEmpty
        ? all
        : all
              .where(
                (c) =>
                    c.name.toLowerCase().contains(q) ||
                    c.lastMessage.toLowerCase().contains(q),
              )
              .toList();
    return Scaffold(
      backgroundColor: bg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        clipBehavior: Clip.none,
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ChatsHeader(totalUnread: totalUnread),
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: -28,
                  child: ChatsSearchBar(
                    controller: _searchCtrl,
                    cardColor: card,
                    hint: context.ln('search_placeholder'),
                    onChanged: (v) => setState(() => _query = v),
                  ),
                ),
              ],
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 48)),
          if (filtered.isEmpty)
            SliverToBoxAdapter(
              child: ChatsEmptyState(
                title: context.ln(
                  q.isEmpty ? 'no_chats_title' : 'no_results_title',
                ),
                desc: context.ln(
                  q.isEmpty ? 'no_chats_desc' : 'no_results_desc',
                ),
                icon: q.isEmpty
                    ? Icons.forum_rounded
                    : Icons.search_off_rounded,
              ),
            )
          else
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                child: Container(
                  decoration: BoxDecoration(
                    color: card,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.06)
                          : AppColors.lightBorder,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: isDark ? 0.25 : 0.05,
                        ),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: filtered.length,
                    separatorBuilder: (_, i) => Divider(
                      height: 1,
                      indent: 83,
                      endIndent: 16,
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.06)
                          : AppColors.lightBorder,
                    ),
                    itemBuilder: (_, i) => ChatListTile(
                      chat: filtered[i],
                      cardColor: card,
                      onTap: () => _onChatTap(filtered[i].id),
                    ),
                  ),
                ),
              ),
            ),
          //? bottom menü height
          SliverToBoxAdapter(child: SizedBox(height: context.h(50))),
        ],
      ),
    );
  }
}
