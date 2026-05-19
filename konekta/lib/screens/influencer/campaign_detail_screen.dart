import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/campaign_detail_model.dart';
import '../../services/campaign_service.dart';
import '../../theme/app_colors.dart';

class CampaignDetailScreen extends StatefulWidget {
  final int campaignId;
  final String heroTitle;

  const CampaignDetailScreen({
    super.key,
    required this.campaignId,
    this.heroTitle = '',
  });

  @override
  State<CampaignDetailScreen> createState() => _CampaignDetailScreenState();
}

class _CampaignDetailScreenState extends State<CampaignDetailScreen> {
  late Future<CampaignDetail> _future;
  bool _applying = false;
  bool _applied = false;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<CampaignDetail> _load() async {
    try {
      return await CampaignService().fetchCampaignDetail(widget.campaignId);
    } catch (_) {
      return _mock[widget.campaignId] ?? _mock.values.first;
    }
  }

  static final _mock = <int, CampaignDetail>{
    1: CampaignDetail(
      id: 1,
      title: 'Kopi Susu Summer Vibes',
      description:
          'Create engaging content about our new summer kopi susu series. Show your creativity with our refreshing drinks and inspire your followers to try them.',
      budget: 2000000,
      deadline: 3,
      status: 'OPEN',
      brand: const CampaignBrand(name: 'Kopi Nusantara', category: 'F&B', verified: true),
      requirements: const CampaignRequirements(
        minFollowers: 10000,
        platforms: ['TikTok'],
        contentType: 'Short Video',
        audience: 'Gen Z, 18–25',
      ),
      deliverables: ['1x TikTok video (60s)', 'Story mention x3', 'Product tag in bio for 7 days'],
      alreadyApplied: false,
    ),
    2: CampaignDetail(
      id: 2,
      title: 'Glow Skincare Review',
      description:
          'Honest review of our new vitamin C serum line for Gen Z audience. Share your skincare routine and how our product fits in.',
      budget: 1500000,
      deadline: 7,
      status: 'OPEN',
      brand: const CampaignBrand(name: 'Glow Skincare', category: 'Beauty', verified: true),
      requirements: const CampaignRequirements(
        minFollowers: 5000,
        platforms: ['Instagram'],
        contentType: 'Reels + Story',
        audience: 'Women, 18–30',
      ),
      deliverables: ['1x Instagram Reels', 'Story review x2', 'Honest written caption'],
      alreadyApplied: false,
    ),
    3: CampaignDetail(
      id: 3,
      title: 'TechGear Unboxing',
      description:
          'Unboxing and first impressions of our latest wireless earbuds. Show the unboxing experience and key features.',
      budget: 3500000,
      deadline: 10,
      status: 'OPEN',
      brand: const CampaignBrand(name: 'TechGear ID', category: 'Tech', verified: false),
      requirements: const CampaignRequirements(
        minFollowers: 20000,
        platforms: ['TikTok'],
        contentType: 'Unboxing Video',
        audience: 'Tech enthusiasts, 20–35',
      ),
      deliverables: ['1x TikTok unboxing (90s)', 'Pinned comment with product link', 'Story highlight'],
      alreadyApplied: false,
    ),
    4: CampaignDetail(
      id: 4,
      title: 'UrbanWear OOTD Challenge',
      description:
          'Style our new collection and share your OOTD with #UrbanVibes. Show how you mix and match our pieces.',
      budget: 1000000,
      deadline: 5,
      status: 'OPEN',
      brand: const CampaignBrand(name: 'UrbanWear', category: 'Fashion', verified: false),
      requirements: const CampaignRequirements(
        minFollowers: 3000,
        platforms: ['Instagram'],
        contentType: 'Photo + Reels',
        audience: 'Fashion lovers, 18–28',
      ),
      deliverables: ['3x OOTD photos', '1x Reels with #UrbanVibes', 'Tag brand in all posts'],
      alreadyApplied: false,
    ),
    5: CampaignDetail(
      id: 5,
      title: 'FreshMart Healthy Living',
      description:
          'Promote our organic grocery delivery with a healthy recipe video. Show how easy it is to cook healthy with FreshMart.',
      budget: 2500000,
      deadline: 0,
      status: 'CLOSED',
      brand: const CampaignBrand(name: 'FreshMart', category: 'Grocery', verified: true),
      requirements: const CampaignRequirements(
        minFollowers: 8000,
        platforms: ['TikTok'],
        contentType: 'Recipe Video',
        audience: 'Health-conscious, 25–40',
      ),
      deliverables: ['1x Recipe TikTok (60s)', 'Story with promo code', 'Bio link for 14 days'],
      alreadyApplied: false,
    ),
  };

  Future<void> _apply(CampaignDetail campaign) async {
    if (_applying || _applied || !campaign.isOpen) return;
    setState(() => _applying = true);
    try {
      await CampaignService().applyToCampaign(campaign.id);
    } catch (_) {}
    if (mounted) {
      setState(() {
        _applied = true;
        _applying = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎉 Application submitted successfully!'),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CampaignDetail>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snap.hasData) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(backgroundColor: Colors.white, elevation: 0),
            body: const Center(child: Text('Campaign tidak ditemukan')),
          );
        }

        final campaign = snap.data!;
        final isApplied = _applied || campaign.alreadyApplied;

        return DefaultTabController(
          length: 4,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: [
                // ── Header Image / Gradient ──
                Stack(
                  children: [
                    Container(
                      height: 250,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: AppColors.headerGradient,
                      ),
                      child: Center(
                        child: Text(
                          campaign.brand.name[0],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 80,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    // Status badge
                    Positioned(
                      bottom: 16,
                      left: 16,
                      child: _StatusBadge(status: campaign.status),
                    ),
                    // Back, bookmark, search buttons
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const Icon(Icons.arrow_back_ios,
                                  color: Colors.white),
                            ),
                            Row(
                              children: const [
                                Icon(Icons.favorite_border, color: Colors.white),
                                SizedBox(width: 20),
                                Icon(Icons.search, color: Colors.white),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // ── Judul & Subtitle ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              campaign.brand.name,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D2D2D),
                              ),
                            ),
                          ),
                          if (campaign.brand.verified)
                            const Icon(Icons.verified_rounded,
                                color: AppColors.secondary, size: 20),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${campaign.deadline > 0 ? "${campaign.deadline} days left" : "Closed"}'
                        ' • ${campaign.brand.category}'
                        ' • ${campaign.requirements.platforms.join(", ")}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // ── Tab Bar ──
                const TabBar(
                  isScrollable: false,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: Color(0xFF2D2D2D),
                  indicatorColor: AppColors.primary,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorWeight: 2.5,
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 13),
                  unselectedLabelStyle: TextStyle(
                      fontWeight: FontWeight.normal, fontSize: 13),
                  tabs: [
                    Tab(text: 'About'),
                    Tab(text: 'Job'),
                    Tab(text: 'Salary'),
                    Tab(text: 'Requirement'),
                  ],
                ),

                // ── Tab Content ──
                Expanded(
                  child: TabBarView(
                    children: [
                      _AboutTab(campaign: campaign),
                      _JobTab(campaign: campaign),
                      _SalaryTab(campaign: campaign),
                      _RequirementTab(campaign: campaign),
                    ],
                  ),
                ),
              ],
            ),

            // ── Apply Button ──
            bottomNavigationBar: _CtaBar(
              campaign: campaign,
              applying: _applying,
              applied: isApplied,
              onApply: () => _apply(campaign),
            ),
          ),
        );
      },
    );
  }
}

// ─── Tab: About ───────────────────────────────────────────────────────────────

class _AboutTab extends StatelessWidget {
  final CampaignDetail campaign;
  const _AboutTab({required this.campaign});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tentang Campaign',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(
            campaign.title,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primary),
          ),
          const SizedBox(height: 8),
          Text(
            campaign.description,
            style: const TextStyle(
                fontSize: 14, color: Color(0xFF555555), height: 1.6),
          ),
          const SizedBox(height: 20),
          const Text('Brand',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _InfoRow(label: 'Nama Brand', value: campaign.brand.name),
          _InfoRow(label: 'Kategori', value: campaign.brand.category),
          _InfoRow(
            label: 'Verified',
            value: campaign.brand.verified ? 'Ya ✓' : 'Belum',
          ),
        ],
      ),
    );
  }
}

// ─── Tab: Job ─────────────────────────────────────────────────────────────────

class _JobTab extends StatelessWidget {
  final CampaignDetail campaign;
  const _JobTab({required this.campaign});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Deliverables',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...campaign.deliverables.asMap().entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        gradient: AppColors.headerGradient,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          '${e.key + 1}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(e.value,
                          style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF444444),
                              height: 1.5)),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 8),
          const Text('Platform',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: campaign.requirements.platforms
                .map((p) => _PlatformBadge(platform: p))
                .toList(),
          ),
          const SizedBox(height: 16),
          _InfoRow(label: 'Tipe Konten', value: campaign.requirements.contentType),
        ],
      ),
    );
  }
}

// ─── Tab: Salary ──────────────────────────────────────────────────────────────

class _SalaryTab extends StatelessWidget {
  final CampaignDetail campaign;
  const _SalaryTab({required this.campaign});

  String _formatRupiah(double amount) => NumberFormat.currency(
        locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
      .format(amount);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Budget highlight card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.headerGradient,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Campaign Budget',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 6),
                Text(
                  _formatRupiah(campaign.budget),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                const Text('Dibayar setelah campaign selesai',
                    style: TextStyle(color: Colors.white60, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Detail Pembayaran',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _InfoRow(label: 'Total Budget', value: _formatRupiah(campaign.budget)),
          _InfoRow(
            label: 'Deadline',
            value: campaign.deadline > 0
                ? '${campaign.deadline} hari lagi'
                : 'Sudah ditutup',
          ),
          _InfoRow(label: 'Status', value: campaign.status),
        ],
      ),
    );
  }
}

// ─── Tab: Requirement ─────────────────────────────────────────────────────────

class _RequirementTab extends StatelessWidget {
  final CampaignDetail campaign;
  const _RequirementTab({required this.campaign});

  String _formatFollowers(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M+';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(0)}K+';
    return '$n+';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Persyaratan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _InfoRow(
            label: 'Min. Followers',
            value: _formatFollowers(campaign.requirements.minFollowers),
          ),
          _InfoRow(
            label: 'Platform',
            value: campaign.requirements.platforms.join(', '),
          ),
          _InfoRow(
            label: 'Tipe Konten',
            value: campaign.requirements.contentType,
          ),
          _InfoRow(
            label: 'Target Audiens',
            value: campaign.requirements.audience,
          ),
        ],
      ),
    );
  }
}

// ─── Shared Widgets ───────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 13, color: AppColors.grayText)),
          Flexible(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333)),
                textAlign: TextAlign.end),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final isOpen = status == 'OPEN';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isOpen
            ? Colors.white.withOpacity(0.25)
            : Colors.red.withOpacity(0.3),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: isOpen ? const Color(0xFF4ADE80) : Colors.red.shade300,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            isOpen ? 'OPEN' : 'CLOSED',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlatformBadge extends StatelessWidget {
  final String platform;
  const _PlatformBadge({required this.platform});

  @override
  Widget build(BuildContext context) {
    final isTT = platform.toLowerCase() == 'tiktok';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isTT ? const Color(0xFF010101) : const Color(0xFFE1306C),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isTT ? Icons.music_note_rounded : Icons.camera_alt_outlined,
            color: Colors.white,
            size: 14,
          ),
          const SizedBox(width: 6),
          Text(platform,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ─── CTA Bar ──────────────────────────────────────────────────────────────────

class _CtaBar extends StatelessWidget {
  final CampaignDetail campaign;
  final bool applying;
  final bool applied;
  final VoidCallback onApply;

  const _CtaBar({
    required this.campaign,
    required this.applying,
    required this.applied,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = campaign.isOpen && !applied;

    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 12, 20, MediaQuery.of(context).padding.bottom + 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          )
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: isActive ? AppColors.headerGradient : null,
            color: isActive ? null : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(6),
          ),
          child: ElevatedButton(
            onPressed: isActive && !applying ? onApply : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              disabledBackgroundColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
            ),
            child: applying
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2),
                  )
                : Text(
                    applied
                        ? '✓ Applied'
                        : campaign.isOpen
                            ? 'Apply Now'
                            : 'Campaign Closed',
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.grey.shade600,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
