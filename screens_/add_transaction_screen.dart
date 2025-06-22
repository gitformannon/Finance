import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../theme.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  final _transactionTypes = ['Income', 'Purchase', 'Transfer'];
  int _selectedTypeIndex = 1; // default to Purchase

  final _accounts = ['Cash', 'Debit Card', 'Credit Card'];
  final Map<String, IconData> _accountIcons = {
    'Cash': Icons.attach_money,
    'Debit Card': Icons.account_balance_wallet,
    'Credit Card': Icons.credit_card,
  };
  String _selectedAccount = 'Cash';
  late final PageController _accountPageController;

  final List<String> _incomeCategories = [
    'Salary',
    'Bonus',
    'Interest',
    'Other'
  ];

  final Map<String, IconData> _purchaseCategories = {
    'Food': Icons.fastfood,
    'Clothes': Icons.shopping_bag,
    'Transport': Icons.directions_car,
    'Entertainment': Icons.movie,
    'Bills': Icons.receipt_long,
    'Health': Icons.healing,
    'Gift': Icons.card_giftcard,
    'Other': Icons.more_horiz,
  };

  final List<String> _recentAccounts = [
    'Savings',
    'Investment',
    'Friend'
  ];

  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _accountPageController = PageController(
      viewportFraction: 0.6,
      // start at a high index to allow scrolling in both directions
      initialPage: _accounts.length * 1000 +
          _accounts.indexOf(_selectedAccount),
    );
    _dateController.text = _formatDate(_selectedDate);
    _timeController.text = _formatTime(_selectedTime);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _accountPageController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    // Dismiss keyboard if open
    FocusScope.of(context).unfocus();
    await showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 300,
        color: Colors.white,
        child: Column(
          children: [
            // Done button bar
            SizedBox(
              height: 44,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CupertinoButton(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const Text('Done'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            // The iOS-style date picker
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: _selectedDate,
                minimumDate: DateTime(2000),
                maximumDate: DateTime.now(),
                onDateTimeChanged: (DateTime newDate) {
                  setState(() {
                    _selectedDate = newDate;
                    _dateController.text = _formatDate(_selectedDate);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickTime() async {
    FocusScope.of(context).unfocus();
    final initial = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );
    await showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 300,
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(
              height: 44,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CupertinoButton(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const Text('Done'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                initialDateTime: initial,
                use24hFormat: true,
                onDateTimeChanged: (DateTime newDate) {
                  setState(() {
                    _selectedTime = TimeOfDay(hour: newDate.hour, minute: newDate.minute);
                    _timeController.text = _formatTime(_selectedTime);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat.yMMMd().format(date);
  }

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat.Hm().format(dt);
  }

  Future<void> _saveTransaction() async {
    final amountText = _amountController.text.trim();
    if (amountText.isEmpty) return;
    final combinedDate = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );
    final newTxData = {
      "amount": double.tryParse(amountText) ?? 0.0,
      "type": _transactionTypes[_selectedTypeIndex].toLowerCase(),
      "date": combinedDate.toIso8601String(),
      "account": _selectedAccount,
      "note": _noteController.text.trim(),
      "category": _selectedCategory ?? '',
    };
    final response = await ApiService.post('/transactions', newTxData);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Navigator.pop(context);
    } else {
      // handle error
    }
  }

  Widget _buildAccountCarousel(ColorScheme colors) {
    return SizedBox(
      height: 70,
      child: PageView.builder(
        controller: _accountPageController,
        onPageChanged: (index) {
          setState(() {
            _selectedAccount = _accounts[index % _accounts.length];
          });
        },
        itemBuilder: (context, index) {
          final account = _accounts[index % _accounts.length];
          final icon = _accountIcons[account] ?? Icons.account_balance;
          final bool selected = account == _selectedAccount;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: () => _accountPageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.box,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selected ? AppColors.accent : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Icon(
                        icon,
                        color: selected ? AppColors.accent : AppColors.primary,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Text(
                        account,
                        style: TextStyle(
                          color:
                              selected ? AppColors.accent : AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategorySection(ColorScheme colors) {
    if (_selectedTypeIndex == 0) {
      return Column(
        children: _incomeCategories
            .map(
              (c) => ListTile(
                title: Text(c),
                trailing: _selectedCategory == c
                    ? const Icon(Icons.check, color: AppColors.accent)
                    : null,
                onTap: () {
                  setState(() {
                    _selectedCategory = c;
                  });
                },
              ),
            )
            .toList(),
      );
    } else if (_selectedTypeIndex == 1) {
      return GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: _purchaseCategories.entries
            .map(
              (e) => GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategory = e.key;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _selectedCategory == e.key
                          ? AppColors.accent
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(e.value, color: colors.primary),
                      const SizedBox(height: 4),
                      Text(
                        e.key,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      );
    } else {
      final accounts = [..._accounts, ..._recentAccounts];
      return Column(
        children: accounts
            .map(
              (a) => ListTile(
                leading: const Icon(Icons.account_balance),
                title: Text(a),
                onTap: () {
                  setState(() {
                    _selectedCategory = a;
                  });
                },
              ),
            )
            .toList(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme
      .of(context)
      .colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            children: [
              // Transaction type toggle
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ToggleButtons(
                  constraints: BoxConstraints(maxWidth: double.infinity, minHeight: 30),
                  borderRadius: BorderRadius.circular(8),
                  selectedColor: AppColors.surface,
                  fillColor: AppColors.accent,
                  color: AppColors.primary,
                  borderColor: AppColors.secondary,
                  selectedBorderColor: AppColors.accent,
                  children: _transactionTypes
                    .map((t) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(t,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                      ),
                      )
                  )
                    .toList(),
                  isSelected: List.generate(_transactionTypes.length,
                      (i) => i == _selectedTypeIndex),
                  onPressed: (index) {
                    setState(() {
                      _selectedTypeIndex = index;
                      _selectedCategory = null;
                    }
                    );
                  },
                ),
              ),

              // Amount input
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                            fontSize: 32, color: colors.onSurface),
                        decoration: InputDecoration(
                          label: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Amount',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          filled: true,
                          fillColor: AppColors.box,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    Padding(padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      NumberFormat
                        .simpleCurrency()
                        .currencySymbol,
                      style: TextStyle(
                          fontSize: 32, color: colors.primary),
                    ),
                    ),
                  ],
                ),
              ),
              const Divider(),

              // Date and time inputs
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Row(
                  children: [
                    // Date picker field
                    Flexible(
                      fit: FlexFit.loose,
                      child: GestureDetector(
                        onTap: _pickDate,
                        child: AbsorbPointer(
                          child: TextField(
                            controller: _dateController,
                            readOnly: true,
                            style: TextStyle(color: colors.onSurface),
                            decoration: InputDecoration(
                              label: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.background,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'Date',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              filled: true,
                              fillColor: AppColors.box,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              suffixIcon: Icon(Icons.calendar_today, color: AppColors.primary),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Time picker field
                    Flexible(
                      fit: FlexFit.loose,
                      child: GestureDetector(
                        onTap: _pickTime,
                        child: AbsorbPointer(
                          child: TextField(
                            controller: _timeController,
                            readOnly: true,
                            style: TextStyle(color: colors.onSurface),
                            decoration: InputDecoration(
                              label: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.background,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'Time',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              filled: true,
                              fillColor: AppColors.box,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              suffixIcon: Icon(Icons.access_time, color: colors.primary),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Account carousel
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: _buildAccountCarousel(colors),
              ),


              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildCategorySection(colors),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 32),
        color: AppColors.surface,
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: _saveTransaction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Save',
                  style: TextStyle(color: colors.onPrimary, fontSize: 20, fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8)
          ],
        ),
      ),
    );
  }
}