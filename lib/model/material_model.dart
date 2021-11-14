import 'dart:convert';

MaterialModal materialModalJson(String str) =>
    MaterialModal.fromJson(json.decode(str));

String materialModalToJson(MaterialModal data) => jsonEncode(data.toJson());

class MaterialModal {
  String id;
  String name;
  double price;
  String status;

  MaterialModal(
      {required this.id,
      required this.name,
      required this.price,
      required this.status});

  factory MaterialModal.fromJson(Map<String, dynamic> json) => MaterialModal(
      id: json["id"],
      name: json["name"],
      price: json["price"],
      status: json["status"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "status": status
      };

  String get material_name => name;
  double get material_price => price;
  String get material_status => status;
}
