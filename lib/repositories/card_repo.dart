import 'package:card_mockapi_example/services/api_client.dart';
import 'package:card_mockapi_example/services/app_constants.dart';

class CardRepo {
  final ApiClient apiClient;

  CardRepo({required this.apiClient});

  Future getCardDataCall(page, limit) async {
    return await apiClient.get(
      AppConstants.getCards,
      queryParameters: {
        "page": page,
        "limit": limit,
        "sortBy": "priority",
        "order": "Asc",
      },
    );
  }
}
