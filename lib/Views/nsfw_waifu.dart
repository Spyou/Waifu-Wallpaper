import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:wpp/Views/home_page.dart';
import 'package:wpp/controllers/nsfw_controller.dart';
import 'package:wpp/res/utils/flushbar.dart';
import 'package:wpp/response/status.dart';

class NsfwPage extends StatefulWidget {
  const NsfwPage({super.key});

  @override
  State<NsfwPage> createState() => _NsfwPageState();
}

class _NsfwPageState extends State<NsfwPage> {
  final nsfwController = Get.put(NsfwController());

  @override
  void initState() {
    super.initState();
    nsfwController.nsfwApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'NSFW Waifu Wallpaper',
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
                      MaterialPageRoute(builder: (context) => const HomePage()),
                      (route) => false);
                },
                child: const Row(
                  children: [
                    Text('SFW'),
                  ],
                ),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    splashFactory: InkRipple.splashFactory,
                  ),
                  onPressed: () {
                    nsfwController.nsfwApi();
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
            switch (nsfwController.rxRequestStatus.value) {
              case Status.LOADING:
                return const Center(child: CircularProgressIndicator());
              case Status.ERROR:
                return Center(
                  child: Text(
                    nsfwController.error.value,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                );
              case Status.COMPLETED:
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(children: [
                    SwipeTo(
                      animationDuration: const Duration(milliseconds: 300),
                      iconOnLeftSwipe: Icons.navigate_next_rounded,
                      iconSize: 60,
                      onLeftSwipe: () {
                        nsfwController.nsfwApi();
                      },
                      child: InkWell(
                        splashFactory: InkRipple.splashFactory,
                        borderRadius: BorderRadius.circular(12),
                        onLongPress: () {
                          bottomSheet(context);
                        },
                        child: Container(
                          height: 670,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl:
                                  nsfwController.userList.value.url.toString(),
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
                      String url = nsfwController.userList.value.url.toString();
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
