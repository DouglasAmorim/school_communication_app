import 'dart:math';
import 'package:dart_amqp/dart_amqp.dart';
import 'package:flutter/cupertino.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttTest {
  final MqttServerClient client;

  MqttTest(this.client);

  Future<String> connect() async {
    Client client2 = Client();

    ConnectionSettings settings = ConnectionSettings(
        host: "192.168.0.15",
        authProvider: PlainAuthenticator("admin", "D!o@4701298")
    );

    client2.settings.host = "192.168.0.15";
    client2.settings.authProvider = PlainAuthenticator("admin", "D!o@4701298");

    Channel channel = await client2.channel();
    Queue queue = await channel.queue("qwebapp");

    Consumer consumer = await queue.consume();
    consumer.listen((AmqpMessage message) {
      // Get the payload as a string
      print(" [x] Received string: ${message.payloadAsString}");

      // Or unserialize to json
      print(" [x] Received json: ${message.payloadAsJson}");

      // Or just get the raw data as a Uint8List
      print(" [x] Received raw: ${message.payload}");

      message.reply("world");
    });




    // print("Starting connect");
    //
    // client.keepAlivePeriod = 60;
    //
    // client.onConnected = onConnected;
    // client.onDisconnected = onDisconnected;
    // client.port = 5672;
    // client.pongCallback = pong;

    // try {
    //   await client.connect();
    //   client.subscribe('qwebapp', MqttQos.atLeastOnce);
    //
    //   client.updates.listen((mqttReceivedMessages) {
    //     mqttReceivedMessages.forEach((mqttMessage) {
    //       print(mqttMessage.payload.toString());
    //     });
    //   });
    //
    // } catch (e) {
    //   debugPrint("Exception on connect: $e");
    //   client.disconnect();
    // }



    return "Banana";
  }

  // void publish(String topic, String message) {
  //   final String pubTopic = topic;
  //   final builder = MqttClientPayloadBuilder();
  //   builder.addString(message);
  //   client.publishMessage(pubTopic, MqttQos.atLeastOnce, builder.payload);
  // }
  //
  // void subscribe(String topic) {
  //   client.subscribe(topic, MqttQos.atLeastOnce);
  // }
  //
  // void unsubscribe(String topic) {
  //   client.unsubscribe(topic);
  // }
  //
  // void disconnect() {
  //   client.disconnect();
  // }

  void onConnected() {
    debugPrint('Client Connection Was Successful');
  }

  void onUnsubscribed() {

  }

  void onSubscribed() {

  }

  void onDisconnected() {
    debugPrint('Client Disconnected');
  }

  void onSubscribeFail() {

  }

  void pong() {
    debugPrint('ping invoked');
  }
}