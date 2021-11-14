import 'dart:developer';

import 'package:air_pollution_app/repositories/google_places_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps/google_maps.dart';

part 'google_places_state.dart';

class GooglePlacesCubit extends Cubit<GooglePlacesState> {
  final GooglePlacesRepo _googlePlacesRepo;

  GooglePlacesCubit(this._googlePlacesRepo) : super(StateInitialize());

  //TODO implement cubit logic
  Future<void> httpRequestViaServer(String place) async {
    final response = await _googlePlacesRepo.httpRequestViaServer(place);
    print('${response.toString()}');
  }

}
