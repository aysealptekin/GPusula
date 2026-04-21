import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../routes/app_routes.dart';

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.arkaplan,
      body: SafeArea(
        child: SingleChildScrollView(
          physics:
              const BouncingScrollPhysics(), //sonda ve basta ziplama efekti
          child: Padding(
            //padding: icindeki bilesenlere yazildigi kadar bosluk ekler
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ================= HEADER =================
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage('assets/merto1.png'),
                      radius: 24,
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Hoş geldin, Mert",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "İşte finansal özetin",
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                    const Spacer(), //row icinde kullanildiginda kendisinden sonraki bilesenleri kalan tum boslugu doldurarak saga iter
                    const Icon(
                      Icons.notifications_none_rounded,
                      color: Color(0xFF7B8FF7),
                      size: 28,
                    ),
                  ],
                ),
                const SizedBox(height: 25),

                // ================= ANA KART (TOPLAM HARCAMA) =================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6366f1), Color(0xFFa855f7)],
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Toplam Harcama",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const Text(
                        "₺12,450.00",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 0),
                      // Mini Grafik Çizgisi
                      Row(
                        children: [
                          const Icon(
                            Icons.show_chart,
                            color: Colors.white38,
                            size: 35,
                          ),
                          const Expanded(
                            child: Text(" harcamalarinda %5 artis goruldu"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // ================= SON İŞLEMLER BAŞLIK =================
                _buildSectionHeader(
                  "Son İşlemler",
                  onSeeAll: () {
                    Navigator.pushNamed(context, AppRoutes.transactions);
                  },
                ),
                const SizedBox(height: 15),
                _buildTransactionItem(
                  "Coffy",
                  "Bugün, 09:41",
                  "-666.00 ₺",
                  Icons.coffee,
                  Colors.orange,
                ),
                _buildTransactionItem(
                  "Taksi",
                  "Dün, 22:15",
                  "-8,120.00 ₺",
                  Icons.directions_car,
                  Colors.blue,
                ),
                _buildTransactionItem(
                  "Babam harclik atti",
                  "12 Haz, 14:00",
                  "+612.00 ₺",
                  Icons.favorite,
                  Colors.pink,
                ),

                const SizedBox(height: 30),

                // ================= KATEGORİLER =================
                _buildSectionHeader(
                  "Kategoriler",
                  onSeeAll: () {
                    Navigator.pushNamed(context, AppRoutes.categories);
                  },
                ),
                const SizedBox(height: 15),
                const BudgetCategoryCard(
                  title: "yemek",
                  amount: "2,400 ₺",
                  progress: 0.9,
                  status: "DIKKAT ET",
                  statusColor: Colors.redAccent,
                  icon: Icons.restaurant,
                ),
                const BudgetCategoryCard(
                  title: "Alisveris",
                  amount: "1,800 ₺",
                  progress: 0.6,
                  status: "stabil",
                  statusColor: Colors.orangeAccent,
                  icon: Icons.shopping_bag,
                ),

                const SizedBox(height: 30),

                // ================= BİRİKİM HEDEFLERİ =================
                const Text(
                  "Birikim Hedefleri",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: const [
                    Expanded(
                      child: GoalCard(
                        title: "tasarruf hedefi",
                        amount: "12,500 ₺",
                        progress: 0.72,
                        icon: Icons.wallet,
                        color: Colors.pinkAccent,
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: GoalCard(
                        title: "tatil fonu",
                        amount: "8,200 ₺",
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

      // ================= BUTON VE NAVİGASYON =================
      floatingActionButton: Tooltip(
        //triggerMode: TooltipTriggerMode.tap,
        message: "yeni harcama ekle",
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

      // ================= ALT MENÜ ================
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0D0F14),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF7B8FF7),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            label: "Anasayfa",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_rounded),
            label: "Serüven",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome_rounded),
            label: "Pusula AI",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            label: "Profil",
          ),
        ],
      ),
    );
  }

  // --- Yardımcı Widgetlar ---
  Widget _buildSectionHeader(String title, {required VoidCallback onSeeAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        InkWell(
          onTap: onSeeAll,
          child: const Text(
            "Tümünü Gör",
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  date,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
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

// ================= EKSTRA BİLEŞENLER (PROGRESS BARS VB) =================
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
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    Text(
                      amount,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
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
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          Text(
            amount,
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
            "${(progress * 100).toInt()}%",
            style: const TextStyle(color: Colors.grey, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
