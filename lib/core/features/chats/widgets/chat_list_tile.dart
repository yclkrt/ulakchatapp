import 'package:flutter/material.dart';
import 'package:ulakchatapp/core/theme/app_colors.dart';
import '../domain/chat_conversation.dart';

class ChatListTile extends StatelessWidget {
  final ChatConversation chat;
  final Color cardColor;
  final VoidCallback onTap;
  const ChatListTile({
    super.key,
    required this.chat,
    required this.cardColor,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sub = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final hasUnread = chat.unreadCount > 0;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          child: Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          chat.avatarColor,
                          chat.avatarColor.withValues(alpha: 0.65),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: chat.isGroup
                        ? const Icon(
                            Icons.group_rounded,
                            color: Colors.white,
                            size: 26,
                          )
                        : Text(
                            chat.initials,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                  ),
                  if (chat.isOnline)
                    Positioned(
                      right: 1,
                      bottom: 1,
                      child: Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          color: AppColors.onlineStatus,
                          shape: BoxShape.circle,
                          border: Border.all(color: cardColor, width: 2.5),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (chat.isPinned)
                          const Padding(
                            padding: EdgeInsets.only(right: 5),
                            child: Icon(
                              Icons.push_pin_rounded,
                              size: 14,
                              color: AppColors.lightTextSecondary,
                            ),
                          ),
                        Expanded(
                          child: Text(
                            chat.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      chat.lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.5,
                        color: hasUnread
                            ? (isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.lightTextPrimary)
                            : sub,
                        fontWeight: hasUnread
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    chat.time,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w500,
                      color: hasUnread ? AppColors.primary : sub,
                    ),
                  ),
                  const SizedBox(height: 7),
                  if (hasUnread)
                    Container(
                      constraints: const BoxConstraints(minWidth: 22),
                      height: 22,
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.unreadBadge,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        chat.unreadCount > 99 ? '99+' : '${chat.unreadCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    )
                  else if (chat.isMuted)
                    Icon(
                      Icons.volume_off_rounded,
                      size: 17,
                      color: sub.withValues(alpha: 0.7),
                    )
                  else
                    const SizedBox(height: 22),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
