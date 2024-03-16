import 'package:dio/dio.dart';
import 'package:user_mobile_app/Utils/shared_preferences_utils.dart';
import 'package:user_mobile_app/constants/app_urls.dart';

class PaymentRepo {
  final dio = Dio();

  Future<Response> initiatePayment({required Map<String, dynamic> data}) async {
    final token = await SharedUtils.getToken();
    return await dio.post(
      AppUrls.initiatePaymentUrl,
      data: data,
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
  }

  Future<Response> confirmPayment({required Map<String, dynamic> data}) async {
    final token = await SharedUtils.getToken();
    return await dio.post(
      AppUrls.confirmPaymentUrl,
      data: data,
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
  }

  Future<Response> myPayments({required String sort}) async {
    final token = await SharedUtils.getToken();
    return await dio.get(
      AppUrls.myPayments,
      queryParameters: {'sort': sort},
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

  }

  Future<Response> updateKhalti({required String khalti}) async {
    final token = await SharedUtils.getToken();
    return await dio.put(
      AppUrls.currentUser,
      data: {
        'khaltiId': khalti,
      },
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
  }
}
