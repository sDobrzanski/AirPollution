import 'dart:ui';

import 'package:air_pollution_app/widgets/chart.dart';
import 'package:flutter/material.dart';
import 'app_bar.dart';

class ChartsPage extends StatefulWidget {
  static const String route = '/charts';

  const ChartsPage({Key? key}) : super(key: key);

  @override
  State<ChartsPage> createState() => _ChartsPageState();
}

class _ChartsPageState extends State<ChartsPage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          CustomAppBar(
            isHomePage: false,
            onSubmitted: (String value) {
              //TODO Fetch place details
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    if (canGoBack()) {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    }
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    size: 25,
                  ),
                ),
                SizedBox(
                  height: 500,
                  width: 800,
                  child: PageView.builder(
                    scrollBehavior:
                        ScrollConfiguration.of(context).copyWith(dragDevices: {
                      PointerDeviceKind.touch,
                      PointerDeviceKind.mouse,
                    }),
                    itemCount: 3,
                    controller: _pageController,
                    itemBuilder: (BuildContext context, int index) =>
                        CustomBarChart(index: index),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (canGoForward()) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    }
                  },
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    size: 25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool canGoForward() {
    if (!_pageController.hasClients) {
      return true;
    } else if (_pageController.page == 2) {
      return false;
    } else {
      return _pageController.page != 2 || _pageController.position.atEdge;
    }
  }

  bool canGoBack() {
    if (!_pageController.hasClients) {
      return true;
    } else {
      return _pageController.page != 0 || _pageController.position.atEdge;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
