import 'package:Finance/core/constants/app_colors.dart';
import 'package:Finance/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import '../../../../core/di/get_it.dart';
import '../../../../core/network/api_client.dart';
import '../../data/model/update_transaction_request.dart';
import '../../data/model/transaction.dart' as model;
import '../cubit/transaction_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditTransactionModal extends StatefulWidget {
  final model.Transaction tx;
  const EditTransactionModal({super.key, required this.tx});

  @override
  State<EditTransactionModal> createState() => _EditTransactionModalState();
}

class _EditTransactionModalState extends State<EditTransactionModal> {
  late final TextEditingController _noteCtrl;
  String? _categoryId;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _noteCtrl = TextEditingController(text: widget.tx.title);
  }

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _saving = true);
    try {
      final req = UpdateTransactionRequest(id: widget.tx.id, categoryId: _categoryId, note: _noteCtrl.text.trim());
      await getItInstance<ApiClient>().updateTransaction(req.id, req.toJson());
      if (mounted) Navigator.pop(context, true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getItInstance<TransactionCubit>()..loadCategories(),
      child: Scaffold(
        backgroundColor: AppColors.transparent,
        body: SafeArea(
          top: false,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(AppSizes.borderSM16), topRight: Radius.circular(AppSizes.borderSM16)),
            child: Container(
              color: AppColors.box,
              padding: const EdgeInsets.all(AppSizes.paddingM),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: _noteCtrl, decoration: const InputDecoration(labelText: 'Note')),
                  const SizedBox(height: 12),
                  BlocBuilder<TransactionCubit, TransactionState>(
                    builder: (context, state) {
                      final items = state.categories;
                      return DropdownButton<String>(
                        isExpanded: true,
                        value: _categoryId,
                        hint: const Text('Category'),
                        items: items.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
                        onChanged: (v) => setState(() => _categoryId = v),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _saving ? null : _submit, child: _saving ? const CircularProgressIndicator() : const Text('Save')))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
