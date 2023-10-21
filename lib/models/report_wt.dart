// ignore_for_file: public_member_api_docs, sort_constructors_first
// model
class ReportWt {
  final dynamic minRpmGenerator;
  final dynamic maxRpmGenerator;
  final dynamic avgRpmGenerator;
  final dynamic minRpmBilah;
  final dynamic maxRpmBilah;
  final dynamic avgRpmBilah;
  final dynamic minProdKwh;
  final dynamic maxProdKwh;
  final dynamic avgProdKwh;
  final dynamic minWatt;
  final dynamic maxWatt;
  final dynamic avgWatt;
  final dynamic minVolt;
  final dynamic maxVolt;
  final dynamic avgVolt;
  final dynamic minArus;
  final dynamic maxArus;
  final dynamic avgArus;
  final dynamic minWindSpeed;
  final dynamic maxWindSpeed;
  final dynamic avgWindSpeed;

  ReportWt({
    this.minRpmGenerator,
    this.maxRpmGenerator,
    this.avgRpmGenerator,
    this.minRpmBilah,
    this.maxRpmBilah,
    this.avgRpmBilah,
    this.minProdKwh,
    this.maxProdKwh,
    this.avgProdKwh,
    this.minWatt,
    this.maxWatt,
    this.avgWatt,
    this.minVolt,
    this.maxVolt,
    this.avgVolt,
    this.minArus,
    this.maxArus,
    this.avgArus,
    this.minWindSpeed,
    this.maxWindSpeed,
    this.avgWindSpeed,
  });

  factory ReportWt.fromJson(Map<String, dynamic> json) {
    return ReportWt(
      minRpmGenerator: json['report']['min_rpm_generator'] ?? '-',
      maxRpmGenerator: json['report']['max_rpm_generator'] ?? '-',
      avgRpmGenerator: json['report']['avg_rpm_generator'] ?? '-',
      minRpmBilah: json['report']['min_rpm_bilah'] ?? '-',
      maxRpmBilah: json['report']['max_rpm_bilah'] ?? '-',
      avgRpmBilah: json['report']['avg_rpm_bilah'] ?? '-',
      minProdKwh: json['report']['min_kwh'] ?? '-',
      maxProdKwh: json['report']['max_kwh'] ?? '-',
      avgProdKwh: json['report']['avg_kwh'] ?? '-',
      minWatt: json['report']['min_watt'] ?? '-',
      maxWatt: json['report']['max_watt'] ?? '-',
      avgWatt: json['report']['avg_watt'] ?? '-',
      minVolt: json['report']['min_volt'] ?? '-',
      maxVolt: json['report']['max_volt'] ?? '-',
      avgVolt: json['report']['avg_volt'] ?? '-',
      minArus: json['report']['min_ampere'] ?? '-',
      maxArus: json['report']['max_ampere'] ?? '-',
      avgArus: json['report']['avg_ampere'] ?? '-',
      minWindSpeed: json['report']['min_windspeed'] ?? '-',
      maxWindSpeed: json['report']['max_windspeed'] ?? '-',
      avgWindSpeed: json['report']['avg_windspeed'] ?? '-',
    );
  }
}
