import 'dart:ui';

import 'package:air_pollution_app/blocs/air_pollution_api_cubit/air_pollution_api_cubit.dart';
import 'package:air_pollution_app/blocs/google_places_cubit/google_places_cubit.dart';
import 'package:air_pollution_app/models/air_data.dart';
import 'package:air_pollution_app/models/geolocation_data.dart';
import 'package:air_pollution_app/repositories/air_pollution_api_repo.dart';
import 'package:air_pollution_app/repositories/google_places_repo.dart';
import 'package:air_pollution_app/widgets/custom_bar_chart.dart';
import 'package:air_pollution_app/widgets/pages/app_bar.dart';
import 'package:air_pollution_app/widgets/date_time_picker_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChartsPage extends StatefulWidget {
  static const String route = '/charts';

  const ChartsPage({Key? key}) : super(key: key);

  @override
  State<ChartsPage> createState() => _ChartsPageState();
}

class _ChartsPageState extends State<ChartsPage> {
  late PageController _pageController;
  late GooglePlacesCubit googlePlacesCubit;
  late AirPollutionApiCubit airPollutionApiCubit;
  List<ListElement>? list;
  GeolocationData? geolocationData;
  int chartsNumber = 1;
  DateTime dateNow = DateTime.now();
  DateTime? dateFrom;
  DateTime? dateTo;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    googlePlacesCubit =
        GooglePlacesCubit(RepositoryProvider.of<GooglePlacesRepo>(context));
    airPollutionApiCubit = AirPollutionApiCubit(
        RepositoryProvider.of<AirPollutionApiRepo>(context));
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Material(
      child: Column(
        children: [
          CustomAppBar(
            isHomePage: false,
            onSubmitted: (String value) {
              googlePlacesCubit.getLocationData(value);
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  DateTimePickerRow(
                    onDataFromChanged: (DateTime newDateTime) {
                      setState(() {
                        dateFrom = newDateTime;
                      });
                    },
                    onDataToChanged: (DateTime newDateTime) {
                      setState(() {
                        dateTo = newDateTime;
                      });
                    },
                  ),
                  Row(
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
                      BlocListener<GooglePlacesCubit, GooglePlacesState>(
                        bloc: googlePlacesCubit,
                        listenWhen: (previous, __) =>
                            previous is GooglePlacesLoading,
                        listener: (context, state) {
                          if (state is GooglePlacesSuccess) {
                            setState(() {
                              geolocationData = state.geolocationData;

                              airPollutionApiCubit.getHistoryAirData(
                                geolocationData!
                                    .results!.first.geometry!.location!.lat!
                                    .toString(),
                                geolocationData!
                                    .results!.first.geometry!.location!.lng!
                                    .toString(),
                                dateFrom ?? dateNow,
                                dateTo ?? dateNow,
                              );
                            });
                          }
                        },
                        child: BlocBuilder<AirPollutionApiCubit,
                            AirPollutionApiState>(
                          bloc: airPollutionApiCubit,
                          builder: (context, state) {
                            if (state is StateLoading) {
                              return const Center(
                                child: CircularProgressIndicator(
                                    color: Colors.blue),
                              );
                            }
                            if (state is StateSuccess) {
                              list = state.airData?.list;
                              chartsNumber = list!.first.components!.length;
                              if (list != null && list!.isNotEmpty) {
                                return SizedBox(
                                  height: screenWidth > 700 ? 450 : 300,
                                  width: screenWidth > 700 ? 800 : screenWidth -
                                      40,
                                  child: PageView.builder(
                                    scrollBehavior:
                                    ScrollConfiguration.of(context)
                                        .copyWith(dragDevices: {
                                      PointerDeviceKind.touch,
                                      PointerDeviceKind.mouse,
                                    }),
                                    itemCount: chartsNumber,
                                    controller: _pageController,
                                    itemBuilder:
                                        (BuildContext context, int index) =>
                                        CustomBarChart(
                                          index: index,
                                          list: list,
                                        ),
                                  ),
                                );
                              } else {
                                return const Center(
                                  child: Text(
                                    'Pick another date',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                );
                              }
                            }

                            if (screenWidth > 700) {
                              return const Center(
                                child: Text(
                                  'Enter place and date to see detailed data',
                                  style: TextStyle(fontSize: 18),
                                ),
                              );
                            } else {
                              return const Expanded(
                                child: Center(
                                  child: Text(
                                    'Enter place and date to see detailed data',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              );
                            }
                          },
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool canGoForward() {
    if (!_pageController.hasClients) {
      return true;
    } else if (_pageController.page == chartsNumber) {
      return false;
    } else {
      return _pageController.page != chartsNumber ||
          _pageController.position.atEdge;
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
    googlePlacesCubit.close();
    airPollutionApiCubit.close();
    super.dispose();
  }
}
