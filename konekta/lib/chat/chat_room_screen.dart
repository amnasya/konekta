import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/format.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({super.key});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final _controller = TextEditingController();
  final List<_ChatItem> _messages = [
    _ChatText(isOutgoing: true, text: 'Hi! We\'d like to discuss the upcoming campaign details with you.', time: '10:30 AM'),
    _ChatText(isOutgoing: false, text: 'Hello! Thank you for reaching out. I\'d love to hear more about the campaign.', time: '10:32 AM'),
    _ChatText(isOutgoing: true, text: 'We\'re planning a coffee-themed content series for next month. Budget is flexible based on your rate card.', time: '10:33 AM'),
    _ChatText(isOutgoing: false, text: 'That sounds amazing! I\'ve been following your brand for a while and would be happy to collaborate.', time: '10:35 AM'),
    _ChatText(isOutgoing: true, text: 'Great! Let me send over the brief document for your review.', time: '10:36 AM'),
    _ChatFile('Campaign_Brief_KopiSusu_Q3.pdf'),
    _ChatText(isOutgoing: false, text: 'Got it! I\'ll review the brief and get back to you by tomorrow with my proposal.', time: '10:40 AM'),
  ];

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_ChatText(isOutgoing: false, text: text, time: Format.chatTime(DateTime.now())));
      _controller.clear();
    });
    // Simulate reply after delay
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _messages.add(_ChatText(isOutgoing: true, text: 'Thanks for the update! I\'ll review everything and get back to you soon.', time: Format.chatTime(DateTime.now())));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: KonektaColors.surface,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: KonektaColors.textPrimary, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Kopi Susu Official', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: KonektaColors.textDark)),
            Text('Online', style: TextStyle(fontSize: 11, color: Color(0xFF22C55E))),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.videocam_rounded, color: KonektaColors.primary), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert_rounded, color: KonektaColors.textSecondary), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, i) {
                final item = _messages[i];
                if (item is _ChatFile) {
                  return _ChatFileAttachmentBubble(file: item.file);
                }
                return _MessageBubble(
                  isOutgoing: (item as _ChatText).isOutgoing,
                  text: (item as _ChatText).text,
                  time: (item as _ChatText).time,
                );
              },
            ),
          ),
          _ChatInputBar(controller: _controller, onSend: _send),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

abstract class _ChatItem {}

class _ChatText extends _ChatItem {
  final bool isOutgoing;
  final String text;
  final String time;
  _ChatText({required this.isOutgoing, required this.text, required this.time});
}

class _ChatFile extends _ChatItem {
  final String file;
  _ChatFile(this.file);
}

class _MessageBubble extends StatelessWidget {
  final bool isOutgoing;
  final String text;
  final String time;

  const _MessageBubble({required this.isOutgoing, required this.text, required this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: isOutgoing ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isOutgoing) ...[
            Container(width: 28, height: 28, decoration: BoxDecoration(color: const Color(0xFF8B5E3C), shape: BoxShape.circle), alignment: Alignment.center, child: Text('K', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700))),
            const SizedBox(width: 8),
          ],
          Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isOutgoing ? const Color(0xFFEFF5FF) : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(18),
                topRight: const Radius.circular(18),
                bottomLeft: Radius.circular(isOutgoing ? 18 : 4),
                bottomRight: Radius.circular(isOutgoing ? 4 : 18),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text, style: TextStyle(fontSize: 14, color: KonektaColors.textDark, height: 1.4)),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(time, style: TextStyle(fontSize: 10, color: KonektaColors.textMuted)),
                ),
              ],
            ),
          ),
          if (isOutgoing) const SizedBox(width: 8),
        ],
      ),
    );
  }
}

class _ChatFileAttachmentBubble extends StatelessWidget {
  final String file;
  const _ChatFileAttachmentBubble({required this.file});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.72,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE3E9F2))),
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: const Color(0xFFDBEAFE), borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.picture_as_pdf_rounded, color: Color(0xFF2563EB), size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(file, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: KonektaColors.textDark)),
                  const Text('2.4 MB', style: TextStyle(fontSize: 11, color: KonektaColors.textMuted)),
                ],
              ),
            ),
            const Icon(Icons.download_rounded, color: KonektaColors.primary, size: 20),
          ],
        ),
      ),
    );
  }
}

class _ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const _ChatInputBar({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, -2))]),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            IconButton(icon: const Icon(Icons.attach_file_rounded, color: KonektaColors.textMuted), onPressed: () {}),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(color: KonektaColors.bg, borderRadius: BorderRadius.circular(24)),
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF60A9FF), Color(0xFF246FE0)]), shape: BoxShape.circle),
              child: IconButton(icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20), onPressed: onSend),
            ),
          ],
        ),
      ),
    );
  }
}
