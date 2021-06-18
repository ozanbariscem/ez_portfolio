import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import "package:intl/intl.dart";
import 'package:http/http.dart' as http;
import 'Kline.dart';
import 'Language.dart';

// TODO: Make it work with even negative amounts
// so lets say if the user has sold 1 bitcoin, so if price decreases show profit
// Widgets already support this but don't forget to make sure
class Asset {
  String id;
  String symbol;
  String name;
  String image;

  String page;
  String twitter;

  String description;

  int marketCapRank;
  double price;
  int marketCap;
  double priceChangePercent;

  double totalSupply;
  double maxSupply;
  double circulatingSupply;

  List kline;
  List trades;

  // USERS DATA
  double get purchasingPrice {
    double sum = 0;
    double weightSum = 0;
    trades.forEach((element) {
      sum += element.amount;
      weightSum += (element.amount * element.price);
    });
    return weightSum / sum;
  }

  double get amount {
    double _amount = 0;
    trades.forEach((element) {
      _amount += element.amount;
    });
    return _amount > 0 ? _amount : 0;
  }

  double get pnl {
    return amount * (price - purchasingPrice);
  }

  double get dailyPnl {
    return amount * (price - (price / (1 + priceChangePercent / 100)));
  }

  double get value {
    return amount * price;
  }

  Asset({
    @required this.id,
    @required this.symbol,
    @required this.name,
    @required this.image,

    @required this.page,
    @required this.twitter,

    @required this.description,

    @required this.marketCapRank,
    @required this.price,
    @required this.marketCap,
    @required this.priceChangePercent,

    @required this.totalSupply,
    @required this.maxSupply,
    @required this.circulatingSupply,
  }) {
    trades = [];
  }

  static List<Asset> assetList;

  static Future<bool> getCoinsList(int limit) async {
    List<Asset> assets = [];
    int page = 1;
    int perPage = 250;

    for (int i = 0; i < limit; i+=perPage) {
      List<Asset> _assets = await getCoinsPage(perPage, page);
      assets.addAll(_assets);
      page++;
    }

    assetList = assets;
    return true;
  }

  static Future<List<Asset>> getCoinsPage(int perPage, int page) async {
    var url = Uri.https('api.coingecko.com', 'api/v3/coins/markets', {
      'vs_currency': 'usd',
      'order': 'market_cap_desc',
      'per_page': perPage.toString(),
      'page': page.toString(),
      'sparkline': false.toString()
    });

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> json = jsonDecode(response.body);
      List<Asset> assets = [];

      for (int i = 0; i < json.length; i++) {
        Asset asset = Asset();
        asset.id = json[i]['id'];
        asset.symbol = json[i]['symbol'];
        asset.name = json[i]['name'];
        asset.price = double.parse(json[i]['current_price'].toString());
        asset.marketCapRank = json[i]['market_cap_rank'];
        asset.priceChangePercent = json[i]['price_change_percentage_24h'];
        assets.add(asset);
      }
      return assets;
    } else {
      throw Exception('Failed to get asset klines. ${response.statusCode} on ${url}');
    }
  }

  Future<bool> getData() async {
    final response = await http.get(Uri.https('api.coingecko.com', 'api/v3/coins/$id'));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);

      this.symbol = json['symbol'];
      this.name = json['name'];
      this.image = json['image']['large'];

      this.page = json['links']['homepage'][0];
      this.twitter = json['links']['twitter_screen_name'];

      if (json['description'][Language.language.map["ID"]] != null)
        this.description = json['description'][Language.language.map["ID"]];
      else
        this.description = json['description'][Language.language.map["en"]];

      this.marketCapRank = json['market_cap_rank'];
      this.price = double.parse(json['market_data']['current_price']['usd'].toString());
      this.marketCap = json['market_data']['market_cap']['usd'];
      this.priceChangePercent = json['market_data']['price_change_percentage_24h'];

      this.totalSupply = json['market_data']['total_supply'];
      this.maxSupply = json['market_data']['max_supply'];
      this.circulatingSupply = json['market_data']['circulating_supply'];

      return true;
    } else {
      throw Exception('Failed to get asset data.');
    }
  }

  Future<bool> getKlines(String days) async {
    var url = Uri.https('api.coingecko.com', 'api/v3/coins/$id/ohlc', {
      'vs_currency': 'usd',
      'days': '$days'
    });

    final response = await http.get(url);

    if (response.statusCode == 200) {
      kline = Kline.createFrom(jsonDecode(response.body));
      return true;
    } else {
      throw Exception('Failed to get asset klines. ${response.statusCode} on ${url}');
    }
  }

  static String valueToText(double value) {
    return NumberFormat.compactCurrency(
      decimalDigits: 2,
      symbol: '',
    ).format(value);
  }
}
