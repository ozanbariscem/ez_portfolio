import 'dart:async';

import 'Asset.dart';
import 'Trade.dart';
import 'Language.dart';

class Portfolio {
  static Portfolio portfolio;

  Map<String, Asset> assets;
  Map<String, List<Trade>> trades;

  double get pnl {
    if (assets == null) {
      print("W: calling PNL before assets are set.");
      return 0;
    } else {
      double sum = 0;
      assets.forEach((key, asset) {
        sum += asset.pnl;
      });
      return sum;
    }
  }

  double get dailyPnl {
    if (assets == null) {
      print("W: calling dailyPNL before assets are set.");
      return 0;
    } else {
      double sum = 0;
      assets.forEach((key, asset) {
        sum += asset.dailyPnl;
      });
      return sum;
    }
  }

  double get networth {
    if (assets == null) {
      print("W: calling networth before assets are set.");
      return 0;
    } else {
      double sum = 0;
      assets.forEach((key, asset) {
        sum += asset.value;
      });
      return sum;
    }
  }

  Map<String, double> get allocation {
    if (assets == null) {
      print("W: calling allocation before assets are set.");
      return null;
    } else {
      Map<String, double> map = new Map<String, double>();
      double nw = networth;
      int i = 0;
      assets.forEach((key, asset) {
        if (i < 4) {
          map[asset.name] = asset.value / nw;
        } else {
          if (map[Language.language.map["OTHER"]] == null)
            map[Language.language.map["OTHER"]] = 0.0;
          map[Language.language.map["OTHER"]] += asset.value / nw;
        }
        i++;
      });
      return map;
    }
  }

  Portfolio() {
    portfolio = this;
    assets = {};
    trades = {};
  }

  void setAssetsFromTrades() {
    trades.forEach((key, value) {
      setAssetFromTrades(key);
    });
  }

  void setAssetFromTrades(String id) {
    if (!trades.containsKey(id))
      return;
    if (portfolio.assets[id] != null) {
      print('Portfolio already has reference to this asset. Skipping..');
      return;
    }

    // TODO: Optimize this by using Maps in assetList
    // Turns out using maps is the same as using singleWhere
    Asset asset = Asset.assetList.singleWhere((element) => element["id"] == id);
    portfolio.assets[id] = asset;
  }

  Future<bool> getPortfolio() async {
    Map<String, List<Trade>> trades = await Trade.getTradesFromFile();
    Map<String, Asset> assets = {};

    trades.forEach((key, value) {
      if (!assets.containsKey(key)) {
        Asset asset = Asset(
          id: key
        );
        assets[key] = asset;
      }
      assets[key].trades = value;
    });

    assets.removeWhere((key, value) => value.amount == 0);
    this.assets = assets;
    this.trades = trades;
    return true;
  }

  Future<bool> getAssetData() async {
    List keys = assets.keys.toList();
    for (int i = 0; i < keys.length; i++) {
      await assets[keys[i]].getData();
    }
    sortAssetsByValue();
    return true;
  }

  void sortAssetsByValue([bool descending=true]) {
    // TODO: Optimize
    var sortedEntries = assets.entries.toList()..sort((e1, e2) {
      var diff = e2.value.value.compareTo(e1.value.value);
      if (diff == 0) diff = e2.key.compareTo(e1.key);
      return diff;
    });

    this.assets = {};
    sortedEntries.forEach((element) {
      this.assets[element.key] = element.value;
    });
  }
}
