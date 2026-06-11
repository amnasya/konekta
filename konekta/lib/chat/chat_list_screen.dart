import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/widgets.dart';
import '../core/format.dart';
import 'chat_room_screen.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KonektaColors.bg,
      appBar: AppBar(
        title: const Text('Chats', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: KonektaColors.textPrimary)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search chats…',
                  prefixIcon: const Icon(Icons.search_rounded, color: KonektaColors.textMuted, size: 20),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _ChatTile(
                    name: 'Kopi Susu Official',
                    avatarInitials: 'KS',
                    avatarColor: const Color(0xFF8B5E3C),
                    lastMsg: 'Hey! We have a new campaign idea for your next content.',
                    time: '2:30 PM',
                    unread: 2,
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ChatRoomScreen())),
                  ),
                  _ChatTile(
                    name: 'Aula Skincare',
                    avatarInitials: 'AS',
                    avatarColor: const Color(0xFFB6E2C8),
                    lastMsg: 'Thanks for the update! Let me review the draft.',
                    time: 'Yesterday',
                    unread: 0,
                    onTap: () {},
                  ),
                  _ChatTile(
                    name: 'NBA Indonesia',
                    avatarInitials: 'NB',
                    avatarColor: const Color(0xFFF5B7B1),
                    lastMsg: 'Campaign completed successfully! Great work.',
                    time: 'Jun 1',
                    unread: 0,
                    onTap: () {},
                  ),
                  _ChatTile(
                    name: 'Café Amazon',
                    avatarInitials: 'CA',
                    avatarColor: const Color(0xFF60A5FA),
                    lastMsg: 'Can we schedule a call tomorrow?',
                    time: 'May 28',
                    unread: 5,
                    onTap: () {},
                  ),
                  _ChatTile(
                    name: 'Indomaret',
                    avatarInitials: 'ID',
                    avatarColor: const Color(0xFFDC2626),
                    lastMsg: 'The campaign brief has been sent to your email.',
                    time: 'May 25',
                    unread: 0,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatTile extends StatelessWidget {
  final String name, avatarInitials, lastMsg, time;
  final Color avatarColor;
  final int unread;
  final VoidCallback onTap;

  const _ChatTile({
    required this.name,
    required this.avatarInitials,
    required this.avatarColor,
    required this.lastMsg,
    required this.time,
    required this.unread,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              AvatarPlaceholder(text: avatarInitials, size: 52, color: avatarColor),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: KonektaColors.textDark)),
                        Text(time, style: const TextStyle(fontSize: 11, color: KonektaColors.textMuted)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(lastMsg,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 13, color: unread > 0 ? KonektaColors.textDark : KonektaColors.textSecondary)),
                        ),
                        const SizedBox(width: 8),
                        if (unread > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(color: KonektaColors.primary, borderRadius: BorderRadius.circular(10)),
                            child: Text(unread.toString(), style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
                          ),
                      ],
                    ),
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
