import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityModel {
  String uid;
  String activityId;
  String? organizationId;
  String organizationName;
  double hours;
  DateTime dateFrom;
  DateTime? dateTo;
  Timestamp dateCreated;
  String? notes;
  List<String>? picsUrl;

  ActivityModel({
    required this.uid,
    required this.activityId,
    this.organizationId,
    required this.organizationName,
    required this.hours,
    required this.dateFrom,
    required this.dateCreated,
    this.dateTo,
    this.notes,
    this.picsUrl,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) => ActivityModel(
      uid: json["uid"],
      activityId: json["activityId"],
      organizationId: json["organizationId"],
      organizationName: json["organizationName"],
      hours: json["hours"],
      dateFrom: (json["dateFrom"] is Timestamp)
          ? (json["dateFrom"] as Timestamp).toDate()
          : json["dateFrom"],
      dateTo: (json["dateTo"] is Timestamp)
          ? (json["dateTo"] as Timestamp).toDate()
          : json["dateTo"],
      notes: json["notes"],
      picsUrl: json["picsUrl"] != null
          ? (json["picsUrl"] as List).map((e) => (e as String)).toList()
          : json["picsUrl"],
      dateCreated: json["dateCreated"]);

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "activityId": activityId,
        "organizationId": organizationId,
        "organizationName": organizationName,
        "hours": hours,
        "dateFrom": dateFrom,
        "dateTo": dateTo,
        "notes": notes,
        "picsUrl": picsUrl,
        "dateCreated": dateCreated
      };
}
