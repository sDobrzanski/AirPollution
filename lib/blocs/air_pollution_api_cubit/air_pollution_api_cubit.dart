import 'dart:developer';

import 'package:air_pollution_app/repositories/air_pollution_api_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:air_pollution_app/models/air_data.dart';

part 'air_pollution_api_state.dart';

class AirPollutionApiCubit extends Cubit<AirPollutionApiState> {
  final AirPollutionApiRepo _airPollutionApiRepo;

  AirPollutionApiCubit(this._airPollutionApiRepo) : super(StateInitialize());

  Future<void> getAirData(String lat, String long) async {
    emit(StateLoading());
    try {
      final AirData? airData = await _airPollutionApiRepo.getAirData(lat, long);
      emit(StateSuccess(airData));
    } catch (e) {
      log('Error AirPollutionApiCubit: ${e.toString()}');
      emit(StateFailure(e.toString()));
    }
  }
}
