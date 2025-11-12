import 'package:Finance/core/constants/app_colors.dart';
import 'package:Finance/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import '../../../budget/data/model/account.dart' as model;
import '../../data/model/update_account_request.dart';
import '../../../../core/di/get_it.dart';
import '../widgets/budget_dropdown_field.dart';
import '../widgets/budget_input_field.dart';
import '../../../shared/presentation/widgets/app_buttons/save_button.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/widgets/emoji_picker/emoji_picker_button.dart';

class EditAccountModal extends StatefulWidget {
  final model.Account account;
  const EditAccountModal({super.key, required this.account});

  @override
  State<EditAccountModal> createState() => _EditAccountModalState();
}

class _EditAccountModalState extends State<EditAccountModal> {
  late final TextEditingController _nameController;
  late final TextEditingController _numberController;
  late final TextEditingController _institutionController;
  int? _type;
  String? _emoji;
  bool _saving = false;

  final Map<int, String> _types = const {
    1: 'Debit card',
    2: 'Credit card',
    3: 'Savings',
    4: 'Investment',
    5: 'Cash',
    6: 'Other',
  };

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.account.name ?? '');
    _numberController = TextEditingController(
      text: widget.account.number ?? '',
    );
    _institutionController = TextEditingController(
      text: widget.account.institution ?? '',
    );
    _type = widget.account.type;
    _emoji = widget.account.emoji_path;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    _institutionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _saving = true);
    try {
      final req = UpdateAccountRequest(
        id: widget.account.id,
        accountName: _nameController.text.trim(),
        accountNumber:
            _numberController.text.trim().isEmpty
                ? null
                : _numberController.text.trim(),
        accountType: _type,
        institution:
            _institutionController.text.trim().isEmpty
                ? null
                : _institutionController.text.trim(),
        emoji_path: _emoji,
      );
      await getItInstance<ApiClient>().updateAccount(req.id, req.toJson());
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
                BudgetInputField(
                  label: 'Account number',
                  controller: _numberController,
                ),
                const SizedBox(height: 12),
                BudgetInputField(
                  label: 'Institution (Bank)',
                  controller: _institutionController,
                ),
                const SizedBox(height: 12),
                BudgetDropdownField<int>(
                  label: 'Account type',
                  value: _type,
                  hintText: 'Select account type',
                  onChanged: (v) => setState(() => _type = v),
                  items:
                      _types.entries
                          .map(
                            (e) => DropdownMenuItem(
                              value: e.key,
                              child: Text(e.value),
                            ),
                          )
                          .toList(),
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
