// model prod energi pada halaman peta
class ProdEnergi {
  final dynamic kwhWt;
  final dynamic kwhSp;
  final dynamic kwhDs;
  final dynamic kwhAll;

  ProdEnergi({this.kwhWt, this.kwhSp, this.kwhDs, this.kwhAll});

  factory ProdEnergi.fromJson(Map<String, dynamic> json) {
    return ProdEnergi(
      kwhWt: json['wind_turbine']['power_kwh'] ?? '0',
      kwhSp: json['solar_panel']['power_kwh'] ?? '0',
      kwhDs: json['diesel']['power_kwh'] ?? '0',
      kwhAll: json['all']['total_power_kwh'] ?? '0',
    );
  }
}

// model prod energi pada halaman stacked column bar produksi energi
class ProdEnergiWtData {
  dynamic interval;
  String powerKwh;

  ProdEnergiWtData({
    required this.interval,
    required this.powerKwh,
  });
}

class ProdEnergiSpData {
  dynamic interval;
  String powerKwh;

  ProdEnergiSpData({
    required this.interval,
    required this.powerKwh,
  });
}

class ProdEnergiDsData {
  dynamic interval;
  String powerKwh;

  ProdEnergiDsData({
    required this.interval,
    required this.powerKwh,
  });
}

class ProdEnergiTotal {
  dynamic interval;
  String powerKwh;

  ProdEnergiTotal({
    required this.interval,
    required this.powerKwh,
  });
}

class LoadData {
  String hours;
  String powerKwh;

  LoadData({
    required this.hours,
    required this.powerKwh,
  });
}
