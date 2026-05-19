import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../campaign_detail_screen.dart';

// ─── Mock Data ───────────────────────────────────────────────────────────────

class NotificationItem {
  final int id;
  final String title;
  final String subtitle;
  final String time;
  final bool isNew;
  final int? campaignId;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.time,
    this.isNew = false,
    this.campaignId,
  });
}

final _mockNotifications = [
  NotificationItem(
    id: 1,
    title: 'Campaign Baru!',
    subtitle: 'Kopi Nusantara membuka campaign baru "Summer Vibes" - Budget Rp 2.000.000',
    time: '2 jam yang lalu',
    isNew: true,
    campaignId: 1,
  ),
  NotificationItem(
    id: 2,
    title: 'Lamaran Diterima',
    subtitle: 'Brand Glow Skincare menerima lamaran campaign kamu',
    time: '5 jam yang lalu',
    isNew: true,
    campaignId: 2,
  ),
  NotificationItem(
    id: 3,
    title: 'Pembayaran Masuk',
    subtitle: 'Pembayaran campaign UrbanWear telah ditransfer ke rekening kamu',
    time: '1 hari yang lalu',
    isNew: false,
  ),
  NotificationItem(
    id: 4,
    title: 'Reminder Deadline',
    subtitle: 'Campaign TechGear ID deadline dalam 3 hari. Jangan lupa upload video!',
    time: '2 hari yang lalu',
    isNew: false,
    campaignId: 3,
  ),
  NotificationItem(
    id: 5,
    title: 'Review Baru',
    subtitle: 'Brand FreshMart memberikan rating 5 bintang untuk video kamu',
    time: '3 hari yang lalu',
    isNew: false,
  ),
  NotificationItem(
    id: 6,
    title: 'Campaign Selesai',
    subtitle: 'Campaign "Glow Skincare Review" telah selesai. Terima kasih!',
    time: '1 minggu yang lalu',
    isNew: false,
  ),
];

// ─── Main Screen ─────────────────────────────────────────────────────────────

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.darkText),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: AppColors.darkText,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              // Mark all as read
            },
            child: const Text(
              'Mark all read',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: _NotificationList(notifications: _mockNotifications),
    );
  }
}

class _NotificationList extends StatelessWidget {
  final List<NotificationItem> notifications;

  const _NotificationList({required this.notifications});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return _NotificationItem(
          notification: notification,
          onTap: () {
            if (notification.campaignId != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CampaignDetailScreen(
                    campaignId: notification.campaignId!,
                    heroTitle: notification.title,
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback onTap;

  const _NotificationItem({
    required this.notification,
    required this.onTap,
  });

  static const _iconColors = [
    Color(0xFF241A7A),  // Primary
    Color(0xFF3DAA6E),  // Success green
    Color(0xFF5BA6B0),  // Secondary
    Color(0xFFE09B3D),  // Warning
    Colors.pinkAccent,
    Colors.orange,
  ];

  static const _icons = [
    Icons.campaign_outlined,
    Icons.check_circle_outline,
    Icons.account_balance_wallet_outlined,
    Icons.schedule_outlined,
    Icons.star_outline,
    Icons.flag_outlined,
  ];

  Color get _iconColor => _iconColors[notification.id % _iconColors.length];
  IconData get _icon => _icons[notification.id % _icons.length];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon container
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _iconColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _icon,
                    color: _iconColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: notification.isNew ? FontWeight.w700 : FontWeight.w600,
                                color: AppColors.darkText,
                              ),
                            ),
                          ),
                          if (notification.isNew)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.subtitle,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.grayText,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        notification.time,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.lightGray,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        const Divider(height: 1, indent: 80, endIndent: 16),
      ],
    );
  }
}