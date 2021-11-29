import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Bridge with ChangeNotifier {
  Bridge();

  void startWs({required Function onIid}) async {
    const port = 1234;
    log("Starting bridge on port: " + port.toString());

    /// Create the WebSocket channel
    final channel = WebSocketChannel.connect(
      Uri.parse('ws://localhost:' + port.toString()),
    );
/*
    channel.sink.add(
      jsonEncode(
        {
          "type": "subscribe",
          "channels": [
            {
              "name": "ticker",
              "product_ids": [
                "BTC-EUR",
              ]
            }
          ]
        },
      ),
    );
    */

    //channel.sink.close(status.goingAway);

    /// Listen for all incoming data
    channel.stream.listen(
      (data) {
        onIid(data);
      },
      onError: (error) => log(error.toString()),
    );
  }
}
