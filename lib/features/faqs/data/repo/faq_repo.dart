import 'package:dio/dio.dart';
import 'package:user_mobile_app/Utils/shared_preferences_utils.dart';
import 'package:user_mobile_app/constants/app_urls.dart';

class FAQRepo {
  final dio = Dio();

  Future<Response> getFAQs() async {
    final token = await SharedUtils.getToken();
    return await dio.get(
      AppUrls.faqs,
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
  }
}
