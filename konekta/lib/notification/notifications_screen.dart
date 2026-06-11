import 'package:flutter/material.dart';
import '../core/theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KonektaColors.background,
      appBar: AppBar(
        backgroundColor: KonektaColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: KonektaColors.textDark, size: 26),
          onPressed: () {},
        ),
        centerTitle: true,
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: KonektaColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Recent Update',
                        style: TextStyle(
                          color: KonektaColors.textDark,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'You have 2 unread notifications.',
                        style: TextStyle(
                          color: KonektaColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Mark all as read',
                      style: TextStyle(
                        color: KonektaColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _notificationCard(
                    isUnread: true,
                    iconWidget: const Icon(Icons.trending_up, color: Colors.white, size: 20),
                    iconBgColor: KonektaColors.primary,
                    title: 'Campaign Target Success',
                    time: 'Just now',
                    description: 'Congratulations! You accomplished the target for...',
                  ),
                  const SizedBox(height: 12),
                  _notificationCard(
                    isUnread: true,
                    iconWidget: const SizedBox(),
                    iconBgColor: KonektaColors.softBlue,
                    title: 'New Message from Malboro',
                    time: '2h ago',
                    description: '"Hey! We loved your recent post. We\'d like to discuss a potential...',
                  ),
                  _buildSectionDivider('YESTERDAY'),
                  _notificationCard(
                    isUnread: false,
                    iconWidget: const Icon(Icons.account_balance_wallet_outlined, color: KonektaColors.textSecondary, size: 20),
                    iconBgColor: KonektaColors.softBlue,
                    title: 'Payment Processed',
                    time: 'Yesterday',
                    description: 'Your payout of Rp125.000 for the \'Tech Review\' campaign has been',
                  ),
                  const SizedBox(height: 12),
                  _notificationCard(
                    isUnread: false,
                    iconWidget: const Icon(Icons.verified_user_outlined, color: KonektaColors.textSecondary, size: 20),
                    iconBgColor: KonektaColors.softBlue,
                    title: 'Profile Verification Complete',
                    time: 'Yesterday',
                    description: 'Your identity has been verified. You now have full access to apply',
                  ),
                  _buildSectionDivider('LAST WEEK'),
                  _notificationCard(
                    isUnread: false,
                    iconWidget: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        color: const Color(0xFFE5E7EB),
                        child: const Icon(Icons.image_search, color: KonektaColors.textMuted, size: 20),
                      ),
                    ),
                    iconBgColor: Colors.transparent,
                    title: 'Application Accepted',
                    time: 'Oct 12',
                    description: 'ViewSonic has accepted your contract to join campaign...',
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: Text(
                      "You're all caught up!",
                      style: TextStyle(
                        color: KonektaColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _notificationCard({
    required bool isUnread,
    required Widget iconWidget,
    required Color iconBgColor,
    required String title,
    required String time,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: KonektaColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isUnread)
                Container(
                  width: 4,
                  color: KonektaColors.primary,
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: iconBgColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(child: iconWidget),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: KonektaColors.textDark,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  time,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: KonektaColors.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                color: KonektaColors.textSecondary,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionDivider(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          Expanded(child: Divider(color: KonektaColors.border, thickness: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              label,
              style: TextStyle(
                color: KonektaColors.textMuted,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
          ),
          Expanded(child: Divider(color: KonektaColors.border, thickness: 1)),
        ],
      ),
    );
  }
}
