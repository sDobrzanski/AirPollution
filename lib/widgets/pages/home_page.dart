import 'package:air_pollution_app/blocs/air_pollution_api_cubit/air_pollution_api_cubit.dart';
import 'package:air_pollution_app/models/geolocation_data.dart';
import 'package:air_pollution_app/repositories/air_pollution_api_repo.dart';
import 'package:air_pollution_app/repositories/google_places_repo.dart';
import 'package:air_pollution_app/widgets/pages/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:air_pollution_app/blocs/google_places_cubit/google_places_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GoogleMapController mapController;
  late GooglePlacesCubit googlePlacesCubit;
  late AirPollutionApiCubit airPollutionApiCubit;
  GeolocationData? geolocationData;
  final LatLng _center = const LatLng(45.521563, -122.677433);
  final Map<String, Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    googlePlacesCubit =
        GooglePlacesCubit(RepositoryProvider.of<GooglePlacesRepo>(context));
    airPollutionApiCubit = AirPollutionApiCubit(
        RepositoryProvider.of<AirPollutionApiRepo>(context));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomAppBar(
          onSubmitted: (String value) {
            googlePlacesCubit.getLocationData(value);
          },
        ),
        Expanded(
          child: MultiBlocListener(
            listeners: [
              BlocListener<GooglePlacesCubit, GooglePlacesState>(
                bloc: googlePlacesCubit,
                listenWhen: (previous, __) => previous is GooglePlacesLoading,
                listener: (context, state) {
                  if (state is GooglePlacesSuccess) {
                    setState(() {
                      geolocationData = state.geolocationData;

                      mapController.animateCamera(
                        CameraUpdate.newLatLngZoom(
                          LatLng(
                            geolocationData!
                                .results!.first.geometry!.location!.lat!,
                            geolocationData!
                                .results!.first.geometry!.location!.lng!,
                          ),
                          11,
                        ),
                      );

                      airPollutionApiCubit.getAirData(
                        geolocationData!.results!.first.geometry!.location!.lat!
                            .toString(),
                        geolocationData!.results!.first.geometry!.location!.lng!
                            .toString(),
                      );
                    });
                  }
                },
              ),
              BlocListener<AirPollutionApiCubit, AirPollutionApiState>(
                bloc: airPollutionApiCubit,
                listenWhen: (previous, __) => previous is StateLoading,
                listener: (context, state) {
                  if (state is StateSuccess) {
                    setState(() {
                      Marker marker = Marker(
                        markerId: MarkerId(geolocationData!.results!.first
                            .addressComponents!.first.shortName!),
                        position: LatLng(
                            geolocationData!
                                .results!.first.geometry!.location!.lat!,
                            geolocationData!
                                .results!.first.geometry!.location!.lng!),
                        infoWindow: InfoWindow(
                          title: geolocationData!.results!.first
                              .addressComponents!.first.shortName!,
                          snippet:
                              state.airData!.list!.first.components.toString(),
                        ),
                      );

                      _markers[geolocationData!.results!.first.placeId!] =
                          marker;
                    });
                  }
                },
              )
            ],
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
              markers: _markers.values.toSet(),
            ),
          ),
        ),
      ],
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setState(() {
      Marker marker = Marker(
        markerId: MarkerId('center'),
        position: _center,
        infoWindow: InfoWindow(
          title: 'title',
          snippet: 'snippet',
        ),
      );
      _markers['center'] = marker;
    });
  }

  @override
  void dispose() {
    googlePlacesCubit.close();
    airPollutionApiCubit.close();
    mapController.dispose();
    super.dispose();
  }
}
