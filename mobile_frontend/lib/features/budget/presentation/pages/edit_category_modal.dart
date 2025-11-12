import 'package:Finance/core/constants/app_colors.dart';
import 'package:Finance/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import '../../../../core/helpers/enums_helpers.dart';
import '../../data/model/category.dart' as model;
import '../../data/model/update_category_request.dart';
import '../../../../core/di/get_it.dart';
import '../widgets/budget_input_field.dart';
import '../../../shared/presentation/widgets/app_buttons/save_button.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/widgets/emoji_picker/emoji_picker_button.dart';

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
  String? _emoji;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category.name);
    _budgetController = TextEditingController(
      text:
          (widget.category.budget ?? 0) == 0 ? '' : '${widget.category.budget}',
    );
    _type = widget.category.type;
    _emoji = widget.category.emoji_path;
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
        budget:
            _type == CategoryType.purchase
                ? int.tryParse(_budgetController.text.trim())
                : null,
        emoji_path: _emoji,
      );
      await getItInstance<ApiClient>().updateCategory(req.id, req.toJson());
      if (mounted) Navigator.pop(context, true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                Row(
                  children: [
                    ChoiceChip(
                      label: const Text('Income'),
                      selected: _type == CategoryType.income,
                      onSelected:
                          (_) => setState(() => _type = CategoryType.income),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Purchase'),
                      selected: _type == CategoryType.purchase,
                      onSelected:
                          (_) => setState(() => _type = CategoryType.purchase),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: BudgetInputField(label: 'Name', controller: _nameController),
                    ),
                    const SizedBox(width: AppSizes.spaceM16),
                    EmojiPickerButton(
                      selectedEmoji: _emoji,
                      onEmojiSelected: (emoji) {
                        setState(() => _emoji = emoji);
                      },
                      size: 48,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (_type == CategoryType.purchase)
                  BudgetInputField(
                    label: 'Monthly budget (UZS)',
                    controller: _budgetController,
                    keyboardType: TextInputType.number,
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
  }
}
