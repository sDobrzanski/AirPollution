class AirData {
  AirData({
    this.coord,
    this.list,
  });

  final List<int>? coord;
  final List<ListElement>? list;

  factory AirData.fromJson(Map<String, dynamic> json) => AirData(
    coord: List<int>.from(json["coord"].map((x) => x)),
    list: List<ListElement>.from(json["list"].map((x) => ListElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "coord": List<dynamic>.from(coord!.map((x) => x)),
    "list": List<dynamic>.from(list!.map((x) => x.toJson())),
  };
}

class ListElement {
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
    components: Map.from(json["components"]).map((k, v) => MapEntry<String, double>(k, v.toDouble())),
  );

  Map<String, dynamic> toJson() => {
    "dt": dt,
    "main": main?.toJson(),
    "components": Map.from(components!).map((k, v) => MapEntry<String, dynamic>(k, v)),
  };
}

class Main {
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
}
