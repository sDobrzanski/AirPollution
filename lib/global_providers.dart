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
      ];

  List<BlocProvider<dynamic>> _buildBlocProviders(BuildContext context) =>
      <BlocProvider<dynamic>>[
      ];
}