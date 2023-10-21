class ReportWs {
  String? dateYear;
  String? dateMonth;
  String? dateDay;
  String? monthName;
  String? minWindSpeed;
  String? minWindDir;
  String? minTemp;
  String? minUvIndex;
  String? minSolarRad;
  String? minCurahHujan;
  String? avgWindSpeed;
  String? avgWindDir;
  String? avgTemp;
  String? avgUvIndex;
  String? avgSolarRad;
  String? avgCurahHujan;
  String? maxWindSpeed;
  String? maxWindDir;
  String? maxTemp;
  String? maxUvIndex;
  String? maxSolarRad;
  String? maxCurahHujan;

  ReportWs({
    this.dateYear,
    this.dateMonth,
    this.dateDay,
    this.monthName,
    this.minWindSpeed,
    this.minWindDir,
    this.minTemp,
    this.minUvIndex,
    this.minSolarRad,
    this.minCurahHujan,
    this.avgWindSpeed,
    this.avgWindDir,
    this.avgTemp,
    this.avgUvIndex,
    this.avgSolarRad,
    this.avgCurahHujan,
    this.maxWindSpeed,
    this.maxWindDir,
    this.maxTemp,
    this.maxUvIndex,
    this.maxSolarRad,
    this.maxCurahHujan,
  });

  factory ReportWs.fromJson(Map<String, dynamic> json) {
    return ReportWs(
      dateYear: json['date_year'] ?? '-',
      dateMonth: json['date_month'] ?? '-',
      dateDay: json['date_day'] ?? '-',
      monthName: json['month_name'] ?? '-',
      minWindSpeed: json['min_wind_speed'] ?? '-',
      minWindDir: json['min_wind_dir'] ?? '-',
      minTemp: json['min_temp'] ?? '-',
      minUvIndex: json['min_uv_index'] ?? '-',
      minSolarRad: json['min_solar_rad'] ?? '-',
      minCurahHujan: json['min_curah_hujan'] ?? '-',
      avgWindSpeed: json['avg_wind_speed'] ?? '-',
      avgWindDir: json['avg_wind_dir'] ?? '-',
      avgTemp: json['avg_temp'] ?? '-',
      avgUvIndex: json['avg_uv_index'] ?? '-',
      avgCurahHujan: json['avg_curah_hujan'] ?? '-',
      avgSolarRad: json['avg_solar_rad'] ?? '-',
      maxWindSpeed: json['max_wind_speed'] ?? '-',
      maxWindDir: json['max_wind_dir'] ?? '-',
      maxTemp: json['max_temp'] ?? '-',
      maxUvIndex: json['max_uv_index'] ?? '-',
      maxSolarRad: json['max_solar_rad'] ?? '-',
      maxCurahHujan: json['max_curah_hujan'] ?? '-',
    );
  }
}

class ReportWsMonth {
  String? dateYear;
  String? dateMonth;
  String? monthName;
  String? minWindSpeed;
  String? minWindDir;
  String? minTemp;
  String? minUvIndex;
  String? minSolarRad;
  String? minCurahHujan;
  String? avgWindSpeed;
  String? avgWindDir;
  String? avgTemp;
  String? avgUvIndex;
  String? avgSolarRad;
  String? avgCurahHujan;
  String? maxWindSpeed;
  String? maxWindDir;
  String? maxTemp;
  String? maxUvIndex;
  String? maxSolarRad;
  String? maxCurahHujan;

  ReportWsMonth({
    this.dateYear,
    this.dateMonth,
    this.monthName,
    this.minWindSpeed,
    this.minWindDir,
    this.minTemp,
    this.minUvIndex,
    this.minSolarRad,
    this.minCurahHujan,
    this.avgWindSpeed,
    this.avgWindDir,
    this.avgTemp,
    this.avgUvIndex,
    this.avgSolarRad,
    this.avgCurahHujan,
    this.maxWindSpeed,
    this.maxWindDir,
    this.maxTemp,
    this.maxUvIndex,
    this.maxSolarRad,
    this.maxCurahHujan,
  });

  factory ReportWsMonth.fromJson(Map<String, dynamic> json) {
    return ReportWsMonth(
      dateYear: json['date_year'] ?? '-',
      dateMonth: json['date_month'] ?? '-',
      monthName: json['month_name'] ?? '-',
      minWindSpeed: json['min_wind_speed'] ?? '-',
      minWindDir: json['min_wind_dir'] ?? '-',
      minTemp: json['min_temp'] ?? '-',
      minUvIndex: json['min_uv_index'] ?? '-',
      minSolarRad: json['min_solar_rad'] ?? '-',
      minCurahHujan: json['min_curah_hujan'] ?? '-',
      avgWindSpeed: json['avg_wind_speed'] ?? '-',
      avgWindDir: json['avg_wind_dir'] ?? '-',
      avgTemp: json['avg_temp'] ?? '-',
      avgUvIndex: json['avg_uv_index'] ?? '-',
      avgCurahHujan: json['avg_curah_hujan'] ?? '-',
      avgSolarRad: json['avg_solar_rad'] ?? '-',
      maxWindSpeed: json['max_wind_speed'] ?? '-',
      maxWindDir: json['max_wind_dir'] ?? '-',
      maxTemp: json['max_temp'] ?? '-',
      maxUvIndex: json['max_uv_index'] ?? '-',
      maxSolarRad: json['max_solar_rad'] ?? '-',
      maxCurahHujan: json['max_curah_hujan'] ?? '-',
    );
  }
}
