import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weedool/component/wd_appbar.dart';
import 'package:weedool/components/wd_colors.dart';
import 'package:weedool/models/reserve/model_center_info.dart';
import 'package:weedool/utils/logger.dart';
import 'package:weedool/utils/text_style.dart';
import 'package:weedool/views/reserve/center_img_indicator.dart';

class CenterImgSlider extends StatefulWidget {
  final CenterImg centerImg;

  CenterImgSlider({super.key, required this.centerImg});

  @override
  State<StatefulWidget> createState() => _CenterImgSlider();
}

class _CenterImgSlider extends State<CenterImgSlider> {
  late final Size size = MediaQuery.of(context).size;
  List<String> imgList = [];

  @override
  void initState() {
    List<String> centerList = [];
    if (widget.centerImg.main_img_path != null) {
      centerList.add(widget.centerImg.main_img_path!);
    }
    if (widget.centerImg.sub_img_path != null &&
        widget.centerImg.sub_img_path?.isNotEmpty == true) {
      for (String img in widget.centerImg.sub_img_path!) {
        if(img.isNotEmpty && img != ''){
          centerList.add(img);
        }
      }
    }
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        imgList = centerList;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  final PageController _controller = PageController(initialPage: 0);
  int _selectedIdx = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      height: 350,
      child: Stack(
        children: [
          _img(),
          if (imgList.length > 1)
            Positioned(
                bottom: 20,
                child: CenterImgIndicator(
                    length: imgList.length, selected: _selectedIdx)),
          if (imgList.length > 1)
            Center(
              child: Padding(
                padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: MediaQuery.of(context).padding.top),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [_clickIcon(), _clickIcon(isLeft: false)],
                ),
              ),
            ),
          WDAppbar(buildContext: context)
        ],
      ),
    );
  }

  //

  final String _imgPrefix =
      'https://weedool-web-back.s3.ap-northeast-2.amazonaws.com/';

  Widget _img() {
    if (imgList.isNotEmpty) {
      if (imgList.length == 1) {
        return SizedBox(
          width: size.width,
          height: 350,
          child: CachedNetworkImage(
            imageUrl: '$_imgPrefix${imgList.first}',
            fit: BoxFit.cover,
          ),
        );
      } else {
        return SizedBox(
          width: size.width,
          height: 350,
          child: PageView.builder(
            controller: _controller,
            pageSnapping: false,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, idx) {
              try {
                return SizedBox(
                  width: size.width,
                  height: 350,
                  child: CachedNetworkImage(
                    imageUrl: '$_imgPrefix${imgList[idx]}',
                    fit: BoxFit.cover,
                  ),
                );
              } catch (e) {
                return _noDataImg;
              }
            },
            onPageChanged: (idx) {
              setState(() {
                _selectedIdx = idx;
              });
            },
          ),
        );
      }
    } else {
      return _noDataImg;
    }
  }
  late final Widget _noDataImg = Container(
    width: size.width,
    height: 350,
    color: WDColors.grey100,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: Image.asset('assets/images/ic_main_motion3.png'),
        ),
        const SizedBox(
          height: 12,
        ),
        Text(
          '아직 센터 사진이 없어요!',
          style: _noCenterTextStyle,
        )
      ],
    ),
  );

  final TextStyle _noCenterTextStyle = Styler.style(
    color: WDColors.assitive,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 1.5,
  );

  Widget _clickIcon({bool isLeft = true}) {
    if (isLeft == false && _selectedIdx == imgList.length) {
      return Container();
    }
    if(isLeft && _selectedIdx ==0 && imgList.length > 1){
      return Container();
    }
    return GestureDetector(
      onTap: () {
        if (isLeft) {
          _move(_selectedIdx - 1);
        } else {
          _move(_selectedIdx + 1);
        }
      },
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5), shape: BoxShape.circle),
        child: Center(
          child: SizedBox(
            width: 18,
            height: 18,
            child: Image.asset(
                'assets/images/ic_chevron${isLeft ? '_right' : ''}.png'),
          ),
        ),
      ),
    );
  }

  void _move(int page) {
    _controller.animateToPage(page,
        duration: const Duration(milliseconds: 300), curve: Curves.linear);
  }
}
