import 'package:dio/dio.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';
import 'package:rateeat_mobile/src/features/review/data/models/price_item_review_request_model.dart';

abstract class ItemPriceReviewDataSource {
  //* Add Item Review
  Future<String> itemPriceReviewRequest(
      {required PriceItemReviewRequestModel itemPriceReviewRequestModel});
}

class ItemPriceReviewDataSourceImpl extends ItemPriceReviewDataSource {
  final Dio dio;
  ItemPriceReviewDataSourceImpl({required this.dio});

  @override
  Future<String> itemPriceReviewRequest(
      {required PriceItemReviewRequestModel
          itemPriceReviewRequestModel}) async {
    try {
      final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
      final body = {
        "price": itemPriceReviewRequestModel.price,
        "comment": itemPriceReviewRequestModel.description
      };

      final response = await dio.post(
          "$baseURL/items/${itemPriceReviewRequestModel.itemId}/priceReport",
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer ${user!.token}'
            },
          ),
          data: body);

      if (response.statusCode == 201) {
        return "Suggestion submitted successfully";
      } else {
        throw ServerException(errorMessage: response.data['message']);
      }
    } catch (e) {
      if (e is DioException) {
        throw ServerException(errorMessage: e.response?.data['message']);
      } else {
        throw ServerException(errorMessage: "Server Error");
      }
    }
  }
}
