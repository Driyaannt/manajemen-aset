// ignore_for_file: public_member_api_docs, sort_constructors_first
// realtime
class SpData {
  String dateTime;
  String solarRad;
  String energiPrimer;
  String volt;
  String ampere;
  String power;

  SpData(
    this.dateTime,
    this.solarRad,
    this.energiPrimer,
    this.volt,
    this.ampere,
    this.power,
  );
}

class SpDailyProd {
  String? id;
  String? day;
  String? powerWatt;
  String? powerKwh;

  SpDailyProd({
    this.id,
    this.day,
    this.powerWatt,
    this.powerKwh,
  });

  factory SpDailyProd.fromJson(Map<String, dynamic> json) {
    return SpDailyProd(
      id: json['id'],
      day: json['day'],
      powerKwh: json['power_kwh'] ?? '-',
      powerWatt: json['power_watt'] ?? '-',
    );
  }

  // SpDailyProd(
  //   this.id,
  //   this.day,
  //   this.powerWatt,
  //   this.powerKwh,
  // );
}
