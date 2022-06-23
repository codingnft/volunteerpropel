import 'package:cloud_firestore/cloud_firestore.dart';

class OrganizationModel {
  OrganizationModel({
    required this.organizationId,
    required this.name,
    required this.description,
    required this.logoUrl,
    required this.phone,
    required this.contactName,
    required this.contactEmail,
    required this.contactPhone,
    required this.address,
    required this.websiteUrl,
    required this.dateCreated,
  });

  String organizationId;
  String name;
  String description;
  String logoUrl;
  String phone;
  String contactName;
  String contactEmail;
  String contactPhone;
  String address;
  String websiteUrl;
  Timestamp dateCreated;

  factory OrganizationModel.fromJson(Map<String, dynamic> json) =>
      OrganizationModel(
        organizationId: json["organizationId"],
        name: json["name"],
        description: json["description"],
        logoUrl: json["logoUrl"],
        phone: json["phone"],
        contactName: json["contactName"],
        contactEmail: json["contactEmail"],
        contactPhone: json["contactPhone"],
        address: json["address"],
        websiteUrl: json["websiteUrl"],
        dateCreated: json["dateCreated"],
      );

  Map<String, dynamic> toJson() => {
        "organizationId": organizationId,
        "name": name,
        "description": description,
        "logoUrl": logoUrl,
        "phone": phone,
        "contactName": contactName,
        "contactEmail": contactEmail,
        "contactPhone": contactPhone,
        "address": address,
        "websiteUrl": websiteUrl,
        "dateCreated": dateCreated,
      };
}
