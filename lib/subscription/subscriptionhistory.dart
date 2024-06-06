import 'package:nowlive/provider/subhistoryprovider.dart';
import 'package:nowlive/shimmer/shimmerutils.dart';
import 'package:nowlive/utils/color1.dart';
import 'package:nowlive/utils/dimens.dart';
import 'package:nowlive/utils/utils.dart';
import 'package:nowlive/widget/mytext.dart';
import 'package:nowlive/widget/nodata.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class SubscriptionHistory extends StatefulWidget {
  const SubscriptionHistory({Key? key}) : super(key: key);

  @override
  State<SubscriptionHistory> createState() => _SubscriptionHistoryState();
}

class _SubscriptionHistoryState extends State<SubscriptionHistory> {
  late SubHistoryProvider subHistoryProvider;

  @override
  void initState() {
    subHistoryProvider =
        Provider.of<SubHistoryProvider>(context, listen: false);
    _getData();
    super.initState();
  }

  _getData() async {
    await subHistoryProvider.getSubscriptionList();
  }

  @override
  void dispose() {
    subHistoryProvider.clearProvider();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBgColor,
      appBar: Utils.myAppBarWithBack(context, "transactions", true),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 12, bottom: 12),
                child: Consumer<SubHistoryProvider>(
                  builder: (context, subHistoryProvider, child) {
                    if (subHistoryProvider.loading) {
                      return ShimmerUtils.buildHistoryShimmer(context, 10);
                    } else {
                      if (subHistoryProvider.historyModel.status == 200 &&
                          subHistoryProvider.historyModel.result != null) {
                        if ((subHistoryProvider.historyModel.result?.length ??
                                0) >
                            0) {
                          return AlignedGridView.count(
                            shrinkWrap: true,
                            crossAxisCount: 1,
                            crossAxisSpacing: 0,
                            mainAxisSpacing: 12,
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: subHistoryProvider
                                    .historyModel.result?.length ??
                                0,
                            itemBuilder: (BuildContext context, int position) {
                              return _buildHistoryItem(position);
                            },
                          );
                        } else {
                          return const NoData(title: '', subTitle: '');
                        }
                      } else {
                        return const NoData(title: '', subTitle: '');
                      }
                    }
                  },
                ),
              ),
            ),
            /* AdMob Banner */
            Container(
              child: Utils.showBannerAd(context),
            ),
          ],
        ),
      ),
    );
  }

  bool _checkExpiry(int position) {
    debugPrint("position ======> $position");
    debugPrint(
        "expDate =======> ${subHistoryProvider.historyModel.result?[position].expiryDate}");
    if ((subHistoryProvider.historyModel.result?[position].expiryDate ?? "") !=
        "") {
      return DateTime.now().isBefore(DateTime.parse(
          subHistoryProvider.historyModel.result?[position].expiryDate ?? ""));
    } else {
      return false;
    }
  }

  Widget _buildHistoryItem(position) {
    return Container(
      width: MediaQuery.of(context).size.width,
      constraints: BoxConstraints(minHeight: Dimens.heightHistory),
      decoration: Utils.setBackground(
          _checkExpiry(position) ? colorPrimary : lightBlack, 5),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  /* Title */
                  MyText(
                    color: _checkExpiry(position) ? black : white,
                    text: subHistoryProvider
                            .historyModel.result?[position].packageName ??
                        "",
                    textalign: TextAlign.start,
                    maxline: 2,
                    overflow: TextOverflow.ellipsis,
                    fontsizeNormal: 18,
                    fontweight: FontWeight.w700,
                    fontstyle: FontStyle.normal,
                  ),

                  /* Price */
                  Container(
                    constraints: const BoxConstraints(minHeight: 0),
                    margin: const EdgeInsets.only(top: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(
                          color:
                              _checkExpiry(position) ? lightBlack : whiteLight,
                          text: "price",
                          textalign: TextAlign.center,
                          fontsizeNormal: 13,
                          fontweight: FontWeight.w500,
                          fontsizeWeb: 15,
                          maxline: 1,
                          multilanguage: true,
                          overflow: TextOverflow.ellipsis,
                          fontstyle: FontStyle.normal,
                        ),
                        const SizedBox(width: 5),
                        MyText(
                          color:
                              _checkExpiry(position) ? lightBlack : whiteLight,
                          text: ":",
                          textalign: TextAlign.center,
                          fontsizeNormal: 13,
                          fontweight: FontWeight.w500,
                          fontsizeWeb: 15,
                          maxline: 1,
                          multilanguage: false,
                          overflow: TextOverflow.ellipsis,
                          fontstyle: FontStyle.normal,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: MyText(
                            color: _checkExpiry(position) ? black : white,
                            text:
                                "${subHistoryProvider.historyModel.result?[position].currencyCode.toString()}${subHistoryProvider.historyModel.result?[position].amount.toString()}",
                            textalign: TextAlign.start,
                            fontsizeNormal: 15,
                            fontweight: FontWeight.w700,
                            fontsizeWeb: 14,
                            multilanguage: false,
                            maxline: 1,
                            overflow: TextOverflow.ellipsis,
                            fontstyle: FontStyle.normal,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /* Expire On */
                  Container(
                    constraints: const BoxConstraints(minHeight: 0),
                    margin: const EdgeInsets.only(top: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(
                          color:
                              _checkExpiry(position) ? lightBlack : whiteLight,
                          text: _checkExpiry(position)
                              ? "expired_on"
                              : "expire_on",
                          textalign: TextAlign.center,
                          fontsizeNormal: 13,
                          fontweight: FontWeight.w500,
                          fontsizeWeb: 15,
                          maxline: 1,
                          multilanguage: true,
                          overflow: TextOverflow.ellipsis,
                          fontstyle: FontStyle.normal,
                        ),
                        const SizedBox(width: 5),
                        MyText(
                          color:
                              _checkExpiry(position) ? lightBlack : whiteLight,
                          text: ":",
                          textalign: TextAlign.center,
                          fontsizeNormal: 13,
                          fontweight: FontWeight.w500,
                          fontsizeWeb: 15,
                          maxline: 1,
                          multilanguage: false,
                          overflow: TextOverflow.ellipsis,
                          fontstyle: FontStyle.normal,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: MyText(
                            color: _checkExpiry(position) ? black : white,
                            text: (subHistoryProvider.historyModel
                                            .result?[position].expiryDate !=
                                        null ||
                                    (subHistoryProvider.historyModel
                                                .result?[position].expiryDate ??
                                            "") !=
                                        "")
                                ? (subHistoryProvider.historyModel
                                        .result?[position].expiryDate
                                        .toString() ??
                                    "")
                                : "-",
                            textalign: TextAlign.start,
                            fontsizeNormal: 13,
                            fontweight: FontWeight.w700,
                            fontsizeWeb: 14,
                            multilanguage: false,
                            maxline: 5,
                            overflow: TextOverflow.ellipsis,
                            fontstyle: FontStyle.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (subHistoryProvider.historyModel.result?[position].expiryDate !=
                  null ||
              (subHistoryProvider.historyModel.result?[position].expiryDate ??
                      "") !=
                  "")
            Container(
              height: 32,
              constraints: const BoxConstraints(minWidth: 0),
              decoration: Utils.setBGWithBorder(
                  _checkExpiry(position) ? complimentryColor : colorPrimary,
                  white,
                  15,
                  0.5),
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              alignment: Alignment.center,
              child: MyText(
                color: _checkExpiry(position) ? white : black,
                text: _checkExpiry(position) ? "current" : "expired",
                multilanguage: true,
                textalign: TextAlign.center,
                maxline: 1,
                overflow: TextOverflow.ellipsis,
                fontsizeNormal: 13,
                fontsizeWeb: 15,
                fontweight: FontWeight.w700,
                fontstyle: FontStyle.normal,
              ),
            ),
        ],
      ),
    );
  }
}
