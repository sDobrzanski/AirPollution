import 'package:air_pollution_app/blocs/air_pollution_api_cubit/air_pollution_api_cubit.dart';
import 'package:air_pollution_app/repositories/air_pollution_api_repo.dart';
import 'package:air_pollution_app/repositories/google_places_repo.dart';
import 'package:air_pollution_app/web_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GlobalProviders extends StatelessWidget {

  const GlobalProviders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: _buildRepositories(context),
      child: Builder(
        builder: (BuildContext context) => MultiBlocProvider(
          providers: _buildBlocProviders(context),
          child: const WebApp(),
        ),
      ),
    );
  }

  List<RepositoryProvider<dynamic>> _buildRepositories(BuildContext context) =>
      <RepositoryProvider<dynamic>>[
        RepositoryProvider<AirPollutionApiRepo>(
          create: (BuildContext context) => AirPollutionApiRepo(),
        ),
        RepositoryProvider<GooglePlacesRepo>(
          create: (BuildContext context) => GooglePlacesRepo(),
        ),
      ];

  List<BlocProvider<dynamic>> _buildBlocProviders(BuildContext context) =>
      <BlocProvider<dynamic>>[
        BlocProvider<AirPollutionApiCubit>(
          create: (BuildContext context) => AirPollutionApiCubit(
            RepositoryProvider.of<AirPollutionApiRepo>(context),
          ),
        ),
      ];
}