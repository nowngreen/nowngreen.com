import 'package:avatar_glow/avatar_glow.dart';
import 'package:nowlive/pages/search.dart';
import 'package:nowlive/pages/sectionbytype.dart';
import 'package:nowlive/pages/videosbyid.dart';
import 'package:nowlive/provider/findprovider.dart';
import 'package:nowlive/shimmer/shimmerutils.dart';
import 'package:nowlive/utils/color1.dart';
import 'package:nowlive/utils/strings.dart';
import 'package:nowlive/utils/utils.dart';
import 'package:nowlive/widget/myimage.dart';
import 'package:nowlive/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class Find extends StatefulWidget {
  const Find({Key? key}) : super(key: key);

  @override
  State<Find> createState() => FindState();
}

class FindState extends State<Find> {
  final searchController = TextEditingController();
  late FindProvider findProvider = FindProvider();
  final SpeechToText _speechToText = SpeechToText();
  bool speechEnabled = false, _isListening = false;
  String _lastWords = '';

  @override
  void initState() {
    _getData();
    findProvider = Provider.of<FindProvider>(context, listen: false);
    _initSpeech();
    super.initState();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    debugPrint("<============== _startListening ==============>");
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {
      _isListening = true;
    });
    Future.delayed(const Duration(seconds: 5), () {
      if (_isListening && searchController.text.toString().isEmpty) {
        Utils.showSnackbar(context, "info", "speechnotavailable", true);
        _stopListening();
      }
    });
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    debugPrint("<============== _stopListening ==============>");
    await _speechToText.stop();
    if (!mounted) return;
    setState(() {
      _lastWords = '';
      _isListening = false;
    });
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) async {
    debugPrint("<============== _onSpeechResult ==============>");
    _lastWords = result.recognizedWords;
    debugPrint("_lastWords ==============> $_lastWords");
    if (_lastWords.isNotEmpty && _isListening) {
      searchController.text = _lastWords.toString();
      _isListening = false;
      if (!mounted) return;
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return Search(
              searchText: searchController.text.toString(),
            );
          },
        ),
      );
      setState(() {
        _lastWords = '';
        searchController.clear();
      });
    }
  }

  void _getData() async {
    findProvider = Provider.of<FindProvider>(context, listen: false);
    findProvider.getSectionType();
    findProvider.getGenres();
    findProvider.getLanguage();
    Future.delayed(Duration.zero).then((value) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _stopListening();
    searchController.dispose();
    findProvider.clearProvider();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appBgColor,
      body: SafeArea(
        child: RefreshIndicator(
          backgroundColor: white,
          color: complimentryColor,
          displacement: 80,
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 1500))
                .then((value) {
              _getData();
            });
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 15),

                /* Search Box */
                searchBox(),
                const SizedBox(height: 22),

                /* Genres */
                Consumer<FindProvider>(
                  builder: (context, findProvider, child) {
                    debugPrint(
                        "setGenresSize  ===>  ${findProvider.setGenresSize}");
                    debugPrint(
                        "genresModel Size  ===>  ${(findProvider.genresModel.result?.length ?? 0)}");
                    if (findProvider.loading) {
                      return ShimmerUtils.buildFindShimmer(context);
                    } else {
                      if (findProvider.genresModel.status == 200) {
                        if (findProvider.genresModel.result != null &&
                            (findProvider.genresModel.result?.length ?? 0) >
                                0) {
                          return Column(
                            children: [
                              /* Browse by START */
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                alignment: Alignment.centerLeft,
                                child: MyText(
                                  color: white,
                                  text: "browsby",
                                  multilanguage: true,
                                  textalign: TextAlign.center,
                                  fontsizeNormal: 15,
                                  fontsizeWeb: 16,
                                  maxline: 1,
                                  overflow: TextOverflow.ellipsis,
                                  fontweight: FontWeight.w600,
                                  fontstyle: FontStyle.normal,
                                ),
                              ),
                              const SizedBox(height: 10),
                              AlignedGridView.count(
                                shrinkWrap: true,
                                crossAxisCount: 2,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                itemCount: (findProvider
                                        .sectionTypeModel.result?.length ??
                                    0),
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder:
                                    (BuildContext context, int position) {
                                  return InkWell(
                                    borderRadius: BorderRadius.circular(4),
                                    onTap: () {
                                      debugPrint("Item Clicked! => $position");
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => SectionByType(
                                              findProvider.sectionTypeModel
                                                      .result?[position].id ??
                                                  0,
                                              findProvider.sectionTypeModel
                                                      .result?[position].name ??
                                                  "",
                                              "2"),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      height: 65,
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 10, 0),
                                      decoration: BoxDecoration(
                                        color: colorPrimaryDark,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      alignment: Alignment.center,
                                      child: MyText(
                                        color: white,
                                        text: findProvider.sectionTypeModel
                                                .result?[position].name ??
                                            "",
                                        textalign: TextAlign.center,
                                        fontstyle: FontStyle.normal,
                                        multilanguage: false,
                                        fontsizeNormal: 14,
                                        fontsizeWeb: 14,
                                        fontweight: FontWeight.w600,
                                        maxline: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              /* Browse by END */

                              /* AdMob Banner */
                              const SizedBox(height: 10),
                              Utils.showBannerAd(context),
                              const SizedBox(height: 12),

                              /* Genres START */
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                alignment: Alignment.centerLeft,
                                child: MyText(
                                  color: white,
                                  text: "genres",
                                  textalign: TextAlign.center,
                                  fontsizeNormal: 15,
                                  fontsizeWeb: 16,
                                  fontweight: FontWeight.w600,
                                  multilanguage: true,
                                  maxline: 1,
                                  overflow: TextOverflow.ellipsis,
                                  fontstyle: FontStyle.normal,
                                ),
                              ),
                              const SizedBox(height: 15),
                              AlignedGridView.count(
                                shrinkWrap: true,
                                crossAxisCount: 1,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                itemCount: findProvider.setGenresSize <
                                        (findProvider
                                                .genresModel.result?.length ??
                                            0)
                                    ? findProvider.setGenresSize
                                    : (findProvider
                                            .genresModel.result?.length ??
                                        0),
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder:
                                    (BuildContext context, int position) {
                                  return Column(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 0.9,
                                        color: lightBlack,
                                      ),
                                      InkWell(
                                        borderRadius: BorderRadius.circular(4),
                                        onTap: () {
                                          debugPrint(
                                              "Item Clicked! => $position");
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return VideosByID(
                                                  findProvider
                                                          .genresModel
                                                          .result?[position]
                                                          .id ??
                                                      0,
                                                  0,
                                                  findProvider
                                                          .genresModel
                                                          .result?[position]
                                                          .name ??
                                                      "",
                                                  "ByCategory",
                                                );
                                              },
                                            ),
                                          );
                                        },
                                        child: SizedBox(
                                          height: 47,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              MyText(
                                                color: otherColor,
                                                text: findProvider
                                                        .genresModel
                                                        .result?[position]
                                                        .name ??
                                                    "",
                                                textalign: TextAlign.center,
                                                fontsizeNormal: 13,
                                                fontsizeWeb: 14,
                                                multilanguage: false,
                                                maxline: 1,
                                                overflow: TextOverflow.ellipsis,
                                                fontweight: FontWeight.w500,
                                                fontstyle: FontStyle.normal,
                                              ),
                                              MyImage(
                                                width: 13,
                                                height: 13,
                                                color: otherColor,
                                                imagePath: "ic_right.png",
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              Visibility(
                                visible: findProvider.isGenSeeMore,
                                child: InkWell(
                                  onTap: () {
                                    final findProvider =
                                        Provider.of<FindProvider>(context,
                                            listen: false);
                                    findProvider.setGenSeeMore(false);
                                    findProvider.setGenresListSize(findProvider
                                            .genresModel.result?.length ??
                                        0);
                                  },
                                  child: Container(
                                    height: 30,
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    alignment: Alignment.centerLeft,
                                    child: MyText(
                                      color: colorPrimary,
                                      text: "seemore",
                                      textalign: TextAlign.center,
                                      fontsizeNormal: 14,
                                      maxline: 1,
                                      multilanguage: true,
                                      overflow: TextOverflow.ellipsis,
                                      fontweight: FontWeight.w500,
                                      fontstyle: FontStyle.normal,
                                    ),
                                  ),
                                ),
                              ),
                              /* Genres END */

                              /* AdMob Banner */
                              const SizedBox(height: 10),
                              Utils.showBannerAd(context),
                              const SizedBox(height: 20),

                              /* Language START */
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                alignment: Alignment.centerLeft,
                                child: MyText(
                                  color: white,
                                  multilanguage: true,
                                  text: "language_",
                                  textalign: TextAlign.center,
                                  fontsizeNormal: 15,
                                  fontsizeWeb: 16,
                                  maxline: 1,
                                  overflow: TextOverflow.ellipsis,
                                  fontweight: FontWeight.w600,
                                  fontstyle: FontStyle.normal,
                                ),
                              ),
                              const SizedBox(height: 15),
                              AlignedGridView.count(
                                shrinkWrap: true,
                                crossAxisCount: 1,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                itemCount: findProvider.setLanguageSize <
                                        (findProvider
                                                .langaugeModel.result?.length ??
                                            0)
                                    ? findProvider.setLanguageSize
                                    : (findProvider
                                            .langaugeModel.result?.length ??
                                        0),
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder:
                                    (BuildContext context, int position) {
                                  return Column(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 0.9,
                                        color: lightBlack,
                                      ),
                                      InkWell(
                                        borderRadius: BorderRadius.circular(4),
                                        onTap: () {
                                          debugPrint(
                                              "Item Clicked! => $position");
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return VideosByID(
                                                  findProvider
                                                          .langaugeModel
                                                          .result?[position]
                                                          .id ??
                                                      0,
                                                  0,
                                                  findProvider
                                                          .langaugeModel
                                                          .result?[position]
                                                          .name ??
                                                      "",
                                                  "ByLanguage",
                                                );
                                              },
                                            ),
                                          );
                                        },
                                        child: SizedBox(
                                          height: 47,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              MyText(
                                                color: otherColor,
                                                text: findProvider
                                                        .langaugeModel
                                                        .result?[position]
                                                        .name ??
                                                    "",
                                                textalign: TextAlign.center,
                                                fontsizeNormal: 13,
                                                fontsizeWeb: 14,
                                                multilanguage: false,
                                                maxline: 1,
                                                overflow: TextOverflow.ellipsis,
                                                fontweight: FontWeight.w500,
                                                fontstyle: FontStyle.normal,
                                              ),
                                              MyImage(
                                                width: 13,
                                                height: 13,
                                                color: otherColor,
                                                imagePath: "ic_right.png",
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              Visibility(
                                visible: findProvider.isLangSeeMore,
                                child: InkWell(
                                  onTap: () {
                                    final findProvider =
                                        Provider.of<FindProvider>(context,
                                            listen: false);
                                    findProvider.setLangSeeMore(false);
                                    findProvider.setLanguageListSize(
                                        findProvider
                                                .langaugeModel.result?.length ??
                                            0);
                                  },
                                  child: Container(
                                    height: 30,
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    alignment: Alignment.centerLeft,
                                    child: MyText(
                                      color: colorPrimary,
                                      text: "seemore",
                                      textalign: TextAlign.center,
                                      fontsizeNormal: 14,
                                      multilanguage: true,
                                      maxline: 1,
                                      overflow: TextOverflow.ellipsis,
                                      fontweight: FontWeight.w500,
                                      fontstyle: FontStyle.normal,
                                    ),
                                  ),
                                ),
                              ),
                              /* Language END */
                            ],
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      } else {
                        return const SizedBox.shrink();
                      }
                    }
                  },
                ),
                const SizedBox(height: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget searchBox() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 55,
      margin: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      decoration: BoxDecoration(
        color: colorPrimaryDark,
        border: Border.all(
          color: primaryLight,
          width: 0.5,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: MyImage(
              width: 20,
              height: 20,
              imagePath: "ic_find.png",
              color: white,
            ),
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.center,
              child: TextField(
                onSubmitted: (value) async {
                  debugPrint("value ====> $value");
                  if (value.isNotEmpty) {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return Search(
                            searchText: value.toString(),
                          );
                        },
                      ),
                    );
                    setState(() {
                      searchController.clear();
                    });
                  }
                },
                onChanged: (value) async {},
                textInputAction: TextInputAction.done,
                obscureText: false,
                controller: searchController,
                keyboardType: TextInputType.text,
                maxLines: 1,
                style: const TextStyle(
                  color: white,
                  fontSize: 15,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w500,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  hintStyle: TextStyle(
                    color: otherColor,
                    fontSize: 15,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.w500,
                  ),
                  hintText: searchHint,
                ),
              ),
            ),
          ),
          Consumer<FindProvider>(
            builder: (context, findProvider, child) {
              if (searchController.text.toString().isNotEmpty) {
                return InkWell(
                  borderRadius: BorderRadius.circular(5),
                  onTap: () async {
                    debugPrint("Click on Clear!");
                    searchController.clear();
                    setState(() {});
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    padding: const EdgeInsets.all(15),
                    alignment: Alignment.center,
                    child: MyImage(
                      imagePath: "ic_close.png",
                      color: white,
                      fit: BoxFit.fill,
                    ),
                  ),
                );
              } else {
                return InkWell(
                  borderRadius: BorderRadius.circular(5),
                  onTap: () async {
                    debugPrint("Click on Microphone!");
                    _startListening();
                  },
                  child: _isListening
                      ? AvatarGlow(
  glowColor: colorPrimary,
  glowCount: 2, // Number of glows
  glowShape: BoxShape.circle, // Shape of the glow
  glowBorderRadius: BorderRadius.circular(25), // Optional border radius for the glow
  duration: const Duration(milliseconds: 2000), // Duration of the animation
  startDelay: null, // Optional delay before starting the animation
  animate: true, // Whether to animate the glow
  repeat: true, // Whether to repeat the animation
  curve: Curves.fastOutSlowIn, // Animation curve
  glowRadiusFactor: 0.7, // Factor to adjust the glow radius
  child: Material(
    elevation: 5,
    color: transparentColor,
    shape: const CircleBorder(),
    child: Container(
      width: 50,
      height: 50,
      color: transparentColor,
      padding: const EdgeInsets.all(15),
      alignment: Alignment.center,
      child: MyImage(
        imagePath: "ic_voice.png",
        color: white,
        fit: BoxFit.fill,
      ),
    ),
  ),
)

                      : Container(
                          width: 50,
                          height: 50,
                          padding: const EdgeInsets.all(15),
                          alignment: Alignment.center,
                          child: MyImage(
                            imagePath: "ic_voice.png",
                            color: white,
                            fit: BoxFit.fill,
                          ),
                        ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
