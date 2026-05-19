import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import 'setting_screen.dart';
import 'campaign_detail_screen.dart';

// ─── Mock Data ───────────────────────────────────────────────────────────────

class InfluencerProfileData {
  final String name;
  final String description;
  final int totalEndorse;
  final int totalLike;
  final String profileImageUrl;
  final List<VideoEndorse> videos;
  final List<SavedBrand> savedBrands;

  const InfluencerProfileData({
    required this.name,
    required this.description,
    required this.totalEndorse,
    required this.totalLike,
    required this.profileImageUrl,
    required this.videos,
    required this.savedBrands,
  });
}

class VideoEndorse {
  final String thumbnailUrl;
  final String views;
  final String likes;

  const VideoEndorse({
    required this.thumbnailUrl,
    required this.views,
    required this.likes,
  });
}

class SavedBrand {
  final int id;
  final String name;
  final String category;
  final String imageUrl;
  final String description;
  final String budget;

  const SavedBrand({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.description,
    required this.budget,
  });
}

// Mock data for preview
final _mockProfileData = InfluencerProfileData(
  name: 'Amna Zahra',
  description: 'Lifestyle & Beauty Creator based in Jakarta. Passionate about creating engaging content and collaborating with amazing brands!',
  totalEndorse: 28,
  totalLike: 156000,
  profileImageUrl: '',
  videos: const [
    VideoEndorse(thumbnailUrl: '', views: '125.3K', likes: '8.2K'),
    VideoEndorse(thumbnailUrl: '', views: '98.7K', likes: '6.5K'),
    VideoEndorse(thumbnailUrl: '', views: '156.2K', likes: '12.1K'),
    VideoEndorse(thumbnailUrl: '', views: '89.4K', likes: '5.8K'),
    VideoEndorse(thumbnailUrl: '', views: '203.1K', likes: '15.7K'),
    VideoEndorse(thumbnailUrl: '', views: '67.8K', likes: '4.3K'),
  ],
  savedBrands: const [
    SavedBrand(id: 1, name: 'Kopi Nusantara', category: 'F&B', imageUrl: '', description: 'Promosi kopi susu dengan konten kreatif', budget: 'Rp 2.000.000'),
    SavedBrand(id: 2, name: 'Glow Skincare', category: 'Beauty', imageUrl: '', description: 'Review serum vitamin C untuk Gen Z', budget: 'Rp 1.500.000'),
    SavedBrand(id: 3, name: 'TechGear ID', category: 'Tech', imageUrl: '', description: 'Unboxing wireless earbuds terbaru', budget: 'Rp 3.500.000'),
    SavedBrand(id: 4, name: 'UrbanWear', category: 'Fashion', imageUrl: '', description: 'OOTD challenge dengan koleksi terbaru', budget: 'Rp 1.000.000'),
  ],
);

// ─── Main Screen ─────────────────────────────────────────────────────────────

class InfluencerProfileScreen extends StatefulWidget {
  const InfluencerProfileScreen({super.key});

  @override
  State<InfluencerProfileScreen> createState() => _InfluencerProfileScreenState();
}

class _InfluencerProfileScreenState extends State<InfluencerProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final InfluencerProfileData _profileData = _mockProfileData;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              // ── Profile Header Section ──
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    // ── Header Profile Section ──
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Profile Picture
                          Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 4),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(alpha: 0.2),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 36,
                                  backgroundColor: AppColors.primary.withValues(alpha: 0.08),
                                  child: const Icon(
                                    Icons.person_rounded,
                                    size: 36,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(width: 16),

                          // Stats - aligned with center of profile
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildStatItem('28', 'Total Endorse'),
                                Container(
                                  width: 1,
                                  height: 36,
                                  color: AppColors.borderGray,
                                ),
                                _buildStatItem('156K', 'Total Like'),
                              ],
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Settings Icon - No background
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const SettingScreen()),
                              );
                            },
                            child: const Icon(
                              Icons.settings_outlined,
                              color: AppColors.darkText,
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── Name, Description, Role - Left Aligned ──
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name
                          const Text(
                            'Amna Zahra',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppColors.darkText,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Description
                          const Text(
                            'Lifestyle & Beauty Creator based in Jakarta. Passionate about creating engaging content and collaborating with amazing brands!',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.grayText,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Role Badge - Left aligned
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              '✨ Influencer',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // ── Sticky Tab Navigation ──
              SliverPersistentHeader(
                pinned: true,
                delegate: _StickyTabBarDelegate(tabController: _tabController),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              _VideoEndorseTab(videos: _profileData.videos),
              _SavedBrandTab(savedBrands: _profileData.savedBrands),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.darkText,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.grayText,
          ),
        ),
      ],
    );
  }
}

// ─── Sticky Tab Bar Delegate ─────────────────────────────────────────────────

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabController tabController;

  _StickyTabBarDelegate({required this.tabController});

  @override
  double get minExtent => 48;

  @override
  double get maxExtent => 48;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _SimpleTabBar(tabController: tabController),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}

// ─── Simple Tab Bar ───────────────────────────────────────────────────────────

class _SimpleTabBar extends StatelessWidget {
  final TabController tabController;

  const _SimpleTabBar({required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.borderGray, width: 0.5),
          bottom: BorderSide(color: AppColors.borderGray, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              icon: Icons.video_camera_back_outlined,
              label: 'Video Endorse',
              tabController: tabController,
              index: 0,
            ),
          ),
          Container(
            width: 0.5,
            height: 48,
            color: AppColors.borderGray,
          ),
          Expanded(
            child: _TabButton(
              icon: Icons.bookmark_border_outlined,
              label: 'Saved Brand',
              tabController: tabController,
              index: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final TabController tabController;
  final int index;

  const _TabButton({
    required this.icon,
    required this.label,
    required this.tabController,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: tabController,
      builder: (context, child) {
        final isSelected = tabController.index == index;
        return GestureDetector(
          onTap: () => tabController.animateTo(index),
          behavior: HitTestBehavior.opaque,
          child: Container(
            height: 48,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isSelected ? _getSelectedIcon(icon) : icon,
                  size: 20,
                  color: isSelected ? AppColors.primary : AppColors.grayText,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected ? AppColors.primary : AppColors.grayText,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _getSelectedIcon(IconData originalIcon) {
    if (originalIcon == Icons.video_camera_back_outlined) {
      return Icons.videocam_rounded;
    } else if (originalIcon == Icons.bookmark_border_outlined) {
      return Icons.bookmark;
    }
    return originalIcon;
  }
}

// ─── Video Endorse Tab ────────────────────────────────────────────────────────

class _VideoEndorseTab extends StatefulWidget {
  final List<VideoEndorse> videos;

  const _VideoEndorseTab({required this.videos});

  @override
  State<_VideoEndorseTab> createState() => _VideoEndorseTabState();
}

class _VideoEndorseTabState extends State<_VideoEndorseTab> {
  int? _expandedIndex;

  void _expandVideo(int index) {
    setState(() {
      _expandedIndex = index;
    });
  }

  void _closeVideo() {
    setState(() {
      _expandedIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Grid Content - No padding, edge to edge
        GridView.builder(
          padding: EdgeInsets.zero,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
            childAspectRatio: 0.7,
          ),
          itemCount: widget.videos.length,
          itemBuilder: (context, index) {
            final video = widget.videos[index];
            return _VideoCard(
              video: video,
              index: index,
              isFirst: index % 2 == 0,
              isLast: index % 2 == 1,
              onTap: () => _expandVideo(index),
            );
          },
        ),

        // Expanded Video Overlay
        if (_expandedIndex != null)
          GestureDetector(
            onTap: _closeVideo,
            child: Container(
              color: Colors.black54,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Expanded Video
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.height * 0.45,
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Video Placeholder
                          Center(
                            child: Icon(
                              Icons.play_circle_fill_outlined,
                              color: Colors.white.withValues(alpha: 0.8),
                              size: 64,
                            ),
                          ),
                          // Close Button
                          Positioned(
                            bottom: -50,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: GestureDetector(
                                onTap: _closeVideo,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.2),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.arrow_back_rounded,
                                        size: 18,
                                        color: AppColors.darkText,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Kembali',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.darkText,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _VideoCard extends StatelessWidget {
  final VideoEndorse video;
  final int index;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onTap;

  const _VideoCard({
    required this.video,
    required this.index,
    required this.isFirst,
    required this.isLast,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Placeholder colors for different videos
    final colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.accent,
      const Color(0xFF9C27B0),
      const Color(0xFFE91E63),
      const Color(0xFF00BCD4),
    ];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: isFirst ? const Radius.circular(6) : Radius.zero,
            topRight: isLast ? const Radius.circular(6) : Radius.zero,
            bottomLeft: isFirst ? Radius.zero : Radius.zero,
            bottomRight: isLast ? Radius.zero : Radius.zero,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video Thumbnail
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: colors[index % colors.length].withValues(alpha: 0.2),
                ),
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.play_circle_outline,
                        color: colors[index % colors.length],
                        size: 48,
                      ),
                      Positioned(
                        right: 8,
                        bottom: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            '0:30',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Video Info - minimal padding
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                children: [
                  // Views
                  const Icon(
                    Icons.visibility_outlined,
                    size: 12,
                    color: AppColors.grayText,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    video.views,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.grayText,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Likes
                  const Icon(
                    Icons.favorite_outline,
                    size: 12,
                    color: AppColors.grayText,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    video.likes,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.grayText,
                    ),
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

// ─── Saved Brand Tab ──────────────────────────────────────────────────────────

class _SavedBrandTab extends StatelessWidget {
  final List<SavedBrand> savedBrands;

  const _SavedBrandTab({required this.savedBrands});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: savedBrands.length,
      itemBuilder: (context, index) {
        final brand = savedBrands[index];
        return _SavedBrandItem(
          brand: brand,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CampaignDetailScreen(
                  campaignId: brand.id,
                  heroTitle: brand.name,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _SavedBrandItem extends StatelessWidget {
  final SavedBrand brand;
  final VoidCallback onTap;

  const _SavedBrandItem({required this.brand, required this.onTap});

  static const _iconColors = [
    Colors.pinkAccent,
    Colors.blue,
    Colors.red,
    Colors.orange,
    Colors.green,
    Colors.purple,
    Colors.teal,
    Colors.amber,
    Colors.indigo,
  ];

  static const _icons = [
    Icons.favorite,
    Icons.sync,
    Icons.radio_button_checked,
    Icons.monitor_heart,
    Icons.local_cafe,
    Icons.checkroom,
    Icons.devices,
    Icons.directions_run,
    Icons.spa,
  ];

  Color get _iconColor => _iconColors[brand.id % _iconColors.length];
  IconData get _icon => _icons[brand.id % _icons.length];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Icon(_icon, color: _iconColor, size: 28),
          ),
          title: Text(
            brand.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                brand.description,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Text(
                    'Budget: ${brand.budget}',
                    style: const TextStyle(
                      color: Color(0xFF241A7A),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '• ${brand.category}',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
          onTap: onTap,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 82),
          child: const Divider(height: 1),
        ),
      ],
    );
  }
}