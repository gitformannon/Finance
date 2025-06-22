import 'package:flutter/material.dart';
import 'dart:convert';
import '../services/api_service.dart';
import '../models/transaction.dart';
import 'add_transaction_screen.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final List<Transaction> _transactions = [];
  final ScrollController _scrollController = ScrollController();
  static const int _pageSize = 20;
  int _loadedCount = 0;
  bool _loading = true;
  bool _loadingMore = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchTransactions();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_loadingMore &&
        _loadedCount < _transactions.length) {
      _loadMore();
    }
  }

  void _loadMore() {
    if (_loadedCount >= _transactions.length) return;
    setState(() {
      _loadingMore = true;
      _loadedCount = (_loadedCount + _pageSize).clamp(0, _transactions.length);
      _loadingMore = false;
    });
  }

  // Асинхронное получение списка транзакций с API
  Future<void> _fetchTransactions() async {
    try {
      final response = await ApiService.get('/transactions');
      if (response.statusCode == 200) {
        // Парсим ответ (ожидается JSON-массив транзакций)
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _transactions.clear();
          _transactions.addAll(
              data.map((item) => Transaction.fromJson(item)).toList());
          _loadedCount = _transactions.length > _pageSize
              ? _pageSize
              : _transactions.length;
          _loading = false;
          _loadingMore = false;
        });
      } else if (response.statusCode == 401) {
        // Не авторизован (например, токен истек или невалиден)
        setState(() {
          _error = 'Необходима авторизация. Пожалуйста, войдите снова.';
          _loading = false;
        });
        // В реальном приложении можно реализовать перенаправление на экран логина
      } else {
        // Прочие ошибки
        setState(() {
          _error = 'Ошибка загрузки транзакций (код ${response.statusCode})';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Ошибка сети: $e';
        _loading = false;
      });
    }
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
          child: Text(_error!, style: const TextStyle(color: Colors.red)));
    }
    if (_transactions.isEmpty) {
      return const Center(child: Text('Транзакции отсутствуют.'));
    }
    final totalCount = _loadedCount < _transactions.length
        ? _loadedCount + 1
        : _loadedCount;
    return ListView.builder(
      controller: _scrollController,
      itemCount: totalCount,
      itemBuilder: (context, index) {
        if (index >= _loadedCount) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final tx = _transactions[index];
        return ListTile(
          title: Text('${tx.amount} – ${tx.category}'),
          subtitle: Text('${tx.date} • ${tx.account}'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            builder: (_) => Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: const AddTransactionScreen(),
            ),
          );
          _fetchTransactions();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}