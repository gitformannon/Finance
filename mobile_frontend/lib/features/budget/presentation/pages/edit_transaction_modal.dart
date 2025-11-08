import 'package:Finance/core/constants/app_colors.dart';
import 'package:Finance/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import '../../../../core/di/get_it.dart';
import '../../../../core/network/api_client.dart';
import '../../data/model/update_transaction_request.dart';
import '../../data/model/transaction.dart' as model;
import '../cubit/transaction_cubit.dart';
import '../widgets/budget_dropdown_field.dart';
import '../widgets/budget_input_field.dart';
import '../../../shared/presentation/widgets/app_buttons/save_button.dart';
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
      final req = UpdateTransactionRequest(
        id: widget.tx.id,
        categoryId: _categoryId,
        note: _noteCtrl.text.trim(),
      );
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
      child: Builder(
        builder: (context) {
          final media = MediaQuery.of(context);
          final viewInsets = media.viewInsets.bottom;
          final bottomPadding =
              viewInsets > 0 ? AppSizes.spaceM16 : media.padding.bottom;

          return SafeArea(
            top: false,
            child: AnimatedPadding(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              padding: EdgeInsets.only(bottom: viewInsets),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppSizes.borderSM16),
                  topRight: Radius.circular(AppSizes.borderSM16),
                ),
                child: Container(
                  color: AppColors.box,
                  padding: const EdgeInsets.all(AppSizes.paddingM),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BudgetInputField(label: 'Note', controller: _noteCtrl),
                      const SizedBox(height: 12),
                      BlocBuilder<TransactionCubit, TransactionState>(
                        builder: (context, state) {
                          final items = state.categories;
                          return BudgetDropdownField<String>(
                            label: 'Category',
                            value: _categoryId,
                            hintText: 'Select category',
                            onChanged: (v) => setState(() => _categoryId = v),
                            items:
                                items
                                    .map(
                                      (c) => DropdownMenuItem(
                                        value: c.id,
                                        child: Text(c.name),
                                      ),
                                    )
                                    .toList(),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: EdgeInsets.only(bottom: bottomPadding),
                        child: SaveButton(
                          onPressed: _submit,
                          isLoading: _saving,
                          isDisabled: _saving,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
