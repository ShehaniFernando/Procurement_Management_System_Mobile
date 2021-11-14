import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:procurement_management_system_frontend/constants.dart' as Constants;
import 'package:procurement_management_system_frontend/model/material_model.dart';
import 'package:procurement_management_system_frontend/model/site_model.dart';
import 'package:procurement_management_system_frontend/model/supplier_modal.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // var sites = List<SiteModal>.generate(200, (index) => null);
  late List<String> sites;
  late List<String> suppliers;
  // late Map<String, double> materials;
  late List<MaterialModal> materials;
  late MaterialModal materialValue;
  String _comment = '';
  String? siteValue;
  String? supplierValue;
  String? materialName;
  double? materialPrice;
  double _quantity = 0;
  TextEditingController priceController = new TextEditingController();
  TextEditingController quantityController = new TextEditingController();
  TextEditingController totalAmountController = new TextEditingController();
  late Future materialFuture;
  late Future siteFuture;
  late Future supplierFuture;
  DateTime deliveryDate = DateTime.now();
  double priceVal = 0;
  double qtyVal = 0;

  @override
  void initState() {
    super.initState();
    materialFuture = this.getMaterials();
    siteFuture = this.getSites();
    supplierFuture = this.getSupplier();
    this.totalAmountController.text = (0.00).toString();

    priceController.addListener(() {
      if (priceController.text == '') {
        totalAmountController.text = (0.0).toString();
      } else {
        totalAmountController.text = (double.parse(priceController.text) *
                double.parse(quantityController.text))
            .toString();
      }
    });
  }

  Future<void> getSites() async {
    var data = await http.get(
        Uri.parse(Constants.BASE_URL + Constants.URL_SITES),
        headers: {"Accept": "application/json"});

    var jsonData = await convert.json.decode(data.body);

    sites = [];

    for (var e in jsonData) {
      if (e["status"] == "available") {
        SiteModal site = new SiteModal(
            id: e["id"],
            name: e["name"],
            address: e["address"],
            city: e["city"],
            mobile: e["mobile"],
            status: e["status"]);

        sites.add(site.name);
      }
    }
    siteValue = sites[0];
  }

  Future<void> getSupplier() async {
    var data = await http.get(
        Uri.parse(Constants.BASE_URL + Constants.URL_SUPPLIERS),
        headers: {"Accept": "application/json"});

    var jsonData = await convert.json.decode(data.body);

    suppliers = [];

    for (var e in jsonData) {
      if (e["status"] == "available") {
        SupplierModal supplier = new SupplierModal(
            id: e["id"],
            name: e["name"],
            mobile: e["mobile"],
            address: e["address"],
            city: e["city"],
            status: e["status"]);

        suppliers.add(supplier.name);
      }
    }
    supplierValue = suppliers[0];
  }

  Future<void> getMaterials() async {
    var data = await http.get(
        Uri.parse(Constants.BASE_URL + Constants.URL_MATERIALS),
        headers: {"Accept": "application/json"});

    var jsonData = await convert.json.decode(data.body);

    // materials = {};
    materials = [];

    for (var e in jsonData) {
      if (e["status"] == "available") {
        MaterialModal material = new MaterialModal(
            id: e["id"],
            name: e["name"],
            price: e["price"],
            status: e["status"]);

        materials.add(material);
      }
    }
    materialValue = materials[0];
    priceController.text = materialValue.price.toString();
  }

  calcTotal(String val) async {
    double tot = double.parse(priceController.text) *
        double.parse(quantityController.text);
    totalAmountController.text = (tot).toString();
  }

  placeOrder() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      var url = Constants.BASE_URL + Constants.URL_ORDERS;

      var json_body = {
        "item": materialValue.name,
        "quantity": _quantity,
        "supplier": supplierValue,
        "comment": _comment,
        "site": siteValue,
        "deliveryDate": deliveryDate.toIso8601String()
      };

      var response = await http.post(Uri.parse(url),
          headers: <String, String>{"Content-Type": "application/json"},
          body: convert.jsonEncode(json_body));

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: Constants.ORDER_PLACED_SUCCESSFULLY,
            backgroundColor: Colors.grey,
            fontSize: 18);
        _comment = '';
        _quantity = 0;
      } else {
        Fluttertoast.showToast(
            msg: Constants.ERROR_ORDER,
            backgroundColor: Colors.grey,
            fontSize: 18);
      }
    }
  }

  Future pickDate(BuildContext context) async {
    final newDate = await showDatePicker(
        context: context,
        initialDate: deliveryDate,
        firstDate: DateTime(DateTime.now().year),
        lastDate: DateTime(DateTime.now().year + 1));

    if (newDate == null) return;

    setState(() {
      deliveryDate = newDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: Text('Place Order'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        backwardsCompatibility: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(height: 30),
              Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [                   
                          SizedBox(height: 15),
                          Container(
                            padding: const EdgeInsets.fromLTRB(50, 0, 50, 5),
                            child: FutureBuilder(
                                future: siteFuture,
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.connectionState ==
                                          ConnectionState.active ||
                                      snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                    return Container(
                                        child:
                                            Center(child: Icon(Icons.error)));
                                  }
                                  return InputDecorator(
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        labelStyle: TextStyle(
                                          fontFamily: 'Product Sans',
                                          fontSize: 20,
                                          color: Color(0xff8f9db5),
                                        ),
                                        filled: false,
                                        labelText: 'Site',
                                      ),
                                      child: DropdownButton<String>(
                                        value: siteValue,
                                        style: TextStyle(
                                          color: Color(0xff0962ff)
                                        ),
                                        items:
                                            sites.map(buildMenuItem).toList(),
                                        onChanged: (value) => setState(
                                            () => this.siteValue = value),
                                      ));
                                }),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(50, 0, 50, 5),
                            child: FutureBuilder(
                                future: supplierFuture,
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.connectionState ==
                                          ConnectionState.active ||
                                      snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                    return Container(
                                        child:
                                            Center(child: Icon(Icons.error)));
                                  }
                                  return InputDecorator(
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        labelStyle: TextStyle(
                                          fontFamily: 'Product Sans',
                                          fontSize: 20,
                                          color: Color(0xff8f9db5),
                                        ),
                                        filled: false,
                                        labelText: 'Supplier',
                                      ),
                                      child: DropdownButton<String>(
                                        value: supplierValue,
                                        style: TextStyle(
                                          color: Color(0xff0962ff)
                                        ),
                                        items: suppliers
                                            .map(buildMenuItem)
                                            .toList(),
                                        onChanged: (value) => setState(
                                            () => this.supplierValue = value),
                                      ));
                                }),
                          ),

                          Container(
                            padding: const EdgeInsets.fromLTRB(50, 0, 50, 5),
                            child: FutureBuilder(
                                future: materialFuture,
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.connectionState ==
                                          ConnectionState.active ||
                                      snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                    return Container(
                                        child:
                                            Center(child: Icon(Icons.error)));
                                  }
                                  return InputDecorator(
                                      decoration: InputDecoration(
                                        labelStyle: TextStyle(
                                          fontFamily: 'Product Sans',
                                          fontSize: 20,
                                          color: Color(0xff8f9db5),
                                        ),
                                        border: InputBorder.none,
                                        filled: false,
                                        labelText: 'Item',
                                      ),
                                      child: DropdownButton<MaterialModal>(
                                        value: materialValue,
                                        onChanged: (MaterialModal? newValue) {
                                          setState(() {
                                            materialValue = newValue!;
                                            priceController.text =
                                                materialValue.price.toString();
                                          });
                                        },
                                        items: materials
                                            .map((MaterialModal value) {
                                          return DropdownMenuItem<
                                              MaterialModal>(
                                            value: value,
                                            child: Text(
                                              value.name,
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Color(0xff0962ff),
                                                fontWeight: FontWeight.w700
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ));

                                  // DropdownButton<String>(
                                  //   value: supplierValue,
                                  //   items: suppliers.map(buildMenuItem).toList(),
                                  //   onChanged: (value) => setState(
                                  //       () => this.supplierValue = value),
                                  // );
                                }),
                          ),

                          FutureBuilder(
                              future: materialFuture,
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.active ||
                                    snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                  return Container(
                                      child: Center(child: Icon(Icons.error)));
                                }
                                return Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    SizedBox(height: 10),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 50.0, bottom: 8),
                                        child: Text(
                                          'Item Price',
                                          style: TextStyle(
                                            fontFamily: 'Product Sans',
                                            fontSize: 15,
                                            color: Color(0xff8f9db5),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          40, 0, 40, 15),
                                      child: TextFormField(
                                        controller: priceController,
                                        enabled: false,
                                        style: TextStyle(
                                            fontSize: 19,
                                            color: Color(0xff0962ff),
                                            fontWeight: FontWeight.bold),
                                        decoration: InputDecoration(
                                          filled: false,
                                          hintText: 'Price',
                                          hintStyle: TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey[350],
                                              fontWeight: FontWeight.w600),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 20, horizontal: 25),
                                          focusColor: Color(0xff0962ff),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            borderSide: BorderSide(
                                                color: Color(0xff0962ff)),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              borderSide: BorderSide(
                                                color: (Colors.grey[350])!,
                                              )),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),

                          SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 50.0, bottom: 8),
                              child: Text(
                                'Quantity',
                                style: TextStyle(
                                  fontFamily: 'Product Sans',
                                  fontSize: 15,
                                  color: Color(0xff8f9db5),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(40, 0, 40, 15),
                            child: TextFormField(
                              onChanged: (val) {
                                if (val == '') {
                                  totalAmountController.text = (0.0).toString();
                                } else {
                                  totalAmountController
                                      .text = (double.parse(val) *
                                          double.parse(priceController.text))
                                      .toString();
                                }
                              },
                              controller: quantityController,
                              keyboardType: TextInputType.number,
                              validator: (input) {
                                if (input != null && input.isEmpty)
                                  return 'Quantity cannot be empty';
                              },
                              onSaved: (input) =>
                                  _quantity = double.parse(input.toString()),
                              style: TextStyle(
                                  fontSize: 19,
                                  color: Color(0xff0962ff),
                                  fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                hintText: 'Number of items required',
                                hintStyle: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[350],
                                    fontWeight: FontWeight.w600),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 25),
                                focusColor: Color(0xff0962ff),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Color(0xff0962ff)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      color: (Colors.grey[350])!,
                                    )),
                              ),
                            ),
                          ),

                          SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 50.0, bottom: 8),
                              child: Text(
                                'Total Amount',
                                style: TextStyle(
                                  fontFamily: 'Product Sans',
                                  fontSize: 15,
                                  color: Color(0xff8f9db5),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(40, 0, 40, 15),
                            child: TextFormField(
                              controller: totalAmountController,
                              enabled: false,
                              style: TextStyle(
                                  fontSize: 19,
                                  color: Color(0xff0962ff),
                                  fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                filled: false,
                                hintText: 'Total amount of the order',
                                hintStyle: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[350],
                                    fontWeight: FontWeight.w600),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 25),
                                focusColor: Color(0xff0962ff),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Color(0xff0962ff)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      color: (Colors.grey[350])!,
                                    )),
                              ),
                            ),
                          ),
                          SizedBox(height: 25),
                          // ButtonHeaderWidget(
                          //     title: 'Delivery Date',
                          //     text: 'Select date of expected delivery',
                          //     onClicked: () => pickDate(this.context)),

                          // DatePickerDialog(
                          //   initialDate: DateTime.now(),
                          //   firstDate: DateTime(DateTime.now().year),
                          //   lastDate: DateTime(DateTime.now().year + 1)),

                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 50.0, bottom: 8),
                              child: Text(
                                'Delivery Date',
                                style: TextStyle(
                                  fontFamily: 'Product Sans',
                                  fontSize: 15,
                                  color: Color(0xff8f9db5),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(40, 0, 40, 15),
                            child: ElevatedButton(
                              onPressed: () {
                                pickDate(context);
                              },
                              child: (deliveryDate == DateTime.now())
                                  ? Text('Pick delivery date')
                                  : Text(
                                      '${deliveryDate.day}/${deliveryDate.month}/${deliveryDate.year}'),
                            ),
                          ),
                          SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 50.0, bottom: 8),
                              child: Text(
                                'Comment',
                                style: TextStyle(
                                  fontFamily: 'Product Sans',
                                  fontSize: 15,
                                  color: Color(0xff8f9db5),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(40, 0, 40, 15),
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              validator: (input) {
                                if (input != null && input.isEmpty)
                                  return 'Comment cannot be empty';
                              },
                              onSaved: (input) => _comment = input.toString(),
                              style: TextStyle(
                                  fontSize: 19,
                                  color: Color(0xff0962ff),
                                  fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                hintText: 'This is my first order',
                                hintStyle: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[350],
                                    fontWeight: FontWeight.w600),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 25),
                                focusColor: Color(0xff0962ff),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Color(0xff0962ff)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      color: (Colors.grey[350])!,
                                    )),
                              ),
                            ),
                          ),

                          SizedBox(height: 25),
                          ElevatedButton(
                            onPressed: placeOrder,
                            child: Text(
                              'PLACE ORDER',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100.0),
                                )),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.blue.shade800),
                                padding: MaterialStateProperty.all<
                                        EdgeInsetsGeometry>(
                                    EdgeInsets.fromLTRB(60, 15, 60, 15))),
                          ),
                          SizedBox(height: 25),
                        ],
                      ))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
      value: item,
      child: Text(
        item,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ));
}
