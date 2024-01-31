import 'package:get/get.dart';
import 'package:wpp/Models/nsfw_waifu_model.dart';
import 'package:wpp/Repository/nsfw_wallpape_repo.dart';
import 'package:wpp/response/status.dart';

class NsfwController extends GetxController {
  final _api = NsfwRepository();

  final rxRequestStatus = Status.LOADING.obs;
  final userList = NsfwWallpaperModel().obs;
  RxString error = ''.obs;

  void setRxRequestStatus(Status value) => rxRequestStatus.value = value;
  void setUserList(NsfwWallpaperModel value) => userList.value = value;
  void setError(String value) => error.value = value;

  void nsfwApi() {
    //  setRxRequestStatus(Status.LOADING);

    _api.nsfwApi().then((value) {
      setRxRequestStatus(Status.COMPLETED);
      setUserList(value);
    }).onError((error, stackTrace) {
      setError(error.toString());
      setRxRequestStatus(Status.ERROR);
    });
  }

  void refreshApi() {
    setRxRequestStatus(Status.LOADING);

    _api.nsfwApi().then((value) {
      setRxRequestStatus(Status.COMPLETED);
      setUserList(value);
    }).onError((error, stackTrace) {
      setError(error.toString());
      setRxRequestStatus(Status.ERROR);
    });
  }
}
