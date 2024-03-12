import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/features/currency_exchange/presentation/bloc/bloc.dart';

class CompactCurrencyPriceWidget extends StatefulWidget {
  final double originalPrice;
  final String originalCurrency;
  final TextStyle? style;
  final List<String> availableCurrencies;

  const CompactCurrencyPriceWidget({
    Key? key,
    required this.originalPrice,
    required this.originalCurrency,
    this.style,
    this.availableCurrencies = const ['USD', 'EUR', 'GBP', 'JPY'],
  }) : super(key: key);

  @override
  State<CompactCurrencyPriceWidget> createState() => _CompactCurrencyPriceWidgetState();
}

class _CompactCurrencyPriceWidgetState extends State<CompactCurrencyPriceWidget> {
  late String currentCurrency;
  late double currentPrice;
  bool isConverting = false;
  double? savedExchangeRate;

  @override
  void initState() {
    super.initState();
    currentCurrency = widget.originalCurrency;
    currentPrice = widget.originalPrice;
  }

  void _showCurrencySelector() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Currency'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: widget.availableCurrencies.map((currency) => 
            ListTile(
              title: Text(currency),
              trailing: currentCurrency == currency 
                ? const Icon(Icons.check, color: Colors.green, size: 16) 
                : null,
              onTap: () {
                Navigator.pop(context);
                _convertCurrency(currency);
              },
            ),
          ).toList(),
        ),
      ),
    );
  }

  void _convertCurrency(String toCurrency) {
    if (toCurrency == currentCurrency) return;

    setState(() => isConverting = true);

    context.read<CurrencyBloc>().add(ConvertCurrencyEvent(
      from: currentCurrency,
      to: toCurrency,
      amount: widget.originalPrice,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CurrencyBloc, CurrencyState>(
      listener: (context, state) {
        if (state is CurrencySuccess) {
          setState(() {
            savedExchangeRate = state.conversion.convertedAmount / widget.originalPrice;
            currentPrice = widget.originalPrice * savedExchangeRate!;
            currentCurrency = state.conversion.to;
            isConverting = false;
          });
        } else if (state is CurrencyError) {
          setState(() => isConverting = false);
        }
      },
      child: GestureDetector(
        onTap: _showCurrencySelector,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isConverting)
                const SizedBox(
                  width: 10,
                  height: 10,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: Colors.white,
                  ),
                )
              else
                Text(
                  '${_formatPrice(currentPrice)} $currentCurrency',
                  style: widget.style ?? const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(width: 4),
              const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    if (price == price.roundToDouble()) {
      return price.toInt().toString();
    }
    return price.toStringAsFixed(2);
  }
}