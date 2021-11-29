import 'package:equatable/equatable.dart';

class AirPollutionData extends Equatable {
  AirPollutionData({
    this.coord,
    this.list,
  });

  Coord? coord;
  List<ListElement>? list;

  factory AirPollutionData.fromJson(Map<String, dynamic> json) =>
      AirPollutionData(
        coord: json["coord"] == null ? null : Coord.fromJson(json["coord"]),
        list: json["list"] == null
            ? null
            : List<ListElement>.from(
                json["list"].map((x) => ListElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "coord": coord == null ? null : coord!.toJson(),
        "list": list == null
            ? null
            : List<dynamic>.from(list!.map((x) => x.toJson())),
      };

  @override
  List<Object?> get props => <Object?>[
        coord,
        list,
      ];
}

class Coord extends Equatable {
  Coord({
    this.lon,
    this.lat,
  });

  double? lon;
  double? lat;

  factory Coord.fromJson(Map<String, dynamic> json) => Coord(
        lon: json["lon"] == null ? null : json["lon"].toDouble(),
        lat: json["lat"] == null ? null : json["lat"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "lon": lon == null ? null : lon,
        "lat": lat == null ? null : lat,
      };

  @override
  List<Object?> get props => <Object?>[
        lon,
        lat,
      ];
}

class ListElement extends Equatable {
  ListElement({
    this.main,
    this.components,
    this.dt,
  });

  Main? main;
  Map<String, double>? components;
  int? dt;

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
        main: json["main"] == null ? null : Main.fromJson(json["main"]),
        components: json["components"] == null
            ? null
            : Map.from(json["components"])
                .map((k, v) => MapEntry<String, double>(k, v.toDouble())),
        dt: json["dt"] == null ? null : json["dt"],
      );

  Map<String, dynamic> toJson() => {
        "main": main == null ? null : main!.toJson(),
        "components": components == null
            ? null
            : Map.from(components!)
                .map((k, v) => MapEntry<String, dynamic>(k, v)),
        "dt": dt == null ? null : dt,
      };

  @override
  List<Object?> get props => <Object?>[
        main,
        components,
        dt,
      ];
}

class Main extends Equatable {
  Main({
    this.aqi,
  });

  int? aqi;

  factory Main.fromJson(Map<String, dynamic> json) => Main(
        aqi: json["aqi"] == null ? null : json["aqi"],
      );

  Map<String, dynamic> toJson() => {
        "aqi": aqi == null ? null : aqi,
      };

  @override
  List<Object?> get props => <Object?>[
        aqi,
      ];
}

class Component extends Equatable {
  const Component({
    this.name,
    this.value,
  });

  final String? name;
  final double? value;

  @override
  List<Object?> get props => [name, value];

}
