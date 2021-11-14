import 'dart:convert';

OrderModal orderModalJson(String str) => OrderModal.fromJson(json.decode(str));

String orderModalToJson(OrderModal data) => jsonEncode(data.toJson());

class OrderModal {
  String id;
  String item;
  double price;
  double quantity;
  String supplier;
  String status;
  double amount;
  String comment;
  String site;
  String orderDate;
  String deliveryDate;

  OrderModal(
      {required this.id,
      required this.item,
      required this.price,
      required this.quantity,
      required this.supplier,
      required this.status,
      required this.amount,
      required this.comment,
      required this.site,
      required this.orderDate,
      required this.deliveryDate});

  factory OrderModal.fromJson(Map<String, dynamic> json) => OrderModal(
      id: json["id"],
      item: json["item"],
      price: json["price"],
      quantity: json["quantity"],
      supplier: json["supplier"],
      status: json["status"],
      amount: json["amount"],
      comment: json["comment"],
      site: json["site"],
      orderDate: json["orderDate"],
      deliveryDate: json["deliveryDate"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "item": item,
        "price": price,
        "quantity": quantity,
        "supplier": supplier,
        "status": status,
        "amount": amount,
        "comment": comment,
        "site": site,
        "orderDate": orderDate,
        "deliveryDate": deliveryDate
      };

  String get order_id => id;
  String get order_item => item;
  double get order_price => price;
  double get order_quantity => quantity;
  String get order_supplier => supplier;
  String get order_status => status;
  double get order_amount => amount;
  String get order_comment => comment;
  String get order_site => site;
  String get order_orderDate => orderDate;
  String get order_deliveryDate => deliveryDate;
}
