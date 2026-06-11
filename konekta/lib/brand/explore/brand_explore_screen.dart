import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../chat/chat_list_screen.dart';
import '../../chat/chat_room_screen.dart';
import 'brand_view_profile_screen.dart';

class BrandExploreScreen extends StatelessWidget {
  const BrandExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KonektaColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                child: Row(
                  children: [
                    IconButton(onPressed: () {}, icon: const Icon(Icons.close, color: KonektaColors.textDark)),
                    const Text('Konekta', style: TextStyle(color: KonektaColors.textDark, fontSize: 16, fontWeight: FontWeight.w800)),
                    const Spacer(),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none_rounded, color: KonektaColors.textDark)),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: _ProBannerCard(),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _GradientButton(
                  label: 'Messages',
                  icon: Icons.chat_bubble_rounded,
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ChatListScreen())),
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: _SearchField(),
              ),
              const SizedBox(height: 12),
              ..._creatorList(context),
              const SizedBox(height: 16),
              Center(
                child: TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.expand_more_rounded),
                  label: const Text('SHOW MORE CREATORS', style: TextStyle(color: KonektaColors.textMuted, fontWeight: FontWeight.w800, fontSize: 12, letterSpacing: 0.8)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _creatorList(BuildContext context) {
    final items = List.generate(4, (i) => i);
    return items.map((i) => Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5E7EB))),
        child: Row(children: [
          Stack(children: [
            const CircleAvatar(radius: 22, backgroundColor: Color(0xFFFCA5A5)),
            if (i % 2 == 0)
              const Positioned(
                right: 0, top: 0,
                child: CircleAvatar(radius: 6, backgroundColor: Color(0xFF22C55E)),
              ),
          ]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Someone', style: TextStyle(fontWeight: FontWeight.w800, color: KonektaColors.textDark)),
                Text('Fashion style', style: TextStyle(color: KonektaColors.textMuted, fontSize: 11)),
                SizedBox(height: 2),
                Text('12k Followers · 5.5% Engagement', style: TextStyle(color: KonektaColors.textMuted, fontSize: 11)),
              ],
            ),
          ),
          Material(
            color: const Color(0xFFDBEAFE),
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const BrandViewProfileScreen())),
              child: const Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6), child: Text('View Profile', style: TextStyle(color: KonektaColors.primary, fontSize: 10, fontWeight: FontWeight.w800))),
            ),
          ),
        ]),
      ),
    )).toList();
  }
}

class _ProBannerCard extends StatelessWidget {
  const _ProBannerCard();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(gradient: KonektaColors.primaryGradient, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('PREMIUM TIER', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
                const SizedBox(height: 4),
                const Text('Konekta Pro', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text('Stand out to brands & unlock\nunlimited campaigns.', style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 11, height: 1.4)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {},
              child: const Padding(padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8), child: Text('Upgrade', style: TextStyle(color: KonektaColors.primary, fontWeight: FontWeight.w800, fontSize: 12))),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField();

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search by name or keyword',
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: const Icon(Icons.tune_rounded),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  const _GradientButton({required this.label, required this.icon, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: KonektaColors.primaryGradient, borderRadius: BorderRadius.circular(12)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13)),
          ])),
        ),
      ),
    );
  }
}
