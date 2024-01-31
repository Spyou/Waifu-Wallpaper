import 'package:wpp/Data/network/network_api_services.dart';
import 'package:wpp/Models/waifu_wallpaper_model.dart';
import 'package:wpp/res/app_url/app_url.dart';

class HomeRepository {
  final _apiService = NetworkApiServices();

  Future<WaifuWallpaperModel> sfwApi() async {
    dynamic response = await _apiService.getApi(AppUrl.waifuUrl);
    return WaifuWallpaperModel.fromJson(response);
  }
}
