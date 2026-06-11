import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme.dart';
import '../../notification/notifications_screen.dart';

const Color kKonektaBlue = Color(0xFF4A90E2);
const Color kKonektaPurple = Color(0xFF9B51E0);
const Color kTextDark = Color(0xFF333333);
const Color kTextSubtle = Color(0xFF828282);
const Color kPositiveGreen = Color(0xFF27AE60);
const Color kNegativeRed = Color(0xFFEB5757);

class BrandAnalyticsScreen extends StatefulWidget {
  const BrandAnalyticsScreen({super.key});

  @override
  State<BrandAnalyticsScreen> createState() => _BrandAnalyticsScreenState();
}

class _BrandAnalyticsScreenState extends State<BrandAnalyticsScreen> {
  int _selectedTab = 0;
  static const _tabs = ['Daily', 'Weekly', 'Monthly', 'Annually'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 20),
              _buildTabs(),
              const SizedBox(height: 20),
              _buildDailyPerformanceCard(),
              const SizedBox(height: 25),
              _buildGrowthSection(),
              const SizedBox(height: 25),
              _buildRecentEarningsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: const BoxDecoration(gradient: KonektaGradients.primary),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Konekta',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const NotificationsScreen()),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications_none, color: Colors.white, size: 26),
                Positioned(
                  right: 1,
                  top: 1,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(color: kNegativeRed, shape: BoxShape.circle),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Performance',
            style: TextStyle(color: kTextDark, fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          const Text(
            'Daily metrics and growth analysis for your all Campaigns',
            style: TextStyle(color: kTextSubtle, fontSize: 14),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: List.generate(_tabs.length, (i) {
                final selected = _selectedTab == i;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTab = i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: selected ? kKonektaBlue : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _tabs[i],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: selected ? Colors.white : kTextSubtle,
                          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyPerformanceCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Daily\nPerformance',
                    style: TextStyle(
                      color: kTextDark,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
                  ),
                  Row(
                    children: [
                      _buildLegendItem('Views', kKonektaBlue),
                      const SizedBox(width: 15),
                      _buildLegendItem('Engagement', kKonektaPurple),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              SizedBox(height: 200, child: BarChart(_buildBarChartData())),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(String text, Color color) {
    return Row(
      children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 5),
        Text(text, style: const TextStyle(color: kTextSubtle, fontSize: 12)),
      ],
    );
  }

  BarChartData _buildBarChartData() {
    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: 100,
      barTouchData: BarTouchData(enabled: false),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (double value, TitleMeta meta) {
              const days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
              if (value >= 0 && value < days.length) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  space: 10,
                  child: Text(
                    days[value.toInt()],
                    style: const TextStyle(color: kTextSubtle, fontSize: 10),
                  ),
                );
              }
              return const Text('');
            },
          ),
        ),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      gridData: const FlGridData(show: false),
      borderData: FlBorderData(show: false),
      barGroups: [
        BarChartGroupData(x: 0, barRods: [
          BarChartRodData(toY: 60, color: kKonektaBlue, width: 8, borderRadius: BorderRadius.circular(4)),
          BarChartRodData(toY: 35, color: kKonektaPurple, width: 8, borderRadius: BorderRadius.circular(4)),
        ]),
        BarChartGroupData(x: 1, barRods: [
          BarChartRodData(toY: 45, color: kKonektaBlue, width: 8, borderRadius: BorderRadius.circular(4)),
          BarChartRodData(toY: 25, color: kKonektaPurple, width: 8, borderRadius: BorderRadius.circular(4)),
        ]),
        BarChartGroupData(x: 2, barRods: [
          BarChartRodData(toY: 80, color: kKonektaBlue, width: 8, borderRadius: BorderRadius.circular(4)),
          BarChartRodData(toY: 50, color: kKonektaPurple, width: 8, borderRadius: BorderRadius.circular(4)),
        ]),
        BarChartGroupData(x: 3, barRods: [
          BarChartRodData(toY: 55, color: kKonektaBlue, width: 8, borderRadius: BorderRadius.circular(4)),
          BarChartRodData(toY: 20, color: kKonektaPurple, width: 8, borderRadius: BorderRadius.circular(4)),
        ]),
        BarChartGroupData(x: 4, barRods: [
          BarChartRodData(toY: 95, color: kKonektaBlue, width: 8, borderRadius: BorderRadius.circular(4)),
          BarChartRodData(toY: 58, color: kKonektaPurple, width: 8, borderRadius: BorderRadius.circular(4)),
        ]),
        BarChartGroupData(x: 5, barRods: [
          BarChartRodData(toY: 70, color: kKonektaBlue, width: 8, borderRadius: BorderRadius.circular(4)),
          BarChartRodData(toY: 40, color: kKonektaPurple, width: 8, borderRadius: BorderRadius.circular(4)),
        ]),
        BarChartGroupData(x: 6, barRods: [
          BarChartRodData(toY: 85, color: kKonektaBlue, width: 8, borderRadius: BorderRadius.circular(4)),
          BarChartRodData(toY: 48, color: kKonektaPurple, width: 8, borderRadius: BorderRadius.circular(4)),
        ]),
      ],
    );
  }

  Widget _buildGrowthSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'GROWTH (7D)',
            style: TextStyle(
              color: kTextSubtle,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 15),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            childAspectRatio: 1.6,
            children: [
              _buildGrowthStatCard('ACTIVE CREATORS', '+24', kPositiveGreen),
              _buildGrowthStatCard('ENGAGEMENT RATE', '8.2%', kKonektaBlue),
              _buildGrowthStatCard('TOTAL REACH', '125K', kKonektaBlue),
              _buildGrowthStatCard('BOUNCE RATE', '-1.2k', kNegativeRed),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGrowthStatCard(String title, String value, Color valueColor) {
    return Card(
      color: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: kTextSubtle, fontSize: 11, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(color: valueColor, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentEarningsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'RECENT CAMPAIGNS',
            style: TextStyle(
              color: kTextSubtle,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 15),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 5, spreadRadius: 1),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                  ),
                  child: const Row(
                    children: [
                      Expanded(flex: 3, child: Text('DESCRIPTION', style: TextStyle(color: kTextSubtle, fontSize: 11, fontWeight: FontWeight.bold))),
                      Expanded(flex: 2, child: Text('DATE', textAlign: TextAlign.center, style: TextStyle(color: kTextSubtle, fontSize: 11, fontWeight: FontWeight.bold))),
                      Expanded(flex: 2, child: Text('STATUS', textAlign: TextAlign.right, style: TextStyle(color: kTextSubtle, fontSize: 11, fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),
                _buildCampaignRow('Summer Tech Series', '#CMP-90281', 'Oct 24, 2023', 'COMPLETE', true, kPositiveGreen),
                _buildCampaignRow('Aula Skincare Launch', '#CMP-90282', 'Oct 24, 2023', 'IN PROGRESS', true, kKonektaBlue),
                _buildCampaignRow('NBA Drop Promo', '#CMP-90283', 'Oct 24, 2023', 'PENDING', false, kNegativeRed),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFAF8FE),
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
                  ),
                  child: const Text(
                    'SHOW ALL CAMPAIGNS',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: kTextSubtle,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCampaignRow(String title, String ref, String date, String status, bool hasBorder, Color statusColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        border: hasBorder ? const Border(bottom: BorderSide(color: Color(0xFFEEEEEE))) : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                const Icon(Icons.campaign_outlined, color: kKonektaBlue, size: 24),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(color: kTextDark, fontSize: 12, fontWeight: FontWeight.bold)),
                    Text('Ref: $ref', style: const TextStyle(color: kTextSubtle, fontSize: 10)),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: date
                    .split(', ')
                    .map<TextSpan>((part) => TextSpan(
                          text: '$part\n',
                          style: const TextStyle(color: kTextSubtle, fontSize: 11),
                        ))
                    .toList(),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              status,
              textAlign: TextAlign.right,
              style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
