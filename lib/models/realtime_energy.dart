class RealtimeEnergyWt {
  String dateUtc;
  String windSpeed;
  String powerWatt;

  RealtimeEnergyWt(
    this.dateUtc,
    this.windSpeed,
    this.powerWatt,
  );
}

class RealtimeEnergySp {
  String dateUtc;
  String solarRad;
  String powerSp;
  String bbm;
  String powerDiesel;

  RealtimeEnergySp(
    this.dateUtc,
    this.solarRad,
    this.powerSp,
    this.bbm,
    this.powerDiesel,
  );
}
