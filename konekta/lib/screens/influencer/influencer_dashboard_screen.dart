import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../services/dashboard_service.dart';
import '../../models/dashboard_model.dart';
import '../../widgets/dashboard/skeleton_loader.dart';
import 'profile/notification_page.dart';

const _navy = Color(0xFF170C79);
const _green = Color(0xFF1B4332);

class InfluencerDashboardScreen extends StatelessWidget {
  const InfluencerDashboardScreen({super.key});
  static const _userId = '1';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardProvider(DashboardService())..load(_userId),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    final provider = context.watch<DashboardProvider>();

    if (provider.status == DashboardStatus.loading) {
      return const Scaffold(
        backgroundColor: _navy,
        body: DashboardSkeletonLoader(),
      );
    }

    if (provider.status == DashboardStatus.error) {
      return Scaffold(
        backgroundColor: _navy,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.wifi_off_rounded,
                size: 56,
                color: Colors.white38,
              ),
              const SizedBox(height: 16),
              const Text(
                'Something went wrong.',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () =>
                    provider.refresh(InfluencerDashboardScreen._userId),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: _navy,
                  shape: const StadiumBorder(),
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final data = provider.data;
    if (data == null) return const SizedBox.shrink();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: RefreshIndicator(
        color: _navy,
        onRefresh: () => provider.refresh(InfluencerDashboardScreen._userId),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Curved navy header ──
              Stack(
                children: [
                  Container(height: 180, width: double.infinity, color: _navy),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                                    child: const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    data.user.username,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const NotificationPage()),
                                  );
                                },
                                child: const Icon(
                                  Icons.notifications_none,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _SummaryCard(data: data),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ── Calendar Section ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _CalendarSection(
                  campaigns: provider.data?.campaigns ?? [],
                ),
              ),

              const SizedBox(height: 20),

              // ── Analytics Section ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'My Analytics',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Your content performance',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),

                    // Chart card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Views (7 Days)',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _Bar(height: 55, label: 'Mon'),
                              _Bar(height: 80, label: 'Tue'),
                              _Bar(height: 65, label: 'Wed'),
                              _Bar(height: 100, label: 'Thu', highlighted: true),
                              _Bar(height: 85, label: 'Fri'),
                              _Bar(height: 70, label: 'Sat'),
                              _Bar(height: 90, label: 'Sun'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Metrics grid
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 1.6,
                      children: const [
                        _MetricCard(
                          label: 'Total Views',
                          value: '24.8K',
                          delta: '+12%',
                          positive: true,
                        ),
                        _MetricCard(
                          label: 'Engagement',
                          value: '2.3K',
                          delta: '+8%',
                          positive: true,
                        ),
                        _MetricCard(
                          label: 'Followers',
                          value: '18.4K',
                          delta: '+3%',
                          positive: true,
                        ),
                        _MetricCard(
                          label: 'Avg. Watch',
                          value: '1m 42s',
                          delta: '-2%',
                          positive: false,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ── Campaign list ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        print("Lihat semua campaign");
                      },
                      borderRadius: BorderRadius.circular(6),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Your Active Campaigns',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right_rounded,
                              color: Colors.grey,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...List.generate(provider.filteredCampaigns.length, (i) {
                      final c = provider.filteredCampaigns[i];
                      return Column(
                        children: [
                          _CampaignItem(campaign: c),
                          if (i < provider.filteredCampaigns.length - 1)
                            const Divider(height: 1, thickness: 1),
                        ],
                      );
                    }),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Header Clipper ───────────────────────────────────────────────────────────

class _HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 60,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// ─── Toggle Switch ────────────────────────────────────────────────────────────

class _ToggleSwitch extends StatefulWidget {
  @override
  State<_ToggleSwitch> createState() => _ToggleSwitchState();
}

class _ToggleSwitchState extends State<_ToggleSwitch> {
  bool _on = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _on = !_on),
      child: Container(
        width: 55,
        height: 28,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: _on ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: CircleAvatar(
              radius: 11,
              backgroundColor: _navy,
              child: const Icon(Icons.flash_on, size: 14, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Summary Card ─────────────────────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  final DashboardData data;
  const _SummaryCard({required this.data});

  // Pakai thisMonthEarnings dari UserStats karena Campaign tidak punya field price
  double get _totalEarnings => data.user.thisMonthEarnings;

  String get _formatted {
    final n = _totalEarnings.toStringAsFixed(0);
    return n.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: _navy.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'Total Earnings',
              style: TextStyle(
                  color: _navy, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'IDR $_formatted',
            style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.check_circle_outline,
                  color: Colors.green, size: 16),
              const SizedBox(width: 6),
              Text(
                'From ${data.campaigns.length} active campaigns',
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Campaign Item ────────────────────────────────────────────────────────────

class _CampaignItem extends StatelessWidget {
  final Campaign campaign;
  const _CampaignItem({required this.campaign});

  static const _avatarColors = [
    Color(0xFF1A1A1A),
    Color(0xFFCC0000),
    Color(0xFF0057B8),
    Color(0xFF1B4332),
    Color(0xFF8B4513),
    Color(0xFF4B0082),
  ];

  Color get _avatarColor => _avatarColors[campaign.id % _avatarColors.length];

  String get _timeLeft =>
      campaign.daysLeft > 0 ? '${campaign.daysLeft} hari lagi' : 'Hari ini';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Row(
        children: [
          // Logo circle
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: _avatarColor,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade200, width: 1.5),
            ),
            child: Center(
              child: Text(
                campaign.title.length >= 2
                    ? campaign.title.substring(0, 2).toUpperCase()
                    : campaign.title[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  campaign.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _green,
                  ),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: campaign.progress / 100,
                    minHeight: 5,
                    backgroundColor: Colors.grey.shade200,
                    color: _navy,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${campaign.progress}%',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _navy,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '• $_timeLeft',
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 1),
          // Status button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'In progress',
              style: TextStyle(
                color: _green,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Analytics Bar ────────────────────────────────────────────────────────────

class _Bar extends StatelessWidget {
  final double height;
  final String label;
  final bool highlighted;
  const _Bar({
    required this.height,
    required this.label,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 26,
          height: height,
          decoration: BoxDecoration(
            gradient: highlighted
                ? const LinearGradient(
                    colors: [Color(0xFF170C79), Color(0xFF4A3AFF)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
                : null,
            color: highlighted ? null : _navy.withOpacity(0.15),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
      ],
    );
  }
}

// ─── Analytics Metric Card ────────────────────────────────────────────────────

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final String delta;
  final bool positive;
  const _MetricCard({
    required this.label,
    required this.value,
    required this.delta,
    required this.positive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
              Text(
                delta,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: positive ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Calendar Section ─────────────────────────────────────────────────────────

class _CalendarSection extends StatefulWidget {
  final List<Campaign> campaigns;

  const _CalendarSection({required this.campaigns});

  @override
  State<_CalendarSection> createState() => _CalendarSectionState();
}

class _CalendarSectionState extends State<_CalendarSection> {
  late DateTime _selectedDate;
  late DateTime _focusedMonth;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _focusedMonth = DateTime.now();
  }

  // Get campaign dates from the list
  List<Map<String, dynamic>> get _campaignDates {
    // Mock data for campaign start and deadline dates
    final now = DateTime.now();
    return [
      {'date': DateTime(now.year, now.month, now.day + 2), 'type': 'start', 'title': 'Kopi Nusantara'},
      {'date': DateTime(now.year, now.month, now.day + 5), 'type': 'deadline', 'title': 'Kopi Nusantara'},
      {'date': DateTime(now.year, now.month, now.day + 8), 'type': 'start', 'title': 'Glow Skincare'},
      {'date': DateTime(now.year, now.month, now.day + 12), 'type': 'deadline', 'title': 'Glow Skincare'},
      {'date': DateTime(now.year, now.month, now.day - 3), 'type': 'start', 'title': 'TechGear ID'},
      {'date': DateTime(now.year, now.month, now.day + 1), 'type': 'deadline', 'title': 'TechGear ID'},
    ];
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  bool _hasCampaignDate(DateTime date) {
    return _campaignDates.any((c) =>
        c['date'].year == date.year &&
        c['date'].month == date.month &&
        c['date'].day == date.day);
  }

  String _getCampaignType(DateTime date) {
    final campaign = _campaignDates.cast<Map<String, dynamic>?>().firstWhere(
        (c) =>
            c!['date'].year == date.year &&
            c['date'].month == date.month &&
            c['date'].day == date.day,
        orElse: () => null);
    return campaign?['type'] ?? '';
  }

  String _getCampaignTitle(DateTime date) {
    final campaign = _campaignDates.cast<Map<String, dynamic>?>().firstWhere(
        (c) =>
            c!['date'].year == date.year &&
            c['date'].month == date.month &&
            c['date'].day == date.day,
        orElse: () => null);
    return campaign?['title'] ?? '';
  }

  void _previousMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with month navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: _previousMonth,
                icon: const Icon(Icons.chevron_left, color: Colors.grey),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              Text(
                _getMonthName(_focusedMonth),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              IconButton(
                onPressed: _nextMonth,
                icon: const Icon(Icons.chevron_right, color: Colors.grey),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Day headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab']
                .map((day) => SizedBox(
                      width: 36,
                      child: Text(
                        day,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),

          // Calendar grid
          _buildCalendarGrid(),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final lastDayOfMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday % 7; // Sunday = 0

    final daysInMonth = lastDayOfMonth.day;
    final totalCells = ((firstWeekday + daysInMonth) / 7).ceil() * 7;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
      ),
      itemCount: totalCells,
      itemBuilder: (context, index) {
        final dayOffset = index - firstWeekday;
        if (dayOffset < 0 || dayOffset >= daysInMonth) {
          return const SizedBox.shrink();
        }

        final date = DateTime(_focusedMonth.year, _focusedMonth.month, dayOffset + 1);
        final isToday = _isToday(date);
        final hasCampaign = _hasCampaignDate(date);
        final campaignType = _getCampaignType(date);
        final campaignTitle = _getCampaignTitle(date);

        return GestureDetector(
          onTap: hasCampaign ? () => _showCampaignDetails(date, campaignType, campaignTitle) : null,
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isToday ? _navy : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: hasCampaign
                  ? Border.all(
                      color: campaignType == 'start'
                          ? Colors.green
                          : Colors.orange,
                      width: 2,
                    )
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${dayOffset + 1}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    color: isToday ? Colors.white : Colors.black87,
                  ),
                ),
                if (hasCampaign)
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: campaignType == 'start' ? Colors.green : Colors.orange,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCampaignDetails(DateTime date, String type, String title) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: type == 'start' ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    type == 'start' ? Icons.play_circle_outline : Icons.flag_outlined,
                    color: type == 'start' ? Colors.green : Colors.orange,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        type == 'start' ? 'Tanggal Mulai' : 'Deadline',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        '${date.day} ${_getMonthName(date)} ${date.year}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  const Icon(Icons.campaign_outlined, color: Colors.grey),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Campaign $title',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: type == 'start' ? Colors.green : Colors.orange,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      type == 'start' ? 'START' : 'DEADLINE',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  String _getMonthName(DateTime date) {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}
