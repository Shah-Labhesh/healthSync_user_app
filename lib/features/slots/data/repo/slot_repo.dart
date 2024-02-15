import 'package:dio/dio.dart';
import 'package:user_mobile_app/Utils/shared_preferences_utils.dart';
import 'package:user_mobile_app/constants/app_urls.dart';

class SlotRepo {
  final dio = Dio();

  Future<Response> addSlot({required Map<String, dynamic> data}) async {
    final token = await SharedUtils.getToken();
    Response response = await dio.post(
      AppUrls.addSlot,
      data: data,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response;
  }

  Future<Response> getMySlots({required String sort}) async {
    final token = await SharedUtils.getToken();
    Response response = await dio.get(
      AppUrls.getMySlots,
      queryParameters: {'sort': sort},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response;
  }

  Future<Response> updateSlot(
      {required String slotId, required Map<String, dynamic> data}) async {
    final token = await SharedUtils.getToken();
    Response response = await dio.put(
      AppUrls.updateOrDeleteSlot(slotId: slotId),
      data: data,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return response;
  }

  Future<Response> deleteSlot({required String slotId}) async {
    final token = await SharedUtils.getToken();
    Response response = await dio.delete(
      AppUrls.updateOrDeleteSlot(slotId: slotId),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response;
  }
}
