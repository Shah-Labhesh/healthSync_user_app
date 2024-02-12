import 'package:dio/dio.dart';
import 'package:user_mobile_app/Utils/shared_preferences_utils.dart';
import 'package:user_mobile_app/constants/app_urls.dart';

class FavoriteRepo{

  final Dio dio = Dio();

  Future<Response> getFavorite() async {
    final token = await SharedUtils.getToken();
    Response response = await dio.get(
      AppUrls.getFavouriteDoctors,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response;
  }

  Future<Response> toggleFavourite(String doctorId) async {
    final token = await SharedUtils.getToken();
    Response response = await dio.post(
      AppUrls.toggleFavourite(doctorId: doctorId),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response;
  }
}