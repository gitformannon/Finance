import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

@override
Widget build(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;

  return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0,
      toolbarHeight: 0,
    ),
    body: Column(
      children: [
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _buildFilterChip('Finance plan'),
              const SizedBox(width: 8),
              _buildFilterChip('Debts'),
              const SizedBox(width: 8),
              _buildFilterChip('Subscriptions'),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xF3F4F6FF),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Total balance', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              const Text('0 ₽', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 56,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text('For a day'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      height: 56,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text('For a month'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _buildCalendarSection(),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('20 July 2025', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Row(
                children: [
                  _BalanceChip(text: '+0 ₽'),
                  SizedBox(width: 8),
                  _BalanceChip(text: '-0 ₽'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFCBD5E1),
                style: BorderStyle.solid,
              ),
            ),
            child: const Text(
              'No operations on this day',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ],
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {},
      backgroundColor: Colors.blue,
      child: const Icon(Icons.add),
    ),
    bottomNavigationBar: BottomNavigationBar(
      currentIndex: 3,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Main'),
        BottomNavigationBarItem(icon: Icon(Icons.checklist_outlined), label: 'Tasks'),
        BottomNavigationBarItem(icon: Icon(Icons.edit_outlined), label: 'Notes'),
        BottomNavigationBarItem(icon: Icon(Icons.credit_card_outlined), label: 'Budget'),
        BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Settings'),
      ],
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),
  );
}

Widget _buildFilterChip(String label) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(24),
    ),
    child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
  );
}

Widget _buildCalendarSection() {
  final today = DateTime(2025, 7, 20);
  final start = today.subtract(const Duration(days: 6));
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ListTile(
                  title: const Text('Main'),
                  subtitle: const Text('0 ₽'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ),
              Container(
                width: 56,
                height: 56,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.add, color: Colors.grey),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (index) {
                final date = start.add(Duration(days: index));
                final isToday = date.day == today.day;
                return Column(
                  children: [
                    Text(
                      DateFormat.E().format(date),
                      style: const TextStyle(color: Colors.black),
                    ),
                    const SizedBox(height: 4),
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: isToday ? Colors.blue : Colors.transparent,
                      child: Text(
                        '${date.day}',
                        style: TextStyle(
                          color: isToday ? Colors.white : Colors.black,
                          fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    ),
  );
}


class _BalanceChip extends StatelessWidget {
  final String text;
  const _BalanceChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}

