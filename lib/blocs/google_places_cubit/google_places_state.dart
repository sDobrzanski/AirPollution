part of 'google_places_cubit.dart';

class GooglePlacesState extends Equatable {
  @override
  List<Object?> get props => <Object?>[];
}

class StateInitialize extends GooglePlacesState {}

class StateLoading extends GooglePlacesState {}

class GooglePlacesSuccess extends GooglePlacesState {
  final GeolocationData geolocationData;
  GooglePlacesSuccess(this.geolocationData);

  @override
  List<Object?> get props => [geolocationData];
}

class GooglePlacesFailure extends GooglePlacesState {
  final String errorMessage;
  GooglePlacesFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}