import 'package:flutter/material.dart';
import 'package:cosplay_app/widgets/MyNavbar.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cosplay_app/widgets/UserSearchInfo.dart';
import 'package:cosplay_app/constants/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cosplay_app/widgets/RoundButton.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with AutomaticKeepAliveClientMixin {
  PageController pageController;
  PageView pageView;
  int navIndex = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: navIndex);
    pageView = PageView(
      onPageChanged: (index) {
        setState(() {
          navIndex = index;
        });
      },
      //physics: new NeverScrollableScrollPhysics(),
      controller: pageController,
      children: <Widget>[
        CosplayerSearchSection(),
        PhotographerSearchSection(),
      ],
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            MyNavbar(
              context: context,
              index: navIndex,
              onCosplayersTap: () {
                pageController.animateToPage(
                  0,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              },
              onPhotographersTap: () {
                pageController.animateToPage(
                  1,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              },
            ),
            Expanded(child: pageView),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 15.0, bottom: 100.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: RoundButton(
              icon: FontAwesomeIcons.cog,
              iconColor: Colors.white,
              fillColor: Colors.pinkAccent,
              onTap: () {},
            ),
          ),
        )
      ],
    );
  }
}

class CosplayerSearchSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        UserSearchInfo(
          name: "Ketano Reeve",
          cosplayName: "Cosplay Name",
          seriesName: "Anime/Tv Name",
          backgroundImage: NetworkImage(
              "https://c.pxhere.com/photos/0b/f9/anime_girl_japan_japanese_tokyo_cosplay-266599.jpg!d"),
          friendliness: 1532,
        ),
        UserSearchInfo(
          name: "Magical Girl",
          cosplayName: "Cosplay Name",
          seriesName: "Anime/Tv Name",
          backgroundImage: NetworkImage(
              "https://c.pxhere.com/photos/eb/33/china_girls_game_anime_cute_girl_japanese_costume-187564.jpg!d"),
          friendliness: 153,
        ),
        UserSearchInfo(
          name: "Shinano Arita",
          cosplayName: "Cosplay Name",
          seriesName: "Anime/Tv Name",
          backgroundImage: NetworkImage(
              "https://c.pxhere.com/photos/ff/89/girls_game_anime_cute_girl_japanese_costume_comic-187663.jpg!d"),
          friendliness: 1,
        ),
        UserSearchInfo(
          name: "Narito Menga",
          cosplayName: "Cosplay Name",
          seriesName: "Anime/Tv Name",
          backgroundImage: NetworkImage(
              "https://c.pxhere.com/photos/fc/88/boy_portrait_people_man_anime_face_35mm_comic-185839.jpg!d"),
          friendliness: 1532,
        ),
        UserSearchInfo(
          name: "Shitano Len Gauss",
          cosplayName: "Cosplay Name",
          seriesName: "Anime/Tv Name",
          backgroundImage: NetworkImage(
              "https://c.pxhere.com/photos/fb/84/50mm_anime_comic_comiccon_cosplay_costume_cute_face-343295.jpg!d"),
          friendliness: 142,
        ),
        UserSearchInfo(
          name: "Banani Loepr",
          cosplayName: "Cosplay Name",
          seriesName: "Anime/Tv Name",
          backgroundImage: NetworkImage(
              "https://c.pxhere.com/photos/d4/02/auto_pc_nikon_nikkor_f25_105mm-146568.jpg!d"),
          friendliness: 15222,
        ),
        UserSearchInfo(
          name: "Lesonga Chornasmo",
          cosplayName: "Cosplay Name",
          seriesName: "Anime/Tv Name",
          backgroundImage: NetworkImage(
              "https://c.pxhere.com/photos/bb/92/boy_portrait_people_man_anime_face_35mm_comic-185893.jpg!d"),
          friendliness: 1532,
        ),
        UserSearchInfo(
          name: "Ettai Gonchat",
          cosplayName: "Cosplay Name",
          seriesName: "Anime/Tv Name",
          backgroundImage: NetworkImage(
              "https://c.pxhere.com/photos/8a/12/girls_cute_girl_hair_japanese_costume_comic_expo-432382.jpg!d"),
          friendliness: 1532,
        ),
        UserSearchInfo(
          name: "Bob Willas",
          cosplayName: "Len",
          seriesName: "Vocaloid",
          friendliness: 1532,
        ),
        UserSearchInfo(
          name: "Junypai",
          cosplayName: "Len",
          seriesName: "Vocaloid",
          friendliness: 1532,
        ),
        UserSearchInfo(
          name: "Junypai",
          cosplayName: "Len",
          seriesName: "Vocaloid",
          friendliness: 1532,
        ),
        UserSearchInfo(
          name: "Junypai",
          cosplayName: "Len",
          seriesName: "Vocaloid",
          friendliness: 1532,
        ),
        SizedBox(
            height:
                90.0), // So the last item can be seen and not be scrunched in bottom
      ],
    );
  }
}

class PhotographerSearchSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        PhotographerSearchInfo(
          name: "Ettai Gonchat",
          yearsExperience: 12,
          monthsExperience: 2,
          backgroundImage: NetworkImage(
              "https://c.pxhere.com/images/29/3a/ab7eb8106f292a24d2a5d818c6a1-1418380.jpg!d"),
          friendliness: 324,
        ),
        PhotographerSearchInfo(
          name: "Resano Bobs",
          yearsExperience: 1,
          monthsExperience: 2,
          cost: "Can Negotiate",
          backgroundImage: NetworkImage(
              "https://c.pxhere.com/images/c7/21/c8e22db330eb09e78970ac8b2ce2-1456325.jpg!d"),
          friendliness: 153,
        ),
        PhotographerSearchInfo(
          name: "Ettai Gonchat",
          yearsExperience: 2,
          monthsExperience: 3,
          cost: "\$52.12 / hr",
          backgroundImage: NetworkImage(
              "https://c.pxhere.com/images/52/27/c8e31718a7e13b915f72689e7911-1424101.jpg!d"),
          friendliness: 45,
        ),
        PhotographerSearchInfo(
          name: "Ettai Gonchat",
          yearsExperience: 4,
          monthsExperience: 6,
          cost: "\$92.12 / session",
          backgroundImage: NetworkImage(
              "https://c.pxhere.com/photos/9d/fd/photographer_camera_photo_photos_foto_lens_take_a_photograph_electronic_equipment-942701.jpg!d"),
          friendliness: 1532,
        ),
        PhotographerSearchInfo(
          name: "Ettai Gonchat",
          yearsExperience: 12,
          monthsExperience: 2,
          cost: "Not shooting",
          backgroundImage: NetworkImage(
              "https://c.pxhere.com/images/29/3a/ab7eb8106f292a24d2a5d818c6a1-1418380.jpg!d"),
          friendliness: 1532,
        ),
        PhotographerSearchInfo(
          name: "Ettai Gonchat",
          yearsExperience: 12,
          monthsExperience: 2,
          backgroundImage: NetworkImage(
              "https://c.pxhere.com/images/29/3a/ab7eb8106f292a24d2a5d818c6a1-1418380.jpg!d"),
          friendliness: 1532,
        ),
        PhotographerSearchInfo(
          name: "Ettai Gonchat",
          yearsExperience: 12,
          monthsExperience: 2,
          cost: "\$15.00 / hr",
          backgroundImage: NetworkImage(
              "https://c.pxhere.com/images/29/3a/ab7eb8106f292a24d2a5d818c6a1-1418380.jpg!d"),
          friendliness: 1532,
        ),
        PhotographerSearchInfo(
          name: "Ettai Gonchat",
          yearsExperience: 12,
          monthsExperience: 2,
          backgroundImage: NetworkImage(
              "https://c.pxhere.com/images/29/3a/ab7eb8106f292a24d2a5d818c6a1-1418380.jpg!d"),
          friendliness: 1532,
        ),
        PhotographerSearchInfo(
          name: "Ettai Gonchat",
          yearsExperience: 12,
          monthsExperience: 2,
          backgroundImage: NetworkImage(
              "https://c.pxhere.com/images/29/3a/ab7eb8106f292a24d2a5d818c6a1-1418380.jpg!d"),
          friendliness: 1532,
        ),
        SizedBox(height: 90.0),
      ],
    );
  }
}
