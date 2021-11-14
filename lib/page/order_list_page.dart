import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:procurement_management_system_frontend/constants.dart' as Constants;
import 'package:procurement_management_system_frontend/model/order_model.dart';
import 'package:procurement_management_system_frontend/page/view_order_page.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({Key? key}) : super(key: key);

  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  late List<OrderModal> orders;

  Future<void> getOrders() async {
    var data = await http.get(
        Uri.parse(Constants.BASE_URL + Constants.URL_ORDERS),
        headers: {"Accept": "application/json"});

    var jsonData = await convert.json.decode(data.body);

    orders = [];

    for (var e in jsonData) {
      OrderModal order = new OrderModal(
          id: e["id"],
          item: e["item"]["material"]["name"],
          price: e["item"]["material"]["price"],
          quantity: e["item"]["quantity"],
          supplier: e["supplier"]["name"],
          status: e["status"],
          amount: e["amount"],
          comment: e["comment"],
          site: e["site"]["name"],
          orderDate: e["purchaseTimestamp"],
          deliveryDate: e["deliveryTimestamp"]);

      orders.add(order);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: Text('Orders List'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        backwardsCompatibility: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FutureBuilder(
                      future: getOrders(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            return Text('none');
                          case ConnectionState.active:
                          case ConnectionState.waiting:
                            return Center(child: CircularProgressIndicator());
                          case ConnectionState.done:
                            return Column(
                              children: <Widget>[
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.84,
                                  child: ListView.builder(
                                      itemCount: orders.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ViewOrderPage(
                                                              orderModal:
                                                                  orders[
                                                                      index])));
                                            },
                                            child: Container(
                                                height: 180,
                                                child: Card(
                                                  color: Colors.blue[400],
                                                  elevation: 5,
                                                  child: Row(
                                                    children: <Widget>[
                                                      Column(
                                                        children: [
                                                          Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          10,
                                                                          25,
                                                                          5,
                                                                          0),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                        'Order Id : ',
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'Nunito Sans',
                                                                            fontSize:
                                                                                15,
                                                                            color:
                                                                                Colors.white70,
                                                                            fontWeight: FontWeight.w700,
                                                                            height: 2),
                                                                      ),
                                                                      Text(
                                                                        orders[index]
                                                                            .id,
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'Nunito Sans',
                                                                            fontSize:
                                                                                15,
                                                                            color:
                                                                                Colors.white70,
                                                                            fontWeight: FontWeight.w700,
                                                                            height: 2),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                        'Order Date : ',
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'Nunito Sans',
                                                                            fontSize:
                                                                                15,
                                                                            color: Colors
                                                                                .white70,
                                                                            fontWeight:
                                                                                FontWeight
                                                                                    .w700,
                                                                            height:
                                                                                1.5),
                                                                      ),
                                                                      Text(
                                                                        orders[index]
                                                                            .orderDate.split('T')[0],
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'Nunito Sans',
                                                                            fontSize:
                                                                                15,
                                                                            color: Colors
                                                                                .white70,
                                                                            fontWeight:
                                                                                FontWeight
                                                                                    .w700,
                                                                            height:
                                                                                1.5),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                        'Status : ',
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'Nunito Sans',
                                                                            fontSize:
                                                                                15,
                                                                            color: Colors
                                                                                .white70,
                                                                            fontWeight:
                                                                                FontWeight
                                                                                    .w700,
                                                                            height:
                                                                                1.5),
                                                                      ),
                                                                      Text(
                                                                        (orders[index].status) == 'Referred' 
                                                                        ? 'Pending'
                                                                        : orders[index].status,
                                                                        style: TextStyle(
                                                                            fontFamily: 'Nunito Sans',
                                                                            fontSize: 15,
                                                                            fontWeight: FontWeight.w700,
                                                                            height: 1.5,
                                                                            shadows: <Shadow>[
                                                                              Shadow(
                                                                                offset:
                                                                                    Offset(0.0, 0.0),
                                                                                blurRadius:
                                                                                    2.0,
                                                                                // color: (violationsList[index].status == 'Submitted') ? (Colors.black)  : (Colors.lightBlue[50])!,
                                                                              )
                                                                            ],
                                                                            color: (orders[index].status == 'Approved')
                                                                                ? Colors.yellow
                                                                                : (orders[index].status == 'Declined')
                                                                                ? Colors.red
                                                                                : (orders[index].status == 'Placed')
                                                                                ? Colors.orange
                                                                                : (orders[index].status == 'Delivered') 
                                                                                ?  Colors.green
                                                                                : Colors.lightGreen[300]
                                                                                ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                        'Item Name : ',
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'Nunito Sans',
                                                                            fontSize:
                                                                                15,
                                                                            color: Colors
                                                                                .white70,
                                                                            fontWeight:
                                                                                FontWeight
                                                                                    .w700,
                                                                            height:
                                                                                1.5),
                                                                      ),
                                                                      Text(
                                                                        orders[index]
                                                                            .item,
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'Nunito Sans',
                                                                            fontSize:
                                                                                15,
                                                                            color: Colors
                                                                                .white70,
                                                                            fontWeight:
                                                                                FontWeight
                                                                                    .w700,
                                                                            height:
                                                                                1.5),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                        'Total Amount : ',
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'Nunito Sans',
                                                                            fontSize:
                                                                                15,
                                                                            color: Colors
                                                                                .white70,
                                                                            fontWeight:
                                                                                FontWeight
                                                                                    .w700,
                                                                            height:
                                                                                1.5),
                                                                      ),
                                                                      Text(
                                                                        orders[index]
                                                                            .amount
                                                                            .toString(),
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'Nunito Sans',
                                                                            fontSize:
                                                                                15,
                                                                            color: Colors
                                                                                .white70,
                                                                            fontWeight:
                                                                                FontWeight
                                                                                    .w700,
                                                                            height:
                                                                                1.5),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              )),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                )));
                                      }),
                                )
                              ],
                            );
                        }
                      })
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
