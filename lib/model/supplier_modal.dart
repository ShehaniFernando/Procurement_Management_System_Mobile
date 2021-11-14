import 'dart:convert';

SupplierModal supplierModalJson(String str) => SupplierModal.fromJson(json.decode(str));

String supplierModalToJson(SupplierModal data) => jsonEncode(data.toJson());

class SupplierModal {
  String id;
  String name;
  String mobile;
  String address;
  String city;
  String status;
  
  SupplierModal(
      {required this.id,
      required this.name,
      required this.mobile,
      required this.address,
      required this.city,
      required this.status});

  factory SupplierModal.fromJson(Map<String, dynamic> json) => SupplierModal(
      id: json["id"],
      name: json["name"],
      mobile: json["mobile"],
      address: json["address"],
      city: json["city"],
      status: json["status"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "mobile": mobile,
        "address": address,
        "city": city,
        "status": status
      };

  String get supplier_name => name;
  String get supplier_mobile => mobile;
  String get supplier_address => address;
  String get supplier_city => city;
  String get supplier_status => status;
}
