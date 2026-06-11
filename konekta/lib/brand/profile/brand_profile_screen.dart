import 'package:flutter/material.dart';
import '../../core/app_scope.dart';
import '../../auth/login_screen.dart';

class BrandProfileScreen extends StatelessWidget {
  const BrandProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = AppScope.of(context).session;
    final brandName = (session.name ?? '').isNotEmpty ? session.name! : 'Brand Name';

    return Scaffold(
      backgroundColor: const Color(0xFFEDF4FC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Logo Brand (Kotak Biru dengan sudut melengkung)
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: const Color(0xFF82B1EF),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 12),

              // 2. Nama Brand & Deskripsi
              Text(
                brandName,
                style: const TextStyle(
                  color: Color(0xFF2D2353),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Description Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit.',
                style: TextStyle(
                  color: Color(0xFF75749E),
                  fontSize: 14,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 24),

              // 3. Row Grid Statistik (3 Kolom)
              Row(
                children: [
                  Expanded(child: _buildStatCard('Creators Hired', '84', Icons.people_alt_rounded)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatCard('Total Reach', '2.4M', Icons.trending_up_rounded)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatCard('Campaigns\nCreated', '12', Icons.emoji_events_rounded)),
                ],
              ),
              const SizedBox(height: 32),

              // 4. Bagian Billing & Subscription
              _buildSectionHeader('Billing & Subscription'),
              const SizedBox(height: 12),
              _buildBillingCard(),
              const SizedBox(height: 32),

              // 5. Bagian Settings & Privacy
              _buildSectionHeader('Settings & Privacy'),
              const SizedBox(height: 12),
              _buildSettingsMenu(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF2D2353),
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFE3EFFD),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF4A90E2), size: 22),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF8E8EA9),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillingCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE3EFFD),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.account_balance_rounded, color: Color(0xFF4A90E2), size: 26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Konekta Pro Plan',
                  style: TextStyle(
                    color: Color(0xFF2D2353),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Manage your invoices & billing email',
                  style: TextStyle(color: Colors.grey[500], fontSize: 11),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFFC7C7D4), size: 14),
        ],
      ),
    );
  }

  Widget _buildSettingsMenu(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMenuTile(Icons.person_outline_rounded, 'Edit Profile'),
          _buildDivider(),
          _buildMenuTile(Icons.lock_open_rounded, 'Security'),
          _buildDivider(),
          _buildMenuTile(Icons.notifications_none_rounded, 'Notifications'),
          _buildDivider(),
          _buildMenuTile(Icons.help_outline_rounded, 'Help Center'),
          _buildDivider(),
          _buildMenuTile(
            Icons.logout_rounded,
            'Log Out',
            textColor: const Color(0xFFD02B49),
            iconColor: const Color(0xFFD02B49),
            showArrow: false,
            onTap: () {
              AppScope.of(context).session.clear();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (_) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile(
    IconData icon,
    String title, {
    Color textColor = const Color(0xFF2D2353),
    Color iconColor = const Color(0xFF75749E),
    bool showArrow = true,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (showArrow)
              const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFFC7C7D4), size: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 1,
      color: const Color(0xFFF3F3F8),
    );
  }
}
