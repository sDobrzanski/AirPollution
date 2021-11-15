part of 'air_pollution_api_cubit.dart';

class AirPollutionApiState extends Equatable {

  @override
  List<Object?> get props => [];
}

class StateInitialize extends AirPollutionApiState {}

class StateLoading extends AirPollutionApiState {}

class StateSuccess extends AirPollutionApiState {
  final AirPollutionData? airData;
  StateSuccess(this.airData);

  @override
  List<Object?> get props => [airData];
}

class StateFailure extends AirPollutionApiState {
  final String errorMessage;
  StateFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}