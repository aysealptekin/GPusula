import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.arkaplan,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage('assets/merto1.png'),
                      radius: 24,
                    ),
                    const SizedBox(width: 15),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Hoş geldin, Mert',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'İşte finansal özetin',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.notifications_none_rounded,
                        color: Color(0xFF7B8FF7),
                        size: 28,
                      ),
                      onPressed: () => _showNotificationsSheet(context),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFFA855F7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Toplam Harcama',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      const Text(
                        '₺12,450.00',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Row(
                        children: [
                          Icon(
                            Icons.show_chart,
                            color: Colors.white38,
                            size: 35,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Harcamalarında %5 artış görüldü',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                _buildSectionHeader(
                  'Son İşlemler',
                  onSeeAll: () {
                    Navigator.pushNamed(context, AppRoutes.transactions);
                  },
                ),
                const SizedBox(height: 15),
                _buildTransactionItem(
                  'Coffy',
                  'Bugün, 09:41',
                  '-666.00 ₺',
                  Icons.coffee,
                  Colors.orange,
                ),
                _buildTransactionItem(
                  'Taksi',
                  'Dün, 22:15',
                  '-8,120.00 ₺',
                  Icons.directions_car,
                  Colors.blue,
                ),
                _buildTransactionItem(
                  ' harçlık ',
                  '12 Haz, 14:00',
                  '+612.00 ₺',
                  Icons.favorite,
                  Colors.pink,
                ),
                const SizedBox(height: 30),
                _buildSectionHeader(
                  'Kategoriler',
                  onSeeAll: () {
                    Navigator.pushNamed(context, AppRoutes.categories);
                  },
                ),
                const SizedBox(height: 15),
                const BudgetCategoryCard(
                  title: 'Yemek',
                  amount: '2,400 ₺',
                  progress: 0.9,
                  status: 'DIKKAT ET',
                  statusColor: Colors.redAccent,
                  icon: Icons.restaurant,
                ),
                const BudgetCategoryCard(
                  title: 'Alışveriş',
                  amount: '1,800 ₺',
                  progress: 0.6,
                  status: 'Stabil',
                  statusColor: Colors.orangeAccent,
                  icon: Icons.shopping_bag,
                ),
                const SizedBox(height: 30),
                const Text(
                  'Birikim Hedefleri',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                const Row(
                  children: [
                    Expanded(
                      child: GoalCard(
                        title: 'Tasarruf hedefi',
                        amount: '12,500 ₺',
                        progress: 0.72,
                        icon: Icons.wallet,
                        color: Colors.pinkAccent,
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: GoalCard(
                        title: 'Tatil fonu',
                        amount: '8,200 ₺',
                        progress: 0.45,
                        icon: Icons.flight,
                        color: Colors.orangeAccent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Tooltip(
        message: 'Yeni harcama ekle',
        preferBelow: false,
        verticalOffset: 38,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.addExpense);
          },
          backgroundColor: const Color(0xFF7B8FF7),
          child: const Icon(Icons.add, color: Colors.white, size: 30),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) return;

          if (index == 1) {
            Navigator.pushReplacementNamed(context, AppRoutes.seruven);
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, AppRoutes.pusulaAi);
          } else if (index == 3) {
            Navigator.pushReplacementNamed(context, AppRoutes.profile);
          }
        },

        backgroundColor: const Color(0xFF0D0F14),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF7B8FF7),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            label: 'Anasayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_rounded),
            label: 'Serüven',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome_rounded),
            label: 'Pusula AI',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  void _showNotificationsSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SafeArea(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
            ),
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFF1A1D24),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: ListView(
              shrinkWrap: true,
              children: const [
                Text(
                  'Bildirimler',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                _NotificationTile(
                  icon: Icons.notifications,
                  iconColor: Color(0xFF7B8FF7),
                  title: 'Bu ay harcamaların %5 arttı',
                  subtitle: '2 saat önce',
                ),
                Divider(color: Colors.white12),
                _NotificationTile(
                  icon: Icons.savings,
                  iconColor: Colors.orangeAccent,
                  title: 'Tasarruf hedefin yaklaşıyor',
                  subtitle: 'Bugün',
                ),
                Divider(color: Colors.white12),
                _NotificationTile(
                  icon: Icons.auto_awesome,
                  iconColor: Colors.pinkAccent,
                  title: 'Pusula AI sana yeni öneri hazırladı',
                  subtitle: 'Dün',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, {required VoidCallback onSeeAll}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 12),
        InkWell(
          onTap: onSeeAll,
          child: const Text(
            'Tümünü Gör',
            style: TextStyle(color: Color(0xFF7B8FF7), fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionItem(
    String title,
    String date,
    String amount,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D24),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  date,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            amount,
            style: TextStyle(
              color: amount.startsWith('-')
                  ? Colors.redAccent
                  : Colors.greenAccent,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;

  const _NotificationTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
    );
  }
}

class BudgetCategoryCard extends StatelessWidget {
  final String title;
  final String amount;
  final double progress;
  final String status;
  final Color statusColor;
  final IconData icon;

  const BudgetCategoryCard({
    super.key,
    required this.title,
    required this.amount,
    required this.progress,
    required this.status,
    required this.statusColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D24),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.orangeAccent, size: 20),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    Text(
                      amount,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white10,
              color: statusColor,
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}

class GoalCard extends StatelessWidget {
  final String title;
  final String amount;
  final double progress;
  final IconData icon;
  final Color color;

  const GoalCard({
    super.key,
    required this.title,
    required this.amount,
    required this.progress,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D24),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 15),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          Text(
            amount,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white10,
              color: color,
              minHeight: 4,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '${(progress * 100).toInt()}%',
            style: const TextStyle(color: Colors.grey, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
