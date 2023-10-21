class Cluster {
  int idCluster;
  String clusterName;
  String kecamatan;
  String area;
  String wilayah;
  String longitude;
  String latitude;
  String isActive;
  String totalWt;
  String totalSp;
  String totalDs;
  String totalBt;
  String totalInv;
  String kwhWtD;
  String kwhSpD;
  String kwhDsD;
  String kwhBtD;
  String kwhIvD;
  String kwhWtM;
  String kwhSpM;
  String kwhDsM;
  String kwhBtM;
  String kwhIvM;
  //  String kwhTotal;

  Cluster({
    required this.idCluster,
    required this.clusterName,
    required this.kecamatan,
    required this.area,
    required this.wilayah,
    required this.longitude,
    required this.latitude,
    required this.isActive,
    required this.totalWt,
    required this.totalSp,
    required this.totalDs,
    required this.totalBt,
    required this.totalInv,
    required this.kwhWtD,
    required this.kwhSpD,
    required this.kwhDsD,
    required this.kwhBtD,
    required this.kwhIvD,
    required this.kwhWtM,
    required this.kwhSpM,
    required this.kwhDsM,
    required this.kwhBtM,
    required this.kwhIvM,
  });

  // factory Cluster.fromJson(Map<String, dynamic> json) {
  //   return Cluster(
  //     idCluster: int.tryParse(json['cluster_id'].toString()),
  //     clusterName: json['cluster_name'] as String,
  //     kecamatan: json['kecamatan'] as String,
  //     area: json['area'] as String,
  //     wilayah: json['wilayah'] as String,
  //     longitude: json['cluster_longitude'] as String,
  //     latitude: json['cluster_latitude'] as String,
  //     isActive: json['is_active'] as String,
  //     totalWt: json['total_wt'] as String,
  //     totalSp: json['total_sp'] as String,
  //     totalDs: json['total_diesel'] as String,
  //     totalBt: json['total_battery'] as String,
  //     totalInv: json['total_inverter'] as String,
  //     kwhWtD: json['kwh_wt_day'] as String,
  //     kwhSpD: json['kwh_sp_day'] as String,
  //     kwhDsD: json['kwh_diesel_day'] as String,
  //     kwhBtD: json['kwh_battery_day'] as String,
  //     kwhIvD: json['kwh_inverter_day'] as String,
  //     kwhWtM: json['kwh_wt_mon'] as String,
  //     kwhSpM: json['kwh_sp_mon'] as String,
  //     kwhDsM: json['kwh_diesel_mon'] as String,
  //     kwhBtM: json['kwh_battery_mon'] as String,
  //     kwhIvM: json['kwh_inverter_mon'] as String,
  //   );
  // }
}
