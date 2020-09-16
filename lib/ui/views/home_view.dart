import 'dart:async';

import 'package:dart_amqp/dart_amqp.dart';
import 'package:flutter/material.dart';
import 'package:soil_masture_app/services/rmq_service.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  RMQService _rmqService = new RMQService();
  String payload = "";
  String soil_serial = "";
  String soil_value = "";
  String soil_status = "";

  String pompa_serial = "";
  String pompa_value = "";
  final String userQueue = "testdummy";
  final String passQueue = "testdummy123";
  final String VhostQueue = "/testdummy";
  final String hostQueue = "rmq2.pptik.id";
  void data() {
    ConnectionSettings settings = new ConnectionSettings(
      host: hostQueue,
      authProvider: new PlainAuthenticator(userQueue, passQueue),
      virtualHost: VhostQueue,
    );
    Client client = new Client(settings: settings);
    client
        .channel()
        .then((Channel channel) => channel.queue("Log", durable: true))
        .then((Queue queue) => queue.consume())
        .then((Consumer consumer) => consumer.listen((AmqpMessage message) {
              print("test ${message.payloadAsString}");
              setValueSoil(message.payloadAsString);
              setState(() {
                payload = message.payloadAsString;
              });
            }));
  }

  void data_pompa() {
    ConnectionSettings settings = new ConnectionSettings(
      host: hostQueue,
      authProvider: new PlainAuthenticator(userQueue, passQueue),
      virtualHost: VhostQueue,
    );
    Client client = new Client(settings: settings);
    client
        .channel()
        .then((Channel channel) => channel.queue("Sensor", durable: true))
        .then((Queue queue) => queue.consume())
        .then((Consumer consumer) => consumer.listen((AmqpMessage message) {
              print("test ${message.payloadAsString}");
              setValuePompa(message.payloadAsString);
            }));
  }

  void setValuePompa(String message) {
    List<String> list = message.split("#");
    int cek_value = int.parse(list[1]);
    setState(() {
      pompa_serial = list[0];
      if (cek_value == 1) {
        pompa_value = 'ON';
      } else if (cek_value == 0) {
        pompa_value = 'OFF';
      }
    });
  }

  void setValueSoil(String message) {
    List<String> a = message.split("#");
    int cek = int.parse(a[1]);
    setState(() {
      soil_value = a[1];
      soil_serial = a[0];
      if (cek < 350) {
        soil_status = 'lembab';
      } else if (cek > 700) {
        soil_status = 'Kering';
      } else if (cek >= 350 && cek <= 700) {
        soil_status = 'Normal';
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    data();
    data_pompa();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Soil Moisture",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'MuliFont',
                fontSize: 30),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "Serial Device",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'MuliFont',
                fontSize: 20),
          ),
          Text(
            "$soil_serial",
            style: TextStyle(fontFamily: 'MuliFont', fontSize: 18),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "Value",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'MuliFont',
                fontSize: 20),
          ),
          Text(
            "$soil_value",
            style: TextStyle(fontFamily: 'MuliFont', fontSize: 18),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "Status",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'MuliFont',
                fontSize: 20),
          ),
          Text(
            "$soil_status",
            style: TextStyle(fontFamily: 'MuliFont', fontSize: 18),
          ),
          SizedBox(
            height: 40,
          ),
          Text(
            "Pompa",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'MuliFont',
                fontSize: 30),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "Serial Device",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'MuliFont',
                fontSize: 20),
          ),
          Text(
            "$pompa_serial",
            style: TextStyle(fontFamily: 'MuliFont', fontSize: 18),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "Status",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'MuliFont',
                fontSize: 20),
          ),
          Text(
            "$pompa_value",
            style: TextStyle(fontFamily: 'MuliFont', fontSize: 18),
          ),
        ],
      ),
    )));
    // TODO: implement build
    throw UnimplementedError();
  }
}
