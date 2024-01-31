import 'package:wpp/Data/network/network_api_services.dart';
import 'package:wpp/Models/nsfw_waifu_model.dart';
import 'package:wpp/res/app_url/app_url.dart';

class NsfwRepository {
  final _apiService = NetworkApiServices();

  Future<NsfwWallpaperModel> nsfwApi() async {
    dynamic response = await _apiService.getApi(AppUrl.nsfwUrl);
    return NsfwWallpaperModel.fromJson(response);
  }
}
