import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/currency_exchange/data/models/currency_conversion_model.dart';

import '../../../../core/hive/hive_init.dart';

abstract class LocalCurrencyDataSource {
  Future<void> cacheConversion(CurrencyConversionModel conversion);
  CurrencyConversionModel? getLastConversion();
}

class LocalCurrencyDataSourceImpl extends LocalCurrencyDataSource {
  final HiveService hiveService;
  CurrencyConversionModel? _lastConversion;

  LocalCurrencyDataSourceImpl({required this.hiveService});

  @override
  Future<void> cacheConversion(CurrencyConversionModel conversion) async {
    try {
      _lastConversion = conversion;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  CurrencyConversionModel? getLastConversion() {
    return _lastConversion;
  }
}
