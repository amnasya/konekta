import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import '../../campaign/campaign_detail_screen.dart';
import '../../campaign/campaign_room_screen.dart';
import 'new_campaign_screen.dart';
import '../../notification/notifications_screen.dart';

class BrandDashboardScreen extends StatelessWidget {
  const BrandDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KonektaColors.bg,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _Header(),
              const SizedBox(height: 18),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: _BrandEarningsCard(),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _StatCard(icon: Icons.trending_up, label: 'AVG. ENGAGEMENT', value: '4.8%', color: KonektaColors.primary),
                    SizedBox(width: 12),
                    _StatCard(icon: Icons.favorite_rounded, label: 'TOTAL INTERACTIONS (7D)', value: '60.2K', color: Color(0xFFE11D74)),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GradientMiniButton(
                  label: 'Create New Room',
                  icon: Icons.add_rounded,
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NewCampaignScreen())),
                ),
              ),
              const SizedBox(height: 22),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: _ActionNeed(),
              ),
              const SizedBox(height: 22),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: _ActiveRooms(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: KonektaColors.headerGradient),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      child: Row(
        children: [
          const Text('Konekta', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NotificationsScreen())),
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _BrandEarningsCard extends StatelessWidget {
  const _BrandEarningsCard();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(gradient: KonektaGradients.pillBlue, borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('THIS WEEK\'S AUDIENCE REACHED', style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
          const SizedBox(height: 6),
          const Text('1.250.400 Views', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Row(children: const [
            Icon(Icons.trending_up, color: Color(0xFF22C55E), size: 16),
            SizedBox(width: 4),
            Text('+12.5% from last week', style: TextStyle(color: Color(0xFF22C55E), fontSize: 12, fontWeight: FontWeight.w700)),
          ]),
          const SizedBox(height: 6),
          Text('Compared performance across all active creators.', style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 10)),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _StatCard({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: color, size: 14)),
              const SizedBox(width: 6),
              Expanded(child: Text(label, style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: KonektaColors.textMuted, letterSpacing: 0.5), maxLines: 2, overflow: TextOverflow.ellipsis)),
            ]),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: KonektaColors.textDark)),
          ],
        ),
      ),
    );
  }
}

class _ActiveRooms extends StatelessWidget {
  const _ActiveRooms();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(children: [
          Text('Active Rooms', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: KonektaColors.textDark)),
          Spacer(),
          Text('View All →', style: TextStyle(color: KonektaColors.primary, fontSize: 11, fontWeight: FontWeight.w800)),
        ]),
        const SizedBox(height: 12),
        _CampaignTile(name: 'Kopi Susu', daysLeft: '3 Days Left', status: 'IN PROGRESS', percent: 0.78, color: const Color(0xFF8B5E3C), target: 'Goal: 50,000 views and 5K engagement', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CampaignRoomScreen()))),
        _CampaignTile(name: 'Aula Skincare', daysLeft: '12 Days Left', status: 'IN PROGRESS', percent: 0.4, color: const Color(0xFFB6E2C8), target: 'Goal: 100,000 views and 10K engagement', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CampaignRoomScreen()))),
        _CampaignTile(name: 'NBA', daysLeft: '1 Days Left', status: 'COMPLETE', percent: 1.0, color: const Color(0xFFF5B7B1), target: 'Goal: 67,000 views and 6K engagement', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CampaignDetailScreen()))),
      ],
    );
  }
}

class _ActionNeed extends StatelessWidget {
  const _ActionNeed();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Action Need', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: KonektaColors.textDark)),
        const SizedBox(height: 10),
        _ActionItem(title: 'Influencers reached targets', subtitle: 'Review 12 successful campaigns', icon: Icons.star_rounded, color: const Color(0xFF1E3A8A)),
        const SizedBox(height: 10),
        _ActionItem(title: 'Pending Contract Approval', subtitle: '4 documents require signature', icon: Icons.gavel_rounded, color: const Color(0xFF0EA5E9)),
      ],
    );
  }
}

class _CampaignTile extends StatelessWidget {
  final String name, daysLeft, status, target;
  final double percent;
  final Color color;
  final VoidCallback? onTap;
  const _CampaignTile({required this.name, required this.daysLeft, required this.status, required this.percent, required this.target, required this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isComplete = percent >= 1;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Container(width: 40, height: 40, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10))),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: KonektaColors.textDark)),
                      Row(children: [
                        const Icon(Icons.schedule, size: 12, color: KonektaColors.textMuted),
                        const SizedBox(width: 4),
                        Text(daysLeft, style: const TextStyle(color: KonektaColors.textMuted, fontSize: 11)),
                      ]),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: isComplete ? const Color(0xFF1F2937) : const Color(0xFFDBEAFE), borderRadius: BorderRadius.circular(20)),
                  child: Text(status, style: TextStyle(color: isComplete ? Colors.white : KonektaColors.primary, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
                ),
              ]),
              const SizedBox(height: 12),
              const Text('Target', style: TextStyle(fontSize: 11, color: KonektaColors.textMuted, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: percent,
                  minHeight: 8,
                  backgroundColor: const Color(0xFFE5E7EB),
                  valueColor: AlwaysStoppedAnimation(isComplete ? const Color(0xFF22C55E) : KonektaColors.primary),
                ),
              ),
              const SizedBox(height: 6),
              Align(alignment: Alignment.centerRight, child: Text('${(percent * 100).toInt()}%', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: KonektaColors.textDark))),
              const SizedBox(height: 4),
              Text(target, style: const TextStyle(color: KonektaColors.textMuted, fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  final String title, subtitle;
  final IconData icon;
  final Color color;
  const _ActionItem({required this.title, required this.subtitle, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))]),
        child: Row(children: [
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: color)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: KonektaColors.textDark)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: KonektaColors.textMuted, fontSize: 11)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: KonektaColors.textMuted),
        ]),
      ),
    );
  }
}
