import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:wpp/Views/nsfw_waifu.dart';
import 'package:wpp/components/general_exception.dart';
import 'package:wpp/components/internet_exception_widget.dart';
import 'package:wpp/controllers/home_controller.dart';
import 'package:wpp/res/utils/flushbar.dart';
import 'package:wpp/response/status.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final homeController = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    homeController.sfwApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Waifu Wallpaper',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        floatingActionButton: Container(
          margin: const EdgeInsets.only(left: 25),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  splashFactory: InkRipple.splashFactory,
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const NsfwPage()),
                      (route) => false);
                },
                child: const Row(
                  children: [
                    Text('NSFW 18+'),
                  ],
                ),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    splashFactory: InkRipple.splashFactory,
                  ),
                  onPressed: () {
                    homeController.sfwApi();
                  },
                  child: const Row(
                    children: [
                      Text('Next'),
                      Icon(Icons.navigate_next_rounded),
                    ],
                  )),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Obx(() {
            switch (homeController.rxRequestStatus.value) {
              case Status.LOADING:
                return const Center(child: CircularProgressIndicator());
              case Status.ERROR:
                if (homeController.error.value == 'No internet') {
                  return Center(
                    child: InterNetExceptionWidget(
                      onPress: () {
                        homeController.refreshApi();
                      },
                    ),
                  );
                } else {
                  return Center(
                    child: GeneralExceptionWidget(onPress: () {
                      homeController.refreshApi();
                    }),
                  );
                }
              case Status.COMPLETED:
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(children: [
                    SwipeTo(
                      animationDuration: const Duration(milliseconds: 300),
                      iconOnLeftSwipe: Icons.navigate_next_rounded,
                      iconSize: 60,
                      onLeftSwipe: () {
                        homeController.sfwApi();
                      },
                      child: InkWell(
                        splashFactory: InkRipple.splashFactory,
                        borderRadius: BorderRadius.circular(12),
                        onLongPress: () {
                          bottomSheet(context);
                        },
                        child: Container(
                          width: double.infinity,
                          height: 670,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              width: double.infinity,
                              height: 670,
                              imageUrl:
                                  homeController.userList.value.url.toString(),
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: Center(
                                  child: Text(
                                    '😁 Wait Image is Loading...',
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
                );
            }
          }),
        ));
  }

  Future<dynamic> bottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
            height: 175,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 57, 57, 57),
                  ),
                  height: 4,
                  width: 40,
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    minVerticalPadding: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    tileColor: const Color.fromARGB(255, 57, 57, 57),
                    titleTextStyle:
                        const TextStyle(fontWeight: FontWeight.w600),
                    onTap: () async {
                      String url = homeController.userList.value.url.toString();
                      await GallerySaver.saveImage(url,
                              albumName: 'Waifu Wallpaper')
                          .then(
                        (value) {
                          Navigator.pop(context);
                          // ignore: use_build_context_synchronously
                          Utils.flushBarMessage('Download Complete',
                              Icons.download_rounded, context);
                        },
                      );
                    },
                    title: const Center(child: Text('Downlaod Image')),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    tileColor: const Color.fromARGB(255, 57, 57, 57),
                    titleTextStyle:
                        const TextStyle(fontWeight: FontWeight.w600),
                    onTap: () {
                      Navigator.pop(context);
                    },
                    title: const Center(child: Text('Cancel')),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
