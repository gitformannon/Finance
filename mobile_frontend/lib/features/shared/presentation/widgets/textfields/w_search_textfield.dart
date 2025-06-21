import 'package:agro_card_delivery/features/shared/presentation/widgets/textfields/w_masked_textfield.dart';
import 'package:flutter/material.dart';

class WSearchTextField extends StatelessWidget {
  final Function onSubmit;
  final TextEditingController? controller;
  final bool autofocus;

  const WSearchTextField({super.key, required this.onSubmit, this.controller,this.autofocus=false});

  @override
  Widget build(BuildContext context) {
    return WMaskedTextField(
      autofocus: autofocus,
      controller: controller,
      onSubmit: (value) => onSubmit(value),
      hintText: "Qidirish",
      // prefixIcon: SvgPicture.asset(
      //   AppSvgConst.search,
      //   fit: BoxFit.scaleDown,
      // ),
      textInputAction: TextInputAction.search,
    );
  }
}
