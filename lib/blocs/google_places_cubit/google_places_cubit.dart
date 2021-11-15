import 'dart:developer';

import 'package:air_pollution_app/models/geolocation_data.dart';
import 'package:air_pollution_app/repositories/google_places_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'google_places_state.dart';

class GooglePlacesCubit extends Cubit<GooglePlacesState> {
  final GooglePlacesRepo _googlePlacesRepo;

  GooglePlacesCubit(this._googlePlacesRepo) : super(StateInitialize());

  Future<void> getLocationData(String place) async {
    emit(GooglePlacesLoading());
    try {
      final GeolocationData geolocationData =
          await _googlePlacesRepo.getLocationLatLong(place);
      emit(GooglePlacesSuccess(geolocationData));
    } catch (e) {
      log('Error GooglePlacesCubit: ${e.toString()}');
      emit(GooglePlacesFailure(e.toString()));
    }
  }
}
