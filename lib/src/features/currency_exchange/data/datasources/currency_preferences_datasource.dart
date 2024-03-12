import 'package:shared_preferences/shared_preferences.dart';

abstract class CurrencyPreferencesDataSource {
  Future<String?> getPreferredCurrency();
  Future<void> setPreferredCurrency(String currency);
  Future<Map<String, double>?> getCachedRates(String baseCurrency);
  Future<void> setCachedRates(String baseCurrency, Map<String, double> rates);
}

class CurrencyPreferencesDataSourceImpl extends CurrencyPreferencesDataSource {
  static const String _preferredCurrencyKey = 'preferred_currency';
  static const String _cachedRatesPrefix = 'cached_rates_';
  static const String _cacheTimestampPrefix = 'cache_timestamp_';
  static const int _cacheValidityHours = 1;

  @override
  Future<String?> getPreferredCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_preferredCurrencyKey);
  }

  @override
  Future<void> setPreferredCurrency(String currency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_preferredCurrencyKey, currency);
  }

  @override
  Future<Map<String, double>?> getCachedRates(String baseCurrency) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Check if cache is still valid
    final timestampKey = '$_cacheTimestampPrefix$baseCurrency';
    final timestamp = prefs.getInt(timestampKey);
    
    if (timestamp == null) return null;
    
    final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    
    if (now.difference(cacheTime).inHours > _cacheValidityHours) {
      // Cache expired, remove it
      await prefs.remove('$_cachedRatesPrefix$baseCurrency');
      await prefs.remove(timestampKey);
      return null;
    }
    
    // Get cached rates
    final ratesString = prefs.getString('$_cachedRatesPrefix$baseCurrency');
    if (ratesString == null) return null;
    
    try {
      final ratesMap = <String, double>{};
      final pairs = ratesString.split(',');
      
      for (final pair in pairs) {
        final parts = pair.split(':');
        if (parts.length == 2) {
          ratesMap[parts[0]] = double.parse(parts[1]);
        }
      }
      
      return ratesMap;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> setCachedRates(String baseCurrency, Map<String, double> rates) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Convert rates map to string
    final ratesString = rates.entries
        .map((entry) => '${entry.key}:${entry.value}')
        .join(',');
    
    // Save rates and timestamp
    await prefs.setString('$_cachedRatesPrefix$baseCurrency', ratesString);
    await prefs.setInt(
      '$_cacheTimestampPrefix$baseCurrency',
      DateTime.now().millisecondsSinceEpoch,
    );
  }
}