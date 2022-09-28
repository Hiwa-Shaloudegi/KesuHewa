import 'dart:ui';

import 'package:KesuHewa/controllers/home_page_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HomePage extends StatelessWidget {
  HomePageController homePageController = Get.put(HomePageController());

  var searchController = TextEditingController();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        // leading: Row(children: [const Text('Friday 28 June 2019', style: TextStyle(color: Colors.grey,fontSize: 11),),],),
        centerTitle: true,

        title: const Text('Weather Forecast App'),
        actions: [
          PopupMenuButton(
            // TODO fixing PopupMenuButton functionality
            onSelected: (value) {

               if (value == 0) {
                 onShare();
               } else {

               }

            },
              itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 0,
                      child: Row(
                        children: const [
                          Icon(
                            Icons.share,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text("Share")
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 1,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 22,
                            child: Image.asset(
                              'assets/images/github-logo.png',
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text("Github")
                        ],
                      ),
                    ),
                  ],
          ),
          // Icon(Icons.more_vert_rounded),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/pic_bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            // color: Colors.blue,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Obx(
              () => homePageController.loading.value == true
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LoadingAnimationWidget.staggeredDotsWave(
                            color: Colors.white,
                            size: 70,
                          ),
                          searchController.text == ""
                              ? const SizedBox()
                              : Text(
                                  'Searching for ${searchController.text.capitalize}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(12, 0, 12, 24),
                                child: TextField(
                                  controller: searchController,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    letterSpacing: 1,
                                  ),
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    hintText: 'Enter the city',
                                    hintStyle: TextStyle(
                                      color: Colors.white60,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                homePageController
                                    .getWeatherData(searchController.text);
                                //TODO fix snackBar
                                if (homePageController.isSnackBar.value ==
                                    true) {
                                  Get.snackbar('Error',
                                      "Looks like this city doesn't exist!");
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Colors.deepPurple,
                                ),
                              ),
                              child: const Text('Find'),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child:
                              homePageController.weather.value.cityName == null
                                  ? shimmerContainer(180, 40)
                                  : Text(
                                      '${homePageController.weather.value.cityName}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 32,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 2,
                                      ),
                                    ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child:
                              homePageController.weather.value.cityName == null
                                  ? shimmerContainer(90, 30)
                                  : Text(
                                      '${homePageController.weather.value.description}',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 20,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: homePageController.weather.value.icon == null
                              ? shimmerContainer(50, 50)
                              : Image.asset(
                                  '${homePageController.weather.value.icon}',
                                  scale: 1.2,
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          child: homePageController.weather.value.temp == null
                              ? shimmerContainer(90, 30)
                              : Text(
                                  ' ${homePageController.weather.value.temp.round()}°',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 65,
                                    fontWeight: FontWeight.w200,
                                  ),
                                ),
                        ),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              children: [
                                const Text(
                                  'max',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18,
                                    letterSpacing: 1,
                                  ),
                                ),
                                const SizedBox(
                                  height: 14,
                                ),
                                homePageController.weather.value.tempMax == null
                                    ? shimmerContainer(90, 30)
                                    : Text(
                                        '${homePageController.weather.value.tempMax.round()}°',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Container(
                                width: 0.75,
                                height: 36,
                                color: Colors.grey,
                              ),
                            ),
                            Column(
                              children: [
                                const Text(
                                  'min',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(
                                  height: 14,
                                ),
                                homePageController.weather.value.tempMin == null
                                    ? shimmerContainer(90, 30)
                                    : Text(
                                        '${homePageController.weather.value.tempMin.round()}°',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Divider(
                            color: Colors.grey[400],
                            height: 1,
                            indent: 30,
                            endIndent: 30,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 14),
                          width: double.infinity,
                          height: 92,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: 15,
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Column(
                                children: const [
                                  Text(
                                    'Fri  8PM',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      letterSpacing: 0.75,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Icon(
                                    Icons.cloudy_snowing,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    '14',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Divider(
                            color: Colors.grey[400],
                            height: 1,
                            indent: 30,
                            endIndent: 30,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 7,
                          ),
                          height: 65,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  const Text(
                                    'wind speed',
                                    style: TextStyle(
                                      color: Colors.white60,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  homePageController.weather.value.cityName ==
                                          null
                                      ? shimmerContainer(45, 15)
                                      : Text(
                                          '${homePageController.weather.value.windSpeed} m/s',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                          ),
                                        ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Container(
                                  width: 0.75,
                                  height: 36,
                                  color: Colors.grey,
                                ),
                              ),
                              Column(
                                children: [
                                  const Text(
                                    'sunrise',
                                    style: TextStyle(
                                      color: Colors.white60,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  homePageController.weather.value.cityName ==
                                          null
                                      ? shimmerContainer(45, 15)
                                      : Text(
                                          '${homePageController.weather.value.sunrise} AM',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                          ),
                                        ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Container(
                                  width: 0.75,
                                  height: 36,
                                  color: Colors.grey,
                                ),
                              ),
                              Column(
                                children: [
                                  const Text(
                                    'sunset',
                                    style: TextStyle(
                                        color: Colors.white60, fontSize: 15),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  homePageController.weather.value.cityName ==
                                          null
                                      ? shimmerContainer(45, 15)
                                      : Text(
                                          '${homePageController.weather.value.sunset} PM',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                          ),
                                        ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Container(
                                  width: 0.75,
                                  height: 36,
                                  color: Colors.grey,
                                ),
                              ),
                              Column(
                                children: [
                                  const Text(
                                    'humidity',
                                    style: TextStyle(
                                      color: Colors.white60,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  homePageController.weather.value.cityName ==
                                          null
                                      ? shimmerContainer(45, 15)
                                      : Text(
                                          '${homePageController.weather.value.humidity}%',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                          ),
                                        ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Shimmer shimmerContainer(double widths, double heights) {
    return Shimmer.fromColors(
      baseColor: Colors.grey,
      highlightColor: Colors.white,
      child: Container(
        width: widths,
        height: heights,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(32),
        ),
      ),
    );
  }


  void onShare() async {
    Share.share('check out my app here https://youtube.com', subject: 'Look what I made!');

  }
}
