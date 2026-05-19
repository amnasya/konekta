import 'package:flutter/material.dart';
import '../../models/explore_model.dart';
import '../../services/explore_service.dart';
import 'campaign_detail_screen.dart';

class InfluencerExploreScreen extends StatefulWidget {
  const InfluencerExploreScreen({super.key});

  @override
  State<InfluencerExploreScreen> createState() => _InfluencerExploreScreenState();
}

class _InfluencerExploreScreenState extends State<InfluencerExploreScreen> {
  String _activeFilter = 'ALL';
  String _searchQuery = '';
  late Future<ExploreData> _future;

  // Filter tabs berdasarkan kategori brand dari backend
  static const _filters = ['ALL', 'Beauty', 'Food', 'Tech', 'Fashion', 'Lifestyle'];

  @override
  void initState() {
    super.initState();
    _future = ExploreService().fetchExplore();
  }

  List<ExploreCampaign> _filtered(List<ExploreCampaign> campaigns) {
    var list = campaigns;
    if (_activeFilter != 'ALL') {
      list = list.where((c) => c.category == _activeFilter).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((c) =>
        c.brand.toLowerCase().contains(q) ||
        c.title.toLowerCase().contains(q) ||
        c.category.toLowerCase().contains(q),
      ).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0, // mencegah warna berubah saat scroll
        title: const Text(
          'EXPLORE',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder<ExploreData>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snap.hasError || !snap.hasData) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.wifi_off_rounded, size: 48, color: Color(0xFFCCCCCC)),
                  const SizedBox(height: 12),
                  const Text('Gagal memuat data'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => setState(() {
                      _future = ExploreService().fetchExplore();
                    }),
                    child: const Text('Coba lagi'),
                  ),
                ],
              ),
            );
          }

          final filtered = _filtered(snap.data!.campaigns);

          return Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    hintText: 'Cari brand atau campaign...',
                    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              // Filter Tabs
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Row(
                  children: _filters
                      .map((f) => _buildFilterTab(f, isActive: _activeFilter == f))
                      .toList(),
                ),
              ),
              const Divider(height: 1),
              // Campaign List
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.inbox_outlined, size: 48, color: Color(0xFFCCCCCC)),
                            const SizedBox(height: 12),
                            Text(
                              'Tidak ada campaign ditemukan',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          setState(() {
                            _future = ExploreService().fetchExplore();
                          });
                          await _future;
                        },
                        child: ListView.builder(
                          itemCount: filtered.length,
                          itemBuilder: (context, i) => _CampaignItem(
                            campaign: filtered[i],
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CampaignDetailScreen(
                                  campaignId: filtered[i].id,
                                  heroTitle: filtered[i].title,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterTab(String label, {bool isActive = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: OutlinedButton(
        onPressed: () => setState(() => _activeFilter = label),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: isActive ? Colors.black : Colors.grey.shade300),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          backgroundColor: isActive ? Colors.white : Colors.transparent,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.black : Colors.grey,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

// ─── Campaign Item ─────────────────────────────────────────────────────────────

class _CampaignItem extends StatelessWidget {
  final ExploreCampaign campaign;
  final VoidCallback onTap;

  const _CampaignItem({required this.campaign, required this.onTap});

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

  Color get _iconColor => _iconColors[campaign.id % _iconColors.length];
  IconData get _icon => _icons[campaign.id % _icons.length];

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
            campaign.brand,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                campaign.title,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Text(
                    campaign.budgetLabel,
                    style: const TextStyle(
                      color: Color(0xFF241A7A),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '• ${campaign.deadlineLabel}',
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
