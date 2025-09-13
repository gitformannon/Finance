import 'package:Finance/core/constants/app_colors.dart';
import 'package:Finance/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../budget/data/model/account.dart' as model;
import '../../data/model/update_account_request.dart';
import '../../../../core/di/get_it.dart';
import '../../../../core/network/api_client.dart';

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
    _numberController = TextEditingController(text: widget.account.number ?? '');
    _institutionController = TextEditingController(text: widget.account.institution ?? '');
    _type = widget.account.type;
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
        accountNumber: _numberController.text.trim().isEmpty ? null : _numberController.text.trim(),
        accountType: _type,
        institution: _institutionController.text.trim().isEmpty ? null : _institutionController.text.trim(),
      );
      await getItInstance<ApiClient>().updateAccount(req.id, req.toJson());
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
                TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Name')),
                const SizedBox(height: 12),
                TextField(controller: _numberController, decoration: const InputDecoration(labelText: 'Account number')),
                const SizedBox(height: 12),
                TextField(controller: _institutionController, decoration: const InputDecoration(labelText: 'Institution (Bank)')),
                const SizedBox(height: 12),
                DropdownButton<int>(
                  value: _type,
                  hint: const Text('Account type'),
                  onChanged: (v) => setState(() => _type = v),
                  isExpanded: true,
                  items: _types.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))).toList(),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saving ? null : _submit,
                    child: _saving ? const CircularProgressIndicator() : const Text('Save'),
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

