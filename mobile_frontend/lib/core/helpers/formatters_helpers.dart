import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Formatters {
  static MaskTextInputFormatter phoneFormatter() => MaskTextInputFormatter(
    mask: '## ### ## ##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  static MaskTextInputFormatter cardFormatter() => MaskTextInputFormatter(
    mask: '#### #### #### ####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  static CurrencyTextInputFormatter currencyFormatter({
    String locale = 'uz',
    int decimalDigits = 0,
  }) =>
      CurrencyTextInputFormatter.currency(
        locale: locale,
        name: "",
        decimalDigits: decimalDigits,
      );

  static String moneyStringFormatter(double amount) {
    return currencyFormatter().formatDouble(amount);
  }

  static double dueAmountFunc({double total = 0, double preAmount = 0}) {
    return total >= preAmount ? total - preAmount : 0;
  }

  static String convertAndCheckAmount({double total = 0, double preAmount = 0}) {
    return moneyStringFormatter(dueAmountFunc(total: total, preAmount: preAmount));
  }

  static String formatUzbekPhoneNumber(String phoneNumber) {
    if (phoneNumber.length == 9) {
      return "${phoneNumber.substring(0, 2)} ${phoneNumber.substring(2, 5)} ${phoneNumber.substring(5, 7)} ${phoneNumber.substring(7)}";
    }
    return phoneNumber;
  }
}
