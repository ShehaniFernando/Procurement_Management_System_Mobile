import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:procurement_management_system_frontend/constants.dart' as Constants;
import 'package:procurement_management_system_frontend/page/home_page.dart';
import 'package:procurement_management_system_frontend/model/order_model.dart';

class ViewOrderPage extends StatefulWidget {
  final OrderModal orderModal;

  const ViewOrderPage({Key? key, required this.orderModal}) : super(key: key);

  @override
  _ViewOrderPageState createState() => _ViewOrderPageState();
}

class _ViewOrderPageState extends State<ViewOrderPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _id = '';
  String _item = '';
  double _price = 0;
  double _quantity = 0;
  String _supplier = '';
  String _status = '';
  double _amount = 0;
  String _comment = '';
  String _site = '';
  String _orderDate = '';
  String _deliveryDate = '';

  @override
  void initState() {
    super.initState();
    this.assignValues();
  }

  Future<void> assignValues() async {
    _id = widget.orderModal.id;
    _item = widget.orderModal.item;
    _price = widget.orderModal.price;
    _quantity = widget.orderModal.quantity;
    _supplier = widget.orderModal.supplier;
    _status = widget.orderModal.status;
    _amount = widget.orderModal.amount;
    _comment = widget.orderModal.comment;
    _site = widget.orderModal.site;
    _orderDate = widget.orderModal.orderDate;
    _deliveryDate = widget.orderModal.deliveryDate;
  }

  updateOrder(String val, BuildContext context) async {
    var url = Constants.BASE_URL + Constants.URL_ORDERS_DELIVERED + 
    _id.toString().trim();

    var response = await http.put(Uri.parse(url),
        headers: <String, String>{"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      generateInvoice();
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => HomePage()));
      Fluttertoast.showToast(
          msg: Constants.ORDER_STATUS_UPDATED_SUCCESSFULLY,
          backgroundColor: Colors.grey,
          fontSize: 18);
    } else {
      Fluttertoast.showToast(
          msg: Constants.ERROR_UPDATE_ORDER,
          backgroundColor: Colors.grey,
          fontSize: 18);
    }
  }

  generateInvoice() async {
    var url = Constants.BASE_URL + Constants.URL_INVOICES;

    var json_body = {"orderId": _id, "user": "Site Manager A"};

    var response = await http.post(Uri.parse(url),
        headers: <String, String>{"Content-Type": "application/json"},
        body: convert.jsonEncode(json_body));

    if (response.statusCode == 200) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => HomePage()));
      Fluttertoast.showToast(
          msg: Constants.INVOICE_GENERATED_SUCCESSFULLY,
          backgroundColor: Colors.grey,
          fontSize: 18);
    } else {
      Fluttertoast.showToast(
          msg: Constants.ERROR_GENERATING_INVOICE,
          backgroundColor: Colors.grey,
          fontSize: 18);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: assignValues(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('none');
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              return Scaffold(
                backgroundColor: Colors.lightBlue[50],
                appBar: AppBar(
                  title: Text('Order Details'),
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
                        Text(
                          (_status) == 'Referred' ? 'Pending' : _status,
                          style: TextStyle(
                              fontFamily: 'Nunito Sans',
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: (_status == 'Approved')
                                  ? Colors.yellow
                                  : (_status == 'Declined')
                                      ? Colors.red
                                      : (_status == 'Placed')
                                          ? Colors.orange
                                          : (_status == 'Delivered')
                                              ? Colors.green
                                              : Colors.lightGreen[300]),
                        ),
                        SizedBox(height: 30),
                        Container(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 50.0, bottom: 8),
                                    child: Text(
                                      'Order ID',
                                      style: TextStyle(
                                        fontFamily: 'Product Sans',
                                        fontSize: 15,
                                        color: Color(0xff8f9db5),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(40, 0, 40, 15),
                                  child: TextFormField(
                                    enabled: false,
                                    initialValue: _id,
                                    validator: (input) {
                                      if (input != null && input.isEmpty)
                                        return 'Description cannot be empty';
                                    },
                                    onSaved: (input) => _id = input.toString(),
                                    style: TextStyle(
                                        fontSize: 19,
                                        color: Color(0xff0962ff),
                                        fontWeight: FontWeight.bold),
                                    decoration: InputDecoration(
                                      hintText: 'Order Id',
                                      hintStyle: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey[350],
                                          fontWeight: FontWeight.w600),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 25),
                                      focusColor: Color(0xff0962ff),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
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
                                SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 50.0, bottom: 8),
                                    child: Text(
                                      'Item Name',
                                      style: TextStyle(
                                        fontFamily: 'Product Sans',
                                        fontSize: 15,
                                        color: Color(0xff8f9db5),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(40, 0, 40, 15),
                                  child: TextFormField(
                                    enabled: false,
                                    initialValue: _item,
                                    onSaved: (input) =>
                                        _item = input.toString(),
                                    style: TextStyle(
                                        fontSize: 19,
                                        color: Color(0xff0962ff),
                                        fontWeight: FontWeight.bold),
                                    decoration: InputDecoration(
                                      hintText: 'Item Name',
                                      hintStyle: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey[350],
                                          fontWeight: FontWeight.w600),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 25),
                                      focusColor: Color(0xff0962ff),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
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
                                SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 50.0, bottom: 8),
                                    child: Text(
                                      'Item Unit Price',
                                      style: TextStyle(
                                        fontFamily: 'Product Sans',
                                        fontSize: 15,
                                        color: Color(0xff8f9db5),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(40, 0, 40, 15),
                                  child: TextFormField(
                                    enabled: false,
                                    initialValue: _price.toString(),
                                    keyboardType: TextInputType.number,
                                    validator: (input) {
                                      if (input != null && input.isEmpty)
                                        return 'Item Price cannot be empty';
                                    },
                                    onSaved: (input) =>
                                        _price = double.parse(input.toString()),
                                    style: TextStyle(
                                        fontSize: 19,
                                        color: Color(0xff0962ff),
                                        fontWeight: FontWeight.bold),
                                    decoration: InputDecoration(
                                      hintText: 'Item Unit Price',
                                      hintStyle: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey[350],
                                          fontWeight: FontWeight.w600),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 25),
                                      focusColor: Color(0xff0962ff),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
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
                                SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 50.0, bottom: 8),
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
                                  padding:
                                      const EdgeInsets.fromLTRB(40, 0, 40, 15),
                                  child: TextFormField(
                                    enabled: false,
                                    initialValue: _quantity.toString(),
                                    keyboardType: TextInputType.number,
                                    validator: (input) {
                                      if (input != null && input.isEmpty)
                                        return 'Quantity cannot be empty';
                                    },
                                    onSaved: (input) => _quantity =
                                        double.parse(input.toString()),
                                    style: TextStyle(
                                        fontSize: 19,
                                        color: Color(0xff0962ff),
                                        fontWeight: FontWeight.bold),
                                    decoration: InputDecoration(
                                      hintText: 'Quantity',
                                      hintStyle: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey[350],
                                          fontWeight: FontWeight.w600),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 25),
                                      focusColor: Color(0xff0962ff),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
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
                                SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 50.0, bottom: 8),
                                    child: Text(
                                      'Supplier',
                                      style: TextStyle(
                                        fontFamily: 'Product Sans',
                                        fontSize: 15,
                                        color: Color(0xff8f9db5),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(40, 0, 40, 15),
                                  child: TextFormField(
                                    enabled: false,
                                    initialValue: _supplier.toString(),
                                    keyboardType: TextInputType.number,
                                    validator: (input) {
                                      if (input != null && input.isEmpty)
                                        return 'Quantity cannot be empty';
                                    },
                                    onSaved: (input) =>
                                        _supplier = input.toString(),
                                    style: TextStyle(
                                        fontSize: 19,
                                        color: Color(0xff0962ff),
                                        fontWeight: FontWeight.bold),
                                    decoration: InputDecoration(
                                      hintText: 'Quantity',
                                      hintStyle: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey[350],
                                          fontWeight: FontWeight.w600),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 25),
                                      focusColor: Color(0xff0962ff),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
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
                                SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 50.0, bottom: 8),
                                    child: Text(
                                      'Status',
                                      style: TextStyle(
                                        fontFamily: 'Product Sans',
                                        fontSize: 15,
                                        color: Color(0xff8f9db5),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(40, 0, 40, 15),
                                  child: TextFormField(
                                    enabled: false,
                                    initialValue: _status.toString(),
                                    keyboardType: TextInputType.number,
                                    validator: (input) {
                                      if (input != null && input.isEmpty)
                                        return 'Status cannot be empty';
                                    },
                                    onSaved: (input) =>
                                        _status = input.toString(),
                                    style: TextStyle(
                                        fontSize: 19,
                                        color: Color(0xff0962ff),
                                        fontWeight: FontWeight.bold),
                                    decoration: InputDecoration(
                                      hintText: 'Status',
                                      hintStyle: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey[350],
                                          fontWeight: FontWeight.w600),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 25),
                                      focusColor: Color(0xff0962ff),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
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
                                SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 50.0, bottom: 8),
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
                                  padding:
                                      const EdgeInsets.fromLTRB(40, 0, 40, 15),
                                  child: TextFormField(
                                    enabled: false,
                                    initialValue: _amount.toString(),
                                    keyboardType: TextInputType.number,
                                    validator: (input) {
                                      if (input != null && input.isEmpty)
                                        return 'Total amount cannot be empty';
                                    },
                                    onSaved: (input) => _amount =
                                        double.parse(input.toString()),
                                    style: TextStyle(
                                        fontSize: 19,
                                        color: Color(0xff0962ff),
                                        fontWeight: FontWeight.bold),
                                    decoration: InputDecoration(
                                      hintText: 'Total Amount',
                                      hintStyle: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey[350],
                                          fontWeight: FontWeight.w600),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 25),
                                      focusColor: Color(0xff0962ff),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
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
                                SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 50.0, bottom: 8),
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
                                  padding:
                                      const EdgeInsets.fromLTRB(40, 0, 40, 15),
                                  child: TextFormField(
                                    enabled: false,
                                    initialValue: _comment.toString(),
                                    keyboardType: TextInputType.number,
                                    validator: (input) {
                                      if (input != null && input.isEmpty)
                                        return 'Item Price cannot be empty';
                                    },
                                    onSaved: (input) =>
                                        _comment = input.toString(),
                                    style: TextStyle(
                                        fontSize: 19,
                                        color: Color(0xff0962ff),
                                        fontWeight: FontWeight.bold),
                                    decoration: InputDecoration(
                                      hintText: 'Comment',
                                      hintStyle: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey[350],
                                          fontWeight: FontWeight.w600),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 25),
                                      focusColor: Color(0xff0962ff),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
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
                                SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 50.0, bottom: 8),
                                    child: Text(
                                      'Site',
                                      style: TextStyle(
                                        fontFamily: 'Product Sans',
                                        fontSize: 15,
                                        color: Color(0xff8f9db5),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(40, 0, 40, 15),
                                  child: TextFormField(
                                    enabled: false,
                                    initialValue: _site.toString(),
                                    keyboardType: TextInputType.number,
                                    validator: (input) {
                                      if (input != null && input.isEmpty)
                                        return 'Site cannot be empty';
                                    },
                                    onSaved: (input) =>
                                        _site = input.toString(),
                                    style: TextStyle(
                                        fontSize: 19,
                                        color: Color(0xff0962ff),
                                        fontWeight: FontWeight.bold),
                                    decoration: InputDecoration(
                                      hintText: 'Site',
                                      hintStyle: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey[350],
                                          fontWeight: FontWeight.w600),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 25),
                                      focusColor: Color(0xff0962ff),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
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
                                SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 50.0, bottom: 8),
                                    child: Text(
                                      'Order Date',
                                      style: TextStyle(
                                        fontFamily: 'Product Sans',
                                        fontSize: 15,
                                        color: Color(0xff8f9db5),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(40, 0, 40, 15),
                                  child: TextFormField(
                                    enabled: false,
                                    initialValue:
                                        _orderDate.toString().split('T')[0],
                                    keyboardType: TextInputType.number,
                                    validator: (input) {
                                      if (input != null && input.isEmpty)
                                        return 'Order Date cannot be empty';
                                    },
                                    onSaved: (input) =>
                                        _orderDate = input.toString(),
                                    style: TextStyle(
                                        fontSize: 19,
                                        color: Color(0xff0962ff),
                                        fontWeight: FontWeight.bold),
                                    decoration: InputDecoration(
                                      hintText: 'Order Date',
                                      hintStyle: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey[350],
                                          fontWeight: FontWeight.w600),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 25),
                                      focusColor: Color(0xff0962ff),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
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
                                SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 50.0, bottom: 8),
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
                                  padding:
                                      const EdgeInsets.fromLTRB(40, 0, 40, 15),
                                  child: TextFormField(
                                    enabled: false,
                                    initialValue:
                                        _deliveryDate.toString().split('T')[0],
                                    keyboardType: TextInputType.number,
                                    validator: (input) {
                                      if (input != null && input.isEmpty)
                                        return 'Delivery Date cannot be empty';
                                    },
                                    onSaved: (input) =>
                                        _deliveryDate = input.toString(),
                                    style: TextStyle(
                                        fontSize: 19,
                                        color: Color(0xff0962ff),
                                        fontWeight: FontWeight.bold),
                                    decoration: InputDecoration(
                                      hintText: 'Delivery Date',
                                      hintStyle: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey[350],
                                          fontWeight: FontWeight.w600),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 25),
                                      focusColor: Color(0xff0962ff),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
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
                                SizedBox(height: 20),
                                if (_status == 'Placed') ...[
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () => showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                    title: Text(
                                                        'Confirm Delivery'),
                                                    content: Text(
                                                        'Click "OK" to confirm setting this order as delivered'),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context,
                                                                  'Cancel'),
                                                          child:
                                                              Text('Cancel')),
                                                      TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context,
                                                                  'OK'),
                                                          child: Text('OK'))
                                                    ],
                                                  )).then((value) => {
                                                if (value == 'OK')
                                                  {
                                                    updateOrder(
                                                        value.toString(),
                                                        context)
                                                  }
                                              }),
                                          child: Text(
                                            'SET AS DELIVERED',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                          style: ButtonStyle(
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        100.0),
                                              )),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      Colors.blue.shade800),
                                              padding: MaterialStateProperty
                                                  .all<EdgeInsetsGeometry>(
                                                      EdgeInsets.fromLTRB(
                                                          50, 15, 50, 15))),
                                        ),
                                        SizedBox(width: 10),
                                      ]),
                                  SizedBox(height: 30)
                                ]
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
        });
  }
}
