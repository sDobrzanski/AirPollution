import 'dart:developer';

import 'package:air_pollution_app/repositories/air_pollution_api_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:air_pollution_app/models/air_data.dart';

part 'air_pollution_api_state.dart';

class AirPollutionApiCubit extends Cubit<AirPollutionApiState> {
  final AirPollutionApiRepo _airPollutionApiRepo;

  AirPollutionApiCubit(this._airPollutionApiRepo) : super(StateInitialize());

  Future<void> getCurrentAirData(String lat, String long) async {
    emit(StateLoading());
    try {
      final AirPollutionData? airData =
          await _airPollutionApiRepo.getCurrentAirData(lat, long);
      emit(StateSuccess(airData));
    } catch (e) {
      log('Error AirPollutionApiCubit: ${e.toString()}');
      emit(StateFailure(e.toString()));
    }
  }

  Future<void> getHistoryAirData(
      String lat, String long, DateTime dateFrom, DateTime dateTo) async {
    emit(StateLoading());
    try {
      final AirPollutionData? airData = await _airPollutionApiRepo
          .getHistoryAirData(lat, long, dateFrom, dateTo);
      emit(StateSuccess(airData));
    } catch (e) {
      log('Error AirPollutionApiCubit: ${e.toString()}');
      emit(StateFailure(e.toString()));
    }
  }
}
