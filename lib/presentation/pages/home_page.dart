import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../widgets/common/custom_bottom_nav.dart';
import '../widgets/add_expense/add_expense_sheet.dart';
import '../widgets/home/home_header.dart';
import '../widgets/home/home_balance_card.dart';
import '../widgets/home/transaction_item.dart';
import '../widgets/home/budget_category_card.dart';
import '../widgets/home/goal_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _showAddExpenseSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: const AddExpenseSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.arkaplan,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeHeader(),
              const SizedBox(height: 25),
              const HomeBalanceCard(),
              const SizedBox(height: 30),

              _SectionHeader(
                title: 'Son İşlemler',
                onSeeAll: () =>
                    Navigator.pushNamed(context, AppRoutes.transactions),
              ),
              const SizedBox(height: 15),
              TransactionItem(
                title: 'Coffy',
                date: 'Bugün, 09:41',
                amount: '-66.00 ₺',
                icon: Icons.coffee,
                color: Colors.orange,
              ),
              TransactionItem(
                title: 'Taksi',
                date: 'Dün, 22:15',
                amount: '-120.00 ₺',
                icon: Icons.directions_car,
                color: Colors.blue,
              ),

              const SizedBox(height: 30),
              _SectionHeader(
                title: 'Kategoriler',
                onSeeAll: () =>
                    Navigator.pushNamed(context, AppRoutes.categories),
              ),
              const SizedBox(height: 15),
              const BudgetCategoryCard(
                title: 'Yemek',
                amount: '2,400 ₺',
                progress: 0.9,
                status: 'DİKKAT ET',
                statusColor: Colors.redAccent,
                icon: Icons.restaurant,
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
                      title: 'Tasarruf',
                      amount: '12,500 ₺',
                      progress: 0.72,
                      icon: Icons.wallet,
                      color: Colors.pinkAccent,
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: GoalCard(
                      title: 'Tatil',
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddExpenseSheet(context),
        backgroundColor: const Color(0xFF7B8FF7),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 0),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;
  const _SectionHeader({required this.title, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
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
            'Tümünü Gör',
            style: TextStyle(color: Color(0xFF7B8FF7)),
          ),
        ),
      ],
    );
  }
}
