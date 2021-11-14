import 'dart:convert';

SiteModal siteModalJson(String str) => SiteModal.fromJson(json.decode(str));

String siteModalToJson(SiteModal data) => jsonEncode(data.toJson());

class SiteModal {
  String id;
  String name;
  String address;
  String city;
  String mobile;
  String status;

  SiteModal(
      {required this.id,
      required this.name,
      required this.address,
      required this.city,
      required this.mobile,
      required this.status});

  factory SiteModal.fromJson(Map<String, dynamic> json) => SiteModal(
      id: json["id"],
      name: json["name"],
      address: json["address"],
      city: json["city"],
      mobile: json["mobile"],
      status: json["status"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address,
        "city": city,
        "mobile": mobile,
        "status": status
      };

  String get site_name => name;
  String get site_address => address;
  String get site_city => city;
  String get site_mobile => mobile;
  String get site_status => status;
}
