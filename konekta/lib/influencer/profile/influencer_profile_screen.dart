import 'package:flutter/material.dart';
import '../../core/app_scope.dart';

class InfluencerProfileScreen extends StatelessWidget {
  const InfluencerProfileScreen({super.key});

  static const _avatarBg = Color(0xFFFFAEAE);
  static const _badgeBlue = Color(0xFF38B6FF);
  static const _textPrimary = Color(0xFF2D2353);
  static const _textMuted = Color(0xFF6B7280);
  static const _textLabel = Color(0xFF7A8B9E);
  static const _divider = Color(0xFFF3F4F6);
  static const _iconBlue = Color(0xFF1E75FF);
  static const _iconBlueSoft = Color(0xFFE8F1FF);
  static const _chevron = Color(0xFFB0B0D0);
  static const _danger = Color(0xFFDC2626);
  static const _bgScreen = Color(0xFFEFF5FA);

  @override
  Widget build(BuildContext context) {
    final session = AppScope.of(context).session;
    final name = (session.name ?? '').isNotEmpty ? session.name! : 'Username';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';

    return Scaffold(
      backgroundColor: _bgScreen,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Center(
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: const BoxDecoration(
                            color: _avatarBg,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            initial,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Positioned(
                          right: -2,
                          top: -2,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: _badgeBlue,
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
                            ),
                            child: const Icon(
                              Icons.verified_user_rounded,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: _textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Lifestyle creator - food, travel & honest reviews.\nAlways open to new collaborations.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: _textMuted, height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(icon: Icons.people_alt_outlined, label: 'Followers', value: '12.5K'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(icon: Icons.trending_up_rounded, label: 'Engagement', value: '4.2%'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(icon: Icons.emoji_events_outlined, label: 'Campaigns', value: '28'),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const _SectionTitle('Payout Configuration'),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.all(16),
                child: const Row(
                  children: [
                    _PayoutIcon(),
                    SizedBox(width: 16),
                    Expanded(child: _PayoutInfo()),
                    Icon(Icons.chevron_right_rounded, color: _chevron, size: 20),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const _SectionTitle('Settings & Privacy'),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: const [
                    _SettingsItem(icon: Icons.person_outline_rounded, title: 'Edit Profile'),
                    _SettingsItem(icon: Icons.lock_outline_rounded, title: 'Security'),
                    _SettingsItem(icon: Icons.notifications_none_rounded, title: 'Notifications'),
                    _SettingsItem(icon: Icons.help_outline_rounded, title: 'Help Center'),
                    _SettingsItem(
                      icon: Icons.logout_rounded,
                      title: 'Log Out',
                      iconColor: _danger,
                      textColor: _danger,
                      isLast: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _StatCard({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: Column(
        children: [
          Icon(icon, color: InfluencerProfileScreen._badgeBlue, size: 26),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: InfluencerProfileScreen._textLabel, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: InfluencerProfileScreen._textPrimary),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: InfluencerProfileScreen._textLabel),
    );
  }
}

class _PayoutIcon extends StatelessWidget {
  const _PayoutIcon();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: InfluencerProfileScreen._iconBlueSoft, borderRadius: BorderRadius.circular(14)),
      child: const Icon(Icons.account_balance_wallet_outlined, color: InfluencerProfileScreen._iconBlue, size: 24),
    );
  }
}

class _PayoutInfo extends StatelessWidget {
  const _PayoutInfo();
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bank Account Details',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: InfluencerProfileScreen._textPrimary),
        ),
        SizedBox(height: 4),
        Text('BCA · **** 8829', style: TextStyle(fontSize: 13, color: InfluencerProfileScreen._textLabel)),
      ],
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color iconColor;
  final Color textColor;
  final bool isLast;
  const _SettingsItem({
    required this.icon,
    required this.title,
    this.iconColor = InfluencerProfileScreen._iconBlue,
    this.textColor = InfluencerProfileScreen._textPrimary,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          leading: Icon(icon, color: iconColor, size: 22),
          title: Text(
            title,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: textColor),
          ),
          trailing: isLast
              ? null
              : const Icon(Icons.chevron_right_rounded, color: InfluencerProfileScreen._chevron, size: 20),
          onTap: () {},
        ),
        if (!isLast)
          const Padding(
            padding: EdgeInsets.only(left: 60, right: 20),
            child: Divider(color: InfluencerProfileScreen._divider, thickness: 1, height: 1),
          ),
      ],
    );
  }
}
