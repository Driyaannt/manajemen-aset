// model notif untuk WS
class NotifWs {
  final dynamic wsId;
  final dynamic diffTimeWs;
  final dynamic status;
  final dynamic msg;

  NotifWs({
    this.wsId,
    this.diffTimeWs,
    this.status,
    this.msg,
  });

  factory NotifWs.fromJson(Map<String, dynamic> json) {
    return NotifWs(
      wsId: json['ws']['ws_id'],
      diffTimeWs: json['ws']['diff_time_ws'],
      status: json['ws']['status'] ?? '-',
      msg: json['ws']['msg'] ?? '-',
    );
  }
}

// model notif untuk WT
class NotifWt {
  final dynamic wtId;
  final dynamic diffTimeWt;
  final dynamic status;
  final dynamic msg;

  NotifWt({
    this.wtId,
    this.diffTimeWt,
    this.status,
    this.msg,
  });

  factory NotifWt.fromJson(Map<String, dynamic> json) {
    return NotifWt(
      wtId: json['wt']['wt_id'],
      diffTimeWt: json['wt']['diff_time_wt'],
      status: json['wt']['status'] ?? '-',
      msg: json['wt']['msg'] ?? '-',
    );
  }
}

// model notif untuk SP
class NotifSp {
  final dynamic spId;
  final dynamic diffTimeSp;
  final dynamic status;
  final dynamic msg;

  NotifSp({
    this.spId,
    this.diffTimeSp,
    this.status,
    this.msg,
  });

  factory NotifSp.fromJson(Map<String, dynamic> json) {
    return NotifSp(
      spId: json['sp']['sp_id'],
      diffTimeSp: json['sp']['diff_time_sp'],
      status: json['sp']['status'],
      msg: json['sp']['msg'],
    );
  }
}
