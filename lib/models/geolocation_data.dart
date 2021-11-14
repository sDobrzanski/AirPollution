import 'package:equatable/equatable.dart';

class GeolocationData extends Equatable {
  GeolocationData({
    this.results,
    this.status,
  });

  List<Result>? results;
  String? status;

  factory GeolocationData.fromJson(Map<String, dynamic> json) =>
      GeolocationData(
        results: json["results"] == null
            ? null
            : List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
        status: json["status"] == null ? null : json["status"],
      );

  Map<String, dynamic> toJson() => {
        "results": results == null
            ? null
            : List<dynamic>.from(results!.map((x) => x.toJson())),
        "status": status == null ? null : status,
      };

  @override
  List<Object?> get props => <Object?>[
        results,
        status,
      ];
}

class Result extends Equatable {
  Result({
    this.addressComponents,
    this.formattedAddress,
    this.geometry,
    this.placeId,
    this.types,
  });

  List<AddressComponent>? addressComponents;
  String? formattedAddress;
  Geometry? geometry;
  String? placeId;
  List<String>? types;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        addressComponents: json["address_components"] == null
            ? null
            : List<AddressComponent>.from(json["address_components"]
                .map((x) => AddressComponent.fromJson(x))),
        formattedAddress: json["formatted_address"] == null
            ? null
            : json["formatted_address"],
        geometry: json["geometry"] == null
            ? null
            : Geometry.fromJson(json["geometry"]),
        placeId: json["place_id"] == null ? null : json["place_id"],
        types: json["types"] == null
            ? null
            : List<String>.from(json["types"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "address_components": addressComponents == null
            ? null
            : List<dynamic>.from(addressComponents!.map((x) => x.toJson())),
        "formatted_address": formattedAddress == null ? null : formattedAddress,
        "geometry": geometry == null ? null : geometry!.toJson(),
        "place_id": placeId == null ? null : placeId,
        "types":
            types == null ? null : List<dynamic>.from(types!.map((x) => x)),
      };

  @override
  List<Object?> get props => <Object?>[
        addressComponents,
        formattedAddress,
        geometry,
        placeId,
        types,
      ];
}

class AddressComponent extends Equatable {
  AddressComponent({
    this.longName,
    this.shortName,
    this.types,
  });

  String? longName;
  String? shortName;
  List<String>? types;

  factory AddressComponent.fromJson(Map<String, dynamic> json) =>
      AddressComponent(
        longName: json["long_name"] == null ? null : json["long_name"],
        shortName: json["short_name"] == null ? null : json["short_name"],
        types: json["types"] == null
            ? null
            : List<String>.from(json["types"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "long_name": longName == null ? null : longName,
        "short_name": shortName == null ? null : shortName,
        "types":
            types == null ? null : List<dynamic>.from(types!.map((x) => x)),
      };

  @override
  List<Object?> get props => <Object?>[
        longName,
        shortName,
        types,
      ];
}

class Geometry extends Equatable {
  Geometry({
    this.bounds,
    this.location,
    this.locationType,
    this.viewport,
  });

  Bounds? bounds;
  Location? location;
  String? locationType;
  Bounds? viewport;

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        bounds: json["bounds"] == null ? null : Bounds.fromJson(json["bounds"]),
        location: json["location"] == null
            ? null
            : Location.fromJson(json["location"]),
        locationType:
            json["location_type"] == null ? null : json["location_type"],
        viewport:
            json["viewport"] == null ? null : Bounds.fromJson(json["viewport"]),
      );

  Map<String, dynamic> toJson() => {
        "bounds": bounds == null ? null : bounds!.toJson(),
        "location": location == null ? null : location!.toJson(),
        "location_type": locationType == null ? null : locationType,
        "viewport": viewport == null ? null : viewport!.toJson(),
      };

  @override
  List<Object?> get props => <Object?>[
        bounds,
        location,
        locationType,
        viewport,
      ];
}

class Bounds extends Equatable {
  Bounds({
    this.northeast,
    this.southwest,
  });

  Location? northeast;
  Location? southwest;

  factory Bounds.fromJson(Map<String, dynamic> json) => Bounds(
        northeast: json["northeast"] == null
            ? null
            : Location.fromJson(json["northeast"]),
        southwest: json["southwest"] == null
            ? null
            : Location.fromJson(json["southwest"]),
      );

  Map<String, dynamic> toJson() => {
        "northeast": northeast == null ? null : northeast!.toJson(),
        "southwest": southwest == null ? null : southwest!.toJson(),
      };

  @override
  List<Object?> get props => <Object?>[
        northeast,
        southwest,
      ];
}

class Location extends Equatable {
  Location({
    this.lat,
    this.lng,
  });

  double? lat;
  double? lng;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        lat: json["lat"] == null ? null : json["lat"].toDouble(),
        lng: json["lng"] == null ? null : json["lng"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "lat": lat == null ? null : lat,
        "lng": lng == null ? null : lng,
      };

  @override
  List<Object?> get props => <Object?>[
    lat,
    lng,
  ];
}
