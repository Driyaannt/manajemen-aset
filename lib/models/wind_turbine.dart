// ignore_for_file: public_member_api_docs, sort_constructors_first
// model
class WtData {
  String dateUtc;
  String windSpeed;
  String rpmBilah;
  String rpmGenerator;
  String powerWatt;
  String ampereDc;
  String voltDc;

  WtData(
    this.dateUtc,
    this.windSpeed,
    this.rpmBilah,
    this.rpmGenerator,
    this.powerWatt,
    this.ampereDc,
    this.voltDc,
  );
}

class WtDailyProd {
  final dynamic id;
  final dynamic day;
  final dynamic powerKwh;
  final dynamic powerWatt;

  WtDailyProd({
    this.id,
    this.day,
    this.powerKwh,
    this.powerWatt,
  });

  factory WtDailyProd.fromJson(Map<String, dynamic> json) {
    return WtDailyProd(
      id: json['id'],
      day: json['day'],
      powerKwh: json['power_kwh'] ?? '-',
      powerWatt: json['power_watt'] ?? '-',
    );
  }
}
