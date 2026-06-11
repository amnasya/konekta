import 'package:flutter/material.dart';
import '../../core/theme.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  bool isAnnual = true;

  void _handlePurchase() {
    final messenger = ScaffoldMessenger.of(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        Future.delayed(const Duration(seconds: 1), () {
          if (!mounted) return;
          // ignore: use_build_context_synchronously
          Navigator.of(dialogContext).pop();
          messenger.showSnackBar(
            const SnackBar(content: Text('Redirecting to payment...')),
          );
        });
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KonektaColors.bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black.withValues(alpha: 0.54), size: 24),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: const [
            Text(
              'Konekta ',
              style: TextStyle(
                color: KonektaColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              'Pro',
              style: TextStyle(
                color: Color(0xFF1A3B70),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pro Upgrade Badge Tag
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD2E6FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.star_border, size: 14, color: Color(0xFF408CFF)),
                        SizedBox(width: 4),
                        Text(
                          'Pro Upgrade',
                          style: TextStyle(
                            color: Color(0xFF408CFF),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Main Title Header
                  const Text(
                    'Scale Your\nBrand Influence\nwith Konekta\nPro',
                    style: TextStyle(
                      color: Color(0xFF0F2547),
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      height: 1.15,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Subtitle Description
                  Text(
                    'Unlock unlimited campaign management, advanced creator filters, and seamless automated tracking.',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Features Container Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      children: [
                        _buildFeatureItem(
                          title: 'Maximized Campaign Reach',
                          desc: "Publish public campaigns that get pushed to the top of the influencers' explore feed.",
                        ),
                        const Divider(height: 24, thickness: 0.5),
                        _buildFeatureItem(
                          title: 'High-Capacity Campaign Rooms',
                          desc: 'Manage multiple active campaigns and recruit more creators.',
                        ),
                        const Divider(height: 24, thickness: 0.5),
                        _buildFeatureItem(
                          title: 'Premium Creator Directory',
                          desc: 'Access advanced filtering by niches, engagement rates, and verified creators.',
                        ),
                        const Divider(height: 24, thickness: 0.5),
                        _buildFeatureItem(
                          title: 'Enterprise-Grade Analytics',
                          desc: 'Export complete campaign data into PDF and CSV reports.',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Pricing Details Container Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      children: [
                        // Toggle Custom Tab (Monthly vs Annually)
                        Stack(
                          alignment: Alignment.topRight,
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              height: 40,
                              width: 240,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEBF2F9),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => setState(() => isAnnual = false),
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: !isAnnual ? Colors.white : Colors.transparent,
                                          borderRadius: BorderRadius.circular(20),
                                          boxShadow: !isAnnual
                                              ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)]
                                              : null,
                                        ),
                                        child: Text(
                                          'Monthly',
                                          style: TextStyle(
                                            color: !isAnnual ? Colors.black : Colors.grey.shade600,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => setState(() => isAnnual = true),
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          gradient: isAnnual
                                              ? const LinearGradient(colors: [Color(0xFF6AB6FC), Color(0xFF408CFF)])
                                              : null,
                                          borderRadius: BorderRadius.circular(20),
                                          boxShadow: isAnnual
                                              ? [BoxShadow(color: const Color(0xFF408CFF).withValues(alpha: 0.3), blurRadius: 6)]
                                              : null,
                                        ),
                                        child: Text(
                                          'Annually',
                                          style: TextStyle(
                                            color: isAnnual ? Colors.white : Colors.grey.shade600,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Badge Save 25%
                            Positioned(
                              top: -10,
                              right: -10,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFC67A00),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'Save 25%',
                                  style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),

                        // Best Value Label Text
                        const Text(
                          'BEST VALUE',
                          style: TextStyle(
                            color: Color(0xFF408CFF),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Plan Name Text
                        Text(
                          isAnnual ? 'Konekta Pro Annual' : 'Konekta Pro Monthly',
                          style: const TextStyle(
                            color: Color(0xFF1A3B70),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Big Price Layout
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            const Text(
                              'Rp ',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F2547),
                              ),
                            ),
                            Text(
                              isAnnual ? '225.000' : '299.000',
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF0F2547),
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              '/ month',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Small Under-text description
                        Text(
                          isAnnual ? 'Billed Rp 2.700.000 once a year.' : 'Billed monthly, cancel anytime.',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                        ),
                        const SizedBox(height: 20),

                        // Included Info Blue Container Box
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE5F1FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Icon(Icons.check_circle_outline, color: Color(0xFF408CFF), size: 18),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Includes Unlimited Rooms, Unlimited Creators, and Data Export features.',
                                  style: TextStyle(
                                    color: Color(0xFF1A3B70),
                                    fontSize: 11,
                                    height: 1.3,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Main Gradient Purchase Button
                        Container(
                          width: double.infinity,
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6AB6FC), Color(0xFF408CFF)],
                            ),
                          ),
                          child: ElevatedButton(
                            onPressed: _handlePurchase,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            child: Text(
                              isAnnual ? 'Go Pro Annual' : 'Go Pro Monthly',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Secure Transaction Row info
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.lock_outline, size: 14, color: Color(0xFF408CFF)),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                'Secure transaction guarantee via\nAutomated Virtual Account',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 11, height: 1.3),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Footer Section Area
            Container(
              width: double.infinity,
              color: const Color(0xFFF3F7FC),
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Column(
                children: [
                  const Text(
                    'Konekta Pro',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F2547)),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildFooterLink('Privacy Policy'),
                      _buildFooterDivider(),
                      _buildFooterLink('Terms of Service'),
                      _buildFooterDivider(),
                      _buildFooterLink('Help Center'),
                    ],
                  ),
                  const SizedBox(height: 14),
                      _buildFooterLink('Contact Support'),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.lock, size: 11, color: Color(0xFF408CFF)),
                      const SizedBox(width: 4),
                      Text(
                        '© 2024 Konekta Pro. Secure encrypted payments.',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Row Builder Helper for the bullet benefits
  Widget _buildFeatureItem({required String title, required String desc}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 2),
          padding: const EdgeInsets.all(2),
          decoration: const BoxDecoration(
            color: Color(0xFFE5F1FF),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: Color(0xFF408CFF), size: 14),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F2547)),
              ),
              const SizedBox(height: 4),
              Text(
                desc,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.3),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooterLink(String label) {
    return Text(
      label,
      style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.w500),
    );
  }

  Widget _buildFooterDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text('|', style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
    );
  }
}
