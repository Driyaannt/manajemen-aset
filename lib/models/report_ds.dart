class ReportDs {
  final dynamic minWatt;
  final dynamic maxWatt;
  final dynamic avgWatt;
  final dynamic minVolt;
  final dynamic maxVolt;
  final dynamic avgVolt;
  final dynamic minArus;
  final dynamic maxArus;
  final dynamic avgArus;

  ReportDs({
    this.minWatt,
    this.maxWatt,
    this.avgWatt,
    this.minVolt,
    this.maxVolt,
    this.avgVolt,
    this.minArus,
    this.maxArus,
    this.avgArus,
  });

  factory ReportDs.fromJson(Map<String, dynamic> json) {
    return ReportDs(
      minWatt: json['report']['max_watt'] ?? '-',
      maxWatt: json['report']['max_watt'] ?? '-',
      avgWatt: json['report']['max_watt'] ?? '-',
      minVolt: json['report']['min_volt'] ?? '-',
      maxVolt: json['report']['max_volt'] ?? '-',
      avgVolt: json['report']['avg_volt'] ?? '-',
      minArus: json['report']['min_ampere'] ?? '-',
      maxArus: json['report']['max_ampere'] ?? '-',
      avgArus: json['report']['avg_ampere'] ?? '-',
    );
  }
}
