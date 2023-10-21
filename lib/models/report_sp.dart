class ReportSp {
  final dynamic minSolarRad;
  final dynamic maxSolarRad;
  final dynamic avgSolarRad;
  final dynamic minPower;
  final dynamic maxPower;
  final dynamic avgPower;
  final dynamic minProdKwh;
  final dynamic maxProdKwh;
  final dynamic avgProdKwh;
  // final dynamic minTegangan;
  // final dynamic maxTegangan;
  // final dynamic avgTegangan;
  // final dynamic minArus;
  // final dynamic maxArus;
  // final dynamic avgArus;

  ReportSp({
    this.minSolarRad,
    this.maxSolarRad,
    this.avgSolarRad,
    this.minPower,
    this.maxPower,
    this.avgPower,
    this.minProdKwh,
    this.maxProdKwh,
    this.avgProdKwh,
    // this.minTegangan,
    // this.maxTegangan,
    // this.avgTegangan,
    // this.minArus,
    // this.maxArus,
    // this.avgArus,
  });

  // factory ReportSp.fromJson(Map<String, dynamic> json) {
  //   return ReportSp(
  //     minSolarRad: json['report']['max_rpm_generator'] ?? '-',
  //     maxSolarRad: json['report']['max_rpm_bilah'] ?? '-',
  //     avgSolarRad: json['report']['prod_kwh'] ?? '-',
  //     minPower: json['report']['max_watt'] ?? '-',
  //     maxPower: json['report']['max_volt'] ?? '-',
  //     avgPower: json['report']['max_ampere'] ?? '-',
  //     minProdKwh: json['report']['prod_kwh'] ?? '-',
  //     maxProdKwh: json['report']['prod_kwh'] ?? '-',
  //     avgProdKwh: json['report']['prod_kwh'] ?? '-',
  //   );
  // }
}

class ReportSpData {
  dynamic interval;
  String solarRad;
  String powerKwh;
  String powerWatt;

  ReportSpData({
    required this.interval,
    required this.solarRad,
    required this.powerKwh,
    required this.powerWatt,
  });
}
