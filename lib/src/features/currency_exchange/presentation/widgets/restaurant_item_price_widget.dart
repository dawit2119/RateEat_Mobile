import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:rateeat_mobile/src/features/currency_exchange/presentation/bloc/bloc.dart';
import '../../../../core/constants/constants.dart';

// Reuse the currency map or import it if available.
// For this new file, I'm including the helper class here for completeness.
class CurrencyData {
  static const Map<String, String> supportedCurrencies = {
    'AED': 'United Arab Emirates Dirham',
    'AFN': 'Afghan Afghani',
    'ALL': 'Albanian Lek',
    'AMD': 'Armenian Dram',
    'ANG': 'NL Antillean Guilder',
    'AOA': 'Angolan Kwanza',
    'ARS': 'Argentine Peso',
    'AUD': 'Australian Dollar',
    'AWG': 'Aruban Florin',
    'AZN': 'Azerbaijani Manat',
    'BAM': 'Bosnia-Herzegovina Convertible Mark',
    'BBD': 'Barbadian Dollar',
    'BDT': 'Bangladeshi Taka',
    'BGN': 'Bulgarian Lev',
    'BHD': 'Bahraini Dinar',
    'BIF': 'Burundian Franc',
    'BMD': 'Bermudan Dollar',
    'BND': 'Brunei Dollar',
    'BOB': 'Bolivian Boliviano',
    'BRL': 'Brazilian Real',
    'BSD': 'Bahamian Dollar',
    'BTN': 'Bhutanese Ngultrum',
    'BWP': 'Botswanan Pula',
    'BYN': 'Belarusian Ruble',
    'BZD': 'Belize Dollar',
    'CAD': 'Canadian Dollar',
    'CDF': 'Congolese Franc',
    'CHF': 'Swiss Franc',
    'CLF': 'Unidad de Fomento',
    'CLP': 'Chilean Peso',
    'CNY': 'Chinese Yuan',
    'COP': 'Colombian Peso',
    'CRC': 'Costa Rican Colón',
    'CUC': 'Cuban Convertible Peso',
    'CUP': 'Cuban Peso',
    'CVE': 'Cape Verdean Escudo',
    'CZK': 'Czech Republic Koruna',
    'DJF': 'Djiboutian Franc',
    'DKK': 'Danish Krone',
    'DOP': 'Dominican Peso',
    'DZD': 'Algerian Dinar',
    'EGP': 'Egyptian Pound',
    'ERN': 'Eritrean Nakfa',
    'ETB': 'Ethiopian Birr',
    'EUR': 'Euro',
    'FJD': 'Fijian Dollar',
    'FKP': 'Falkland Islands Pound',
    'GBP': 'British Pound Sterling',
    'GEL': 'Georgian Lari',
    'GGP': 'Guernsey Pound',
    'GHS': 'Ghanaian Cedi',
    'GIP': 'Gibraltar Pound',
    'GMD': 'Gambian Dalasi',
    'GNF': 'Guinean Franc',
    'GTQ': 'Guatemalan Quetzal',
    'GYD': 'Guyanaese Dollar',
    'HKD': 'Hong Kong Dollar',
    'HNL': 'Honduran Lempira',
    'HRK': 'Croatian Kuna',
    'HTG': 'Haitian Gourde',
    'HUF': 'Hungarian Forint',
    'IDR': 'Indonesian Rupiah',
    'ILS': 'Israeli New Sheqel',
    'IMP': 'Manx Pound',
    'INR': 'Indian Rupee',
    'IQD': 'Iraqi Dinar',
    'IRR': 'Iranian Rial',
    'ISK': 'Icelandic Króna',
    'JEP': 'Jersey Pound',
    'JMD': 'Jamaican Dollar',
    'JOD': 'Jordanian Dinar',
    'JPY': 'Japanese Yen',
    'KES': 'Kenyan Shilling',
    'KGS': 'Kyrgystani Som',
    'KHR': 'Cambodian Riel',
    'KMF': 'Comorian Franc',
    'KPW': 'North Korean Won',
    'KRW': 'South Korean Won',
    'KWD': 'Kuwaiti Dinar',
    'KYD': 'Cayman Islands Dollar',
    'KZT': 'Kazakhstani Tenge',
    'LAK': 'Laotian Kip',
    'LBP': 'Lebanese Pound',
    'LKR': 'Sri Lankan Rupee',
    'LRD': 'Liberian Dollar',
    'LSL': 'Lesotho Loti',
    'LTL': 'Lithuanian Litas',
    'LVL': 'Latvian Lats',
    'LYD': 'Libyan Dinar',
    'MAD': 'Moroccan Dirham',
    'MDL': 'Moldovan Leu',
    'MGA': 'Malagasy Ariary',
    'MKD': 'Macedonian Denar',
    'MMK': 'Myanma Kyat',
    'MNT': 'Mongolian Tugrik',
    'MOP': 'Macanese Pataca',
    'MRO': 'Mauritanian Ouguiya',
    'MUR': 'Mauritian Rupee',
    'MVR': 'Maldivian Rufiyaa',
    'MWK': 'Malawian Kwacha',
    'MXN': 'Mexican Peso',
    'MYR': 'Malaysian Ringgit',
    'MZN': 'Mozambican Metical',
    'NAD': 'Namibian Dollar',
    'NGN': 'Nigerian Naira',
    'NIO': 'Nicaraguan Córdoba',
    'NOK': 'Norwegian Krone',
    'NPR': 'Nepalese Rupee',
    'NZD': 'New Zealand Dollar',
    'OMR': 'Omani Rial',
    'PAB': 'Panamanian Balboa',
    'PEN': 'Peruvian Nuevo Sol',
    'PGK': 'Papua New Guinean Kina',
    'PHP': 'Philippine Peso',
    'PKR': 'Pakistani Rupee',
    'PLN': 'Polish Zloty',
    'PYG': 'Paraguayan Guarani',
    'QAR': 'Qatari Rial',
    'RON': 'Romanian Leu',
    'RSD': 'Serbian Dinar',
    'RUB': 'Russian Ruble',
    'RWF': 'Rwandan Franc',
    'SAR': 'Saudi Riyal',
    'SBD': 'Solomon Islands Dollar',
    'SCR': 'Seychellois Rupee',
    'SDG': 'Sudanese Pound',
    'SEK': 'Swedish Krona',
    'SGD': 'Singapore Dollar',
    'SHP': 'Saint Helena Pound',
    'SLL': 'Sierra Leonean Leone',
    'SOS': 'Somali Shilling',
    'SRD': 'Surinamese Dollar',
    'STD': 'São Tomé and Príncipe Dobra',
    'SVC': 'Salvadoran Colón',
    'SYP': 'Syrian Pound',
    'SZL': 'Swazi Lilangeni',
    'THB': 'Thai Baht',
    'TJS': 'Tajikistani Somoni',
    'TMT': 'Turkmenistani Manat',
    'TND': 'Tunisian Dinar',
    'TOP': 'Tongan Paʻanga',
    'TRY': 'Turkish Lira',
    'TTD': 'Trinidad and Tobago Dollar',
    'TWD': 'New Taiwan Dollar',
    'TZS': 'Tanzanian Shilling',
    'UAH': 'Ukrainian Hryvnia',
    'UGX': 'Ugandan Shilling',
    'USD': 'US Dollar',
    'UYU': 'Uruguayan Peso',
    'UZS': 'Uzbekistan Som',
    'VEF': 'Venezuelan Bolívar',
    'VND': 'Vietnamese Dong',
    'VUV': 'Vanuatu Vatu',
    'WST': 'Samoan Tala',
    'XAF': 'CFA Franc BEAC',
    'XAG': 'Silver Ounce',
    'XAU': 'Gold Ounce',
    'XCD': 'East Caribbean Dollar',
    'XDR': 'Special Drawing Rights',
    'XOF': 'CFA Franc BCEAO',
    'XPF': 'CFP Franc',
    'YER': 'Yemeni Rial',
    'ZAR': 'South African Rand',
    'ZMK': 'Zambian Kwacha',
    'ZMW': 'Zambian Kwacha',
    'ZWL': 'Zimbabwean Dollar',
    'BTC': 'Bitcoin',
    'ETH': 'Ethereum',
    'BNB': 'Binance',
    'XRP': 'Ripple',
    'SOL': 'Solana',
    'DOT': 'Polkadot',
    'AVAX': 'Avalanche',
    'MATIC': 'Matic Token',
    'LTC': 'Litecoin',
    'ADA': 'Cardano'
  };
}

class RestaurantItemPriceWidget extends StatelessWidget {
  final double originalPrice;
  final String originalCurrency;
  final TextStyle? priceStyle;

  const RestaurantItemPriceWidget({
    Key? key,
    required this.originalPrice,
    required this.originalCurrency,
    this.priceStyle,
  }) : super(key: key);

  void _showCurrencySelector(BuildContext context, String currentCurrency) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => CurrencySelectionSheet(
        currentCurrency: currentCurrency,
        onCurrencySelected: (targetCurrency) {
          // Fire the event to update ALL items
          context.read<CurrencyBloc>().add(
                UpdateRestaurantCurrencyEvent(
                  fromCurrency: originalCurrency,
                  targetCurrency: targetCurrency,
                ),
              );
        },
      ),
    );
  }

  String _formatPrice(double price) {
    if (price == price.roundToDouble()) {
      return price.toInt().toString();
    }
    return price.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrencyBloc, CurrencyState>(
      buildWhen: (previous, current) {
        // Only rebuild if the rate update is relevant to this restaurant's currency
        if (current is CurrencyRateUpdated) {
          return current.fromCurrency == originalCurrency;
        }
        return current is CurrencyLoading || current is CurrencyError;
      },
      builder: (context, state) {
        // Default State (Original)
        double displayPrice = originalPrice;
        String displayCurrency = originalCurrency;
        bool isLoading = false;

        if (state is CurrencyLoading) {
          // Optional: You can show loading or just keep previous price
          isLoading = true;
        } else if (state is CurrencyRateUpdated &&
            state.fromCurrency == originalCurrency) {
          displayPrice = originalPrice * state.exchangeRate;
          displayCurrency = state.targetCurrency;
        }

        return GestureDetector(
          onTap: isLoading
              ? null
              : () => _showCurrencySelector(context, displayCurrency),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isLoading)
                    SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primaryColor,
                      ),
                    )
                  else
                    Text(
                      '${_formatPrice(displayPrice)} $displayCurrency',
                      style: priceStyle ??
                          GoogleFonts.poppins(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xffff3008),
                            height: 1.1,
                          ),
                    ),
                  const SizedBox(width: 2),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 16,
                    color: Color(0xffff3008),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Helper: Selection Sheet (Copied/Adapted for the new file)
class CurrencySelectionSheet extends StatefulWidget {
  final String currentCurrency;
  final Function(String) onCurrencySelected;

  const CurrencySelectionSheet({
    Key? key,
    required this.currentCurrency,
    required this.onCurrencySelected,
  }) : super(key: key);

  @override
  State<CurrencySelectionSheet> createState() => _CurrencySelectionSheetState();
}

class _CurrencySelectionSheetState extends State<CurrencySelectionSheet> {
  String searchQuery = '';
  late Map<String, String> filteredCurrencies;

  @override
  void initState() {
    super.initState();
    filteredCurrencies = CurrencyData.supportedCurrencies;
  }

  void _filterCurrencies(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        filteredCurrencies = CurrencyData.supportedCurrencies;
      } else {
        filteredCurrencies = Map.fromEntries(
          CurrencyData.supportedCurrencies.entries.where((entry) {
            final code = entry.key.toLowerCase();
            final name = entry.value.toLowerCase();
            final search = query.toLowerCase();
            return code.contains(search) || name.contains(search);
          }),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Text(
            'Select Currency',
            style: GoogleFonts.poppins(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            onChanged: _filterCurrencies,
            decoration: InputDecoration(
              hintText: 'Search (e.g., USD, Dollar)',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: filteredCurrencies.isEmpty
                ? const Center(child: Text("No currency found"))
                : ListView.builder(
                    itemCount: filteredCurrencies.length,
                    itemBuilder: (context, index) {
                      final code = filteredCurrencies.keys.elementAt(index);
                      final name = filteredCurrencies.values.elementAt(index);
                      final isSelected = widget.currentCurrency == code;
                      return ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            code.substring(0, 1),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(code,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600)),
                        subtitle: Text(name,
                            style: GoogleFonts.poppins(
                                fontSize: 12.sp, color: Colors.grey)),
                        trailing: isSelected
                            ? const Icon(Icons.check_circle,
                                color: Color(0xffff3008))
                            : null,
                        onTap: () {
                          Navigator.pop(context);
                          widget.onCurrencySelected(code);
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
