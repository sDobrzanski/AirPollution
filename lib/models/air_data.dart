import 'package:equatable/equatable.dart';

class AirData extends Equatable {
  AirData({
    this.coord,
    this.list,
  });

  final List<int>? coord;
  final List<ListElement>? list;

  factory AirData.fromJson(Map<String, dynamic> json) => AirData(
        coord: List<int>.from(json["coord"].map((x) => x)),
        list: List<ListElement>.from(
            json["list"].map((x) => ListElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "coord": List<dynamic>.from(coord!.map((x) => x)),
        "list": List<dynamic>.from(list!.map((x) => x.toJson())),
      };

  @override
  List<Object?> get props => <Object?>[
        coord,
        list,
      ];
}

class ListElement extends Equatable {
  ListElement({
    this.dt,
    this.main,
    this.components,
  });

  final int? dt;
  final Main? main;
  final Map<String, double>? components;

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
        dt: json["dt"],
        main: Main.fromJson(json["main"]),
        components: Map.from(json["components"])
            .map((k, v) => MapEntry<String, double>(k, v.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "dt": dt,
        "main": main?.toJson(),
        "components": Map.from(components!)
            .map((k, v) => MapEntry<String, dynamic>(k, v)),
      };

  @override
  List<Object?> get props => <Object?>[
        dt,
        main,
        components,
      ];
}

class Main extends Equatable {
  Main({
    this.aqi,
  });

  final int? aqi;

  factory Main.fromJson(Map<String, dynamic> json) => Main(
        aqi: json["aqi"],
      );

  Map<String, dynamic> toJson() => {
        "aqi": aqi,
      };

  @override
  List<Object?> get props => <Object?>[
        aqi,
      ];
}
