import 'package:flutter/material.dart';
import '../domain/chat_conversation.dart';

class MockChats {
  MockChats._();

  static const List<ChatConversation> items = [
    ChatConversation(
      id: '1',
      name: 'Elif Yılmaz',
      lastMessage: 'Harika, yarın görüşürüz! 👋',
      time: '14:32',
      unreadCount: 2,
      isOnline: true,
      avatarColor: Color(0xFF00A896),
    ),
    ChatConversation(
      id: '2',
      name: 'Flutter Türkiye',
      lastMessage: 'Mert: Yeni sürüm çıktı mı?',
      time: '13:15',
      unreadCount: 12,
      isPinned: true,
      isGroup: true,
      avatarColor: Color(0xFF05668D),
    ),
    ChatConversation(
      id: '3',
      name: 'Ahmet Demir',
      lastMessage: 'Dosyaları gönderdim ✓✓',
      time: '11:48',
      isOnline: true,
      avatarColor: Color(0xFFF77F00),
    ),
    ChatConversation(
      id: '4',
      name: 'Aile Grubu',
      lastMessage: 'Anne: Akşam yemeğe gelin 🍲',
      time: 'Dün',
      isGroup: true,
      isMuted: true,
      avatarColor: Color(0xFF10B981),
    ),
    ChatConversation(
      id: '5',
      name: 'Zeynep Kaya',
      lastMessage: 'Sesli mesaj 🎤 0:42',
      time: 'Dün',
      unreadCount: 1,
      isOnline: false,
      avatarColor: Color(0xFF8B5CF6),
    ),
    ChatConversation(
      id: '6',
      name: 'Proje Ekibi',
      lastMessage: 'Sen: Tasarımı Figma’ya yükledim',
      time: 'Pzt',
      isGroup: true,
      avatarColor: Color(0xFF3B82F6),
    ),
    ChatConversation(
      id: '7',
      name: 'Can Öztürk',
      lastMessage: 'Maç kaç kaç bitti?',
      time: 'Pzt',
      isMuted: true,
      avatarColor: Color(0xFFEF4444),
    ),
  ];
}
