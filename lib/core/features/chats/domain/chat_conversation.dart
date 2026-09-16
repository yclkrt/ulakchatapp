import 'package:flutter/material.dart';

/// Basit sohbet modeli (şimdilik mock data, sonra Firestore'a bağlanacak).
class ChatConversation {
  final String id;
  final String name;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isOnline;
  final bool isPinned;
  final bool isMuted;
  final bool isGroup;
  final Color avatarColor;

  const ChatConversation({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
    this.isOnline = false,
    this.isPinned = false,
    this.isMuted = false,
    this.isGroup = false,
    required this.avatarColor,
  });

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts.first.characters.take(2).toString().toUpperCase();
    }
    return (parts[0].characters.first + parts[1].characters.first)
        .toUpperCase();
  }
}
