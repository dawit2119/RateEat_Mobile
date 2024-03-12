import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/core/currency/currency.dart';

import '../../../../core/currency/general_currency_bloc.dart';

class CurrencyPage extends StatefulWidget {
  const CurrencyPage({super.key});

  @override
  State<CurrencyPage> createState() => _CurrencyPageState();
}

class _CurrencyPageState extends State<CurrencyPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppBar(
        onTap: () => context.pop(),
        title: AppLocalizations.of(context)!.currencyText,
      ),
      body: Column(
        children: [
          // Search TextField
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.06,
              vertical: screenHeight * 0.02,
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search currencies...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primaryColor,
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
          ),
          // Currency List
          Expanded(
            child: BlocBuilder<GeneralCurrencyBloc, GeneralCurrencyState>(
              builder: (context, state) {
                // Filter currencies based on search query
                var filteredCurrencies = Currency.values.where((currency) {
                  return currency.name.toLowerCase().contains(_searchQuery) ||
                      currency.code.toLowerCase().contains(_searchQuery) ||
                      currency.symbol.toLowerCase().contains(_searchQuery);
                }).toList();

                // Sort: selected currency comes first
                if (state.selectedCurrency != null) {
                  filteredCurrencies.sort((a, b) {
                    if (a == state.selectedCurrency) return -1;
                    if (b == state.selectedCurrency) return 1;
                    return 0;
                  });
                }

                if (filteredCurrencies.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Text(
                          'No currencies found',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.06,
                  ),
                  itemCount: filteredCurrencies.length,
                  itemBuilder: (context, index) {
                    final currency = filteredCurrencies[index];
                    final isSelected = currency == state.selectedCurrency;

                    return Padding(
                      padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                      child: Material(
                        elevation: isSelected ? 2 : 0,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryColor
                                  : Colors.grey[300]!,
                              width: isSelected ? 2 : 1,
                            ),
                            color: isSelected
                                ? AppColors.primaryColor.withOpacity(0.08)
                                : Colors.white,
                          ),
                          child: ListTile(
                            onTap: () {
                              HapticFeedback.selectionClick();
                              context.read<GeneralCurrencyBloc>().add(
                                    ChangeGeneralCurrency(
                                      selectedCurrency: currency,
                                    ),
                                  );
                            },
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            title: Text(
                              currency.name,
                              style: TextStyle(
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                color: isSelected
                                    ? AppColors.primaryColor
                                    : Colors.black87,
                              ),
                            ),
                            subtitle: Text(
                              '${currency.code} ${currency.symbol}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                            trailing: AnimatedOpacity(
                              opacity: isSelected ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 200),
                              child: const Icon(
                                Icons.check_circle_rounded,
                                color: AppColors.primaryColor,
                                size: 24,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
