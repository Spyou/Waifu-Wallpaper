import 'package:get/get.dart';
import 'package:wpp/Models/waifu_wallpaper_model.dart';
import 'package:wpp/Repository/waifu_wallpaper_repo.dart';
import 'package:wpp/response/status.dart';

class HomeController extends GetxController {
  final _api = HomeRepository();

  final rxRequestStatus = Status.LOADING.obs;
  final userList = WaifuWallpaperModel().obs;
  RxString error = ''.obs;

  void setRxRequestStatus(Status value) => rxRequestStatus.value = value;
  void setUserList(WaifuWallpaperModel value) => userList.value = value;
  void setError(String value) => error.value = value;

  void sfwApi() {
    //  setRxRequestStatus(Status.LOADING);

    _api.sfwApi().then((value) {
      setRxRequestStatus(Status.COMPLETED);
      setUserList(value);
    }).onError((error, stackTrace) {
      setError(error.toString());
      setRxRequestStatus(Status.ERROR);
    });
  }

  void refreshApi() {
    setRxRequestStatus(Status.LOADING);

    _api.sfwApi().then((value) {
      setRxRequestStatus(Status.COMPLETED);
      setUserList(value);
    }).onError((error, stackTrace) {
      setError(error.toString());
      setRxRequestStatus(Status.ERROR);
    });
  }
}
