import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weedool/component/wd_appbar.dart';
import 'package:weedool/components/wd_colors.dart';
import 'package:weedool/components/wd_common.dart';
import 'package:weedool/components/wd_text_style.dart';
import 'package:weedool/controllers/reserve/controller_search.dart';
import 'package:weedool/models/reserve/model_center_list.dart';
import 'package:weedool/utils/ga_util.dart';

import 'package:weedool/views/reserve/center_info.dart';

class ReserveSearchView extends StatefulWidget {
  final CenterListModel centerListModel;

  const ReserveSearchView({Key? key, required this.centerListModel})
      : super(key: key);

  @override
  State<ReserveSearchView> createState() => _ReserveSearchState();
}

class _ReserveSearchState extends State<ReserveSearchView> {
  double height = 0;
  double width = 0;

  SearchCtl searchCtl = SearchCtl();

  void _printLatestValue() {
    setState(() {
      searchCtl.searchStr = searchCtl.myController.text;
    });
  }

  @override
  void initState() {
    GaUtil().trackScreen('SearchPage', input: {'uuid' : WDCommon().uuid});
    super.initState();
    for (int i = 0; i < widget.centerListModel.data!.length; i++) {
      for (int j = 0;
          j < widget.centerListModel.data![i].category!.length;
          j++) {
        if (!searchCtl.strCategory
            .contains(widget.centerListModel.data![i].category![j])) {
          searchCtl.strCategory
              .add(widget.centerListModel.data![i].category![j]);
        }
      }
    }
    setState(() {
      searchCtl.strCategory;
    });
  }

  @override
  Widget build(BuildContext context) {
    height == 0 ? height = MediaQuery.of(context).size.height : 0;
    width == 0 ? width = MediaQuery.of(context).size.width : 0;

    searchCtl.myController.addListener(_printLatestValue);

    // searchCtl.myController.text = searchCtl.searchStr;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: MediaQuery(
          data:
              MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
          child: SingleChildScrollView(
            child: Column(
              children: [
                WDAppbar(buildContext: context),
                _bodyContents(),
              ],
            ),
          ),
        ));
  }

  Widget _bodyContents() {
    for (int i = 0; i < widget.centerListModel.data!.length; i++) {
      for (int j = 0;
          j < widget.centerListModel.data![i].category!.length;
          j++) {
        if (!searchCtl.strCategory
            .contains(widget.centerListModel.data![i].category![j])) {
          searchCtl.strCategory
              .add(widget.centerListModel.data![i].category![j]);
        }
      }
    }
    //ic_close_circle.png
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 24),
      child: Column(
        children: [
          Container(
            width: width,
            height: 46,
            decoration: BoxDecoration(
                color: WDColors.assitive.withOpacity(0.1),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: WDColors.neutral)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 18, right: 12),
                  child: Image.asset(
                      'assets/images/ic_reserve_search_black.png',
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain),
                ),
                Expanded(
                    child: Center(
                  child: TextField(
                    controller: searchCtl.myController,
                    onChanged: (value) {
                      setState(() => searchCtl.myController.text);
                    },
                    style: AppTextStyles.body1(WDColors.black),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: SizedBox(
                            width: 16,
                            height: 16,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  searchCtl.myController.text = '';
                                });
                              },
                              child: SizedBox(
                                width: 16,
                                height: 16,
                                child: Image.asset(
                                    'assets/images/ic_close_circle.png'),
                              ),
                            ),
                          ),
                        ),
                        suffixIconConstraints:
                            const BoxConstraints(minHeight: 16, maxHeight: 16)),
                  ),
                )),
              ],
            ),
          ),
          searchCtl.searchStr.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: _searchList(),
                )
              : SizedBox(
            width: width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 8,
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      searchCtl.tabPosition = 0;
                    });
                  },
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  child: Text('태그 검색',
                      style: AppTextStyles.body1(searchCtl.tabPosition == 0
                          ? const Color(0xFF1983D0)
                          : const Color(0xFFA8A8A8))),
                ),
                const SizedBox(
                  height: 8,
                ),
                Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.start,
                  children: searchCtl.strCategory
                      .map((String name) => GestureDetector(
                      onTap: () {
                        if (searchCtl.selectedSearchStr
                            .contains(name)) {
                          setState(() {
                            searchCtl.selectedSearchStr.remove(name);
                          });
                        } else {
                          setState(() {
                            searchCtl.myController.text = name;
                          });
                          searchCtl.selectedSearchStr.add(name);
                        }
                      },
                      child: Container(
                        margin:
                        const EdgeInsets.only(right: 8, bottom: 7),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                                Radius.circular(100)),
                            border: Border.all(
                                width: 1,
                                color: const Color(0xffE0E0E2)),
                            color: searchCtl.checkSelected(name)
                                ? const Color(0xff3E9CE2)
                                : WDColors.white),
                        child: Text(name,
                            style: AppTextStyles.body6(
                                searchCtl.checkSelected(name)
                                    ? WDColors.white
                                    : WDColors.neutral)),
                      )))
                      .toList(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _searchList() {
    CenterListModel searchArr;

    final items = widget.centerListModel.data!
        .where(
          (element) => element.category!.contains(searchCtl.searchStr),
        )
        .toList();
    if (items.isEmpty) {
      return Container();
    } else {
      return ListView.builder(
          itemCount: items.length,
          shrinkWrap: true,
          // 추가
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.all(0),
          itemBuilder: (context, index) {
            var distance = WDCommon().calculateDistance(
                WDCommon().latitude,
                WDCommon().longitude,
                double.parse(items[index].latitude),
                double.parse(items[index].longitude));

            return Column(
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CenterInfoView(
                                    center_id: items[index].center_id,
                                  )));
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      width: width,
                      child: SizedBox(
                        width: width,
                        child: Row(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(15)),
                                image: DecorationImage(
                                    image: NetworkImage(
                                        'https://weedool-web-back.s3.ap-northeast-2.amazonaws.com/${items[index].center_img.main_img_path}'),
                                    fit: BoxFit.fill),
                              ),
                            ),
                            const SizedBox(
                              width: 24,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 3.5),
                                  child: SizedBox(
                                    width: width - 164,
                                    child: Text(
                                        WDCommon().replaceStringLength(
                                            items[index].center_name, 15),
                                        textAlign: TextAlign.left,
                                        style: AppTextStyles.heading3(
                                            WDColors.black),
                                        overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: width - 164,
                                      child: Text(
                                        items[index].category![0],
                                        textAlign: TextAlign.left,
                                        style:
                                            AppTextStyles.body4(WDColors.black)
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w600),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    SizedBox(
                                      width: width - 164,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                              'assets/images/ic_center_distance.png',
                                              width: 7,
                                              height: 10,
                                              fit: BoxFit.contain),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                              "${distance < 1 ? 1 : distance > 1000 ? 1000 : distance.toInt()}km",
                                              textAlign: TextAlign.left,
                                              style: AppTextStyles.body6(
                                                  WDColors.alternative)),
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            width: 1,
                                            height: 12,
                                            color: WDColors.neutralLine,
                                          ),
                                          Expanded(
                                            // width: 152,
                                            child: Text(
                                              WDCommon().addrReplace(
                                                  items[index].location),
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              style: AppTextStyles.body6(
                                                  WDColors.alternative),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ))
              ],
            );
          });
    }
  }
}
