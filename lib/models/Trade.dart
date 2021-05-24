import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:nanas_coins/models/Portfolio.dart';
import 'package:path_provider/path_provider.dart';

class Trade {
  String id;

  double amount;
  double price;

  Trade({this.id, this.amount, this.price});

  Map<String, dynamic> toJson() =>
      {
        'amount': amount,
        'price': price
      };

  static Future<String> localPath() async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  static Future<File> getSaveFile() async {
    String directory = await localPath();
    File file = File('$directory/trades.txt');
    if (!(await file.exists())) {
      file.create();
    }
    return file;
  }

  static Future<Map<String, List<Trade>>> getTradesFromFile() async {
    File file = await getSaveFile();
    String content = await file.readAsString();
    if (content.length == 0) {
      return {};
    }

    Map<String, dynamic> json = jsonDecode(content); // TODO: There must be a better way
    Map<String, List<Trade>> trades = {};

    json.forEach((key, value) {
      trades[key] = [];
      value.forEach((element) {
        Trade trade = Trade(
            id: key,
            amount: element['amount'],
            price: element['price']
        );
        trades[key].add(trade);
      });
    });

    return trades;
  }

  static Future<void> writeTradesToFile(Portfolio portfolio) async {
    File file = await getSaveFile();

    String json = jsonEncode(portfolio.trades);

    return file.writeAsString(json);
  }
}