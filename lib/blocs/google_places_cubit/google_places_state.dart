part of 'google_places_cubit.dart';

class GooglePlacesState extends Equatable {
  @override
  List<Object?> get props => <Object?>[];
}

class StateInitialize extends GooglePlacesState {}

class StateLoading extends GooglePlacesState {}

class StateSuccess extends GooglePlacesState {
  final GeocoderResponse autocompleteResponse;
  StateSuccess(this.autocompleteResponse);

  @override
  List<Object?> get props => [autocompleteResponse];
}

class StateFailure extends GooglePlacesState {
  final String errorMessage;
  StateFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}