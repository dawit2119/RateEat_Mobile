import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/features/currency_exchange/presentation/bloc/bloc.dart';

class CurrencyPriceWidget extends StatefulWidget {
  final double originalPrice;
  final String originalCurrency;
  final TextStyle? priceStyle;
  final TextStyle? currencyStyle;
  final List<String> availableCurrencies;
  final bool showCurrencySelector;

  const CurrencyPriceWidget({
    Key? key,
    required this.originalPrice,
    required this.originalCurrency,
    this.priceStyle,
    this.currencyStyle,
    this.availableCurrencies = const ['USD', 'EUR', 'GBP', 'JPY', 'CAD'],
    this.showCurrencySelector = true,
  }) : super(key: key);

  @override
  State<CurrencyPriceWidget> createState() => _CurrencyPriceWidgetState();
}

class _CurrencyPriceWidgetState extends State<CurrencyPriceWidget> {
  late String currentCurrency;
  late double currentPrice;
  bool isConverting = false;

  @override
  void initState() {
    super.initState();
    currentCurrency = widget.originalCurrency;
    currentPrice = widget.originalPrice;
  }

  void _showCurrencySelector() {
    if (!widget.showCurrencySelector) return;

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Currency',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...widget.availableCurrencies.map((currency) => ListTile(
              title: Text(currency),
              trailing: currentCurrency == currency 
                ? const Icon(Icons.check, color: Colors.green) 
                : null,
              onTap: () {
                Navigator.pop(context);
                _convertCurrency(currency);
              },
            )),
          ],
        ),
      ),
    );
  }

  void _convertCurrency(String toCurrency) {
    if (toCurrency == currentCurrency) return;

    setState(() => isConverting = true);

    context.read<CurrencyBloc>().add(ConvertCurrencyEvent(
      from: widget.originalCurrency,
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
            currentPrice = state.conversion.convertedAmount;
            currentCurrency = state.conversion.to;
            isConverting = false;
          });
        } else if (state is CurrencyError) {
          setState(() => isConverting = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isConverting)
            const SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            Text(
              _formatPrice(currentPrice),
              style: widget.priceStyle ?? const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: widget.showCurrencySelector ? _showCurrencySelector : null,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: widget.showCurrencySelector ? BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.grey.shade300),
              ) : null,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    currentCurrency,
                    style: widget.currencyStyle ?? TextStyle(
                      fontSize: 12,
                      color: widget.showCurrencySelector 
                        ? Colors.blue 
                        : Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (widget.showCurrencySelector) ...[
                    const SizedBox(width: 2),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
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