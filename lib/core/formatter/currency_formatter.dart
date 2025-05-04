import 'package:currency_formatter/currency_formatter.dart';

class AppCurrencyFormatter {
  static final CurrencyFormat _idrFormat = CurrencyFormat(
  code: 'idr',
  symbol: 'Rp',
  symbolSide: SymbolSide.left,
  thousandSeparator: '.',
  decimalSeparator: ',',
  symbolSeparator: ' ',
);

  static String format(num value) {
    return CurrencyFormatter.format(value, _idrFormat);
  }
}