import 'package:Finance/core/constants/app_colors.dart';
import 'package:Finance/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import '../../../../core/helpers/enums_helpers.dart';
import '../../data/model/category.dart' as model;
import '../../data/model/update_category_request.dart';
import '../../../../core/di/get_it.dart';
import '../../../../core/network/api_client.dart';

class EditCategoryModal extends StatefulWidget {
  final model.Category category;
  const EditCategoryModal({super.key, required this.category});

  @override
  State<EditCategoryModal> createState() => _EditCategoryModalState();
}

class _EditCategoryModalState extends State<EditCategoryModal> {
  late final TextEditingController _nameController;
  late final TextEditingController _budgetController;
  late CategoryType _type;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category.name);
    _budgetController = TextEditingController(text: (widget.category.budget ?? 0) == 0 ? '' : '${widget.category.budget}');
    _type = widget.category.type;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _saving = true);
    try {
      final req = UpdateCategoryRequest(
        id: widget.category.id,
        name: _nameController.text.trim(),
        type: _type.value,
        budget: _type == CategoryType.purchase ? int.tryParse(_budgetController.text.trim()) : null,
      );
      await getItInstance<ApiClient>().updateCategory(req.id, req.toJson());
      if (mounted) Navigator.pop(context, true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Row(children: [
                  ChoiceChip(label: const Text('Income'), selected: _type == CategoryType.income, onSelected: (_) => setState(() => _type = CategoryType.income)),
                  const SizedBox(width: 8),
                  ChoiceChip(label: const Text('Purchase'), selected: _type == CategoryType.purchase, onSelected: (_) => setState(() => _type = CategoryType.purchase)),
                ]),
                const SizedBox(height: 12),
                TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Name')),
                const SizedBox(height: 12),
                if (_type == CategoryType.purchase)
                  TextField(
                    controller: _budgetController,
                    decoration: const InputDecoration(labelText: 'Monthly budget (UZS)'),
                    keyboardType: TextInputType.number,
                  ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saving ? null : _submit,
                    child: _saving ? const CircularProgressIndicator() : const Text('Save'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

