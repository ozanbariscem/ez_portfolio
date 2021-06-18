import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/Asset.dart';
import '../models/Trade.dart';
import '../models/Language.dart';
import '../models/Portfolio.dart';
import '../models/BuildUtils.dart';

class NewTradeCard extends StatefulWidget {
  final Asset asset;
  final TextEditingController priceEditController;
  final TextEditingController amountEditController;
  final FocusNode amountEditFocus;
  final Function() onNewTrade;

  NewTradeCard({
    Key key,
    @required this.asset,
    @required this.priceEditController,
    @required this.amountEditController,
    @required this.onNewTrade,
    @required this.amountEditFocus
  }) : super(key: key);

  @override
  _NewTradeCard createState() => _NewTradeCard();
}

class _NewTradeCard extends State<NewTradeCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            width: MediaQuery.of(context).size.width * .30,
            height: MediaQuery.of(context).size.height * .05,
            child: TextField(
              obscureText: false,
              controller: widget.amountEditController,
              focusNode: widget.amountEditFocus,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '${Language.language.map["AMOUNT"]}',
              ),
            )),
        Container(
            width: MediaQuery.of(context).size.width * .30,
            height: MediaQuery.of(context).size.height * .05,
            child: TextField(
              obscureText: false,
              controller: widget.priceEditController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '${Language.language.map["PRICE"]}',
              ),
            )),
        ElevatedButton(
            onPressed: () {
              setState(() {
                newTrade(widget.asset);
              });
            },
            style: ElevatedButton.styleFrom(
              primary: BuildUtils.green,
            ),
            child: Text(
              '${Language.language.map["BUY"]}',
              style: BuildUtils.elevatedButtonTextStyle(context: context),
            )),
        ElevatedButton(
            onPressed: () {
              setState(() {
                newTrade(widget.asset, false);
              });
            },
            style: ElevatedButton.styleFrom(
              primary: BuildUtils.red,
            ),
            child: Text(
              '${Language.language.map["SELL"]}',
              style: BuildUtils.elevatedButtonTextStyle(context: context),
            ))
      ],
    );
  }

  void newTrade(asset, [isBuying=true]) {
    var amount = double.tryParse(widget.amountEditController.text);
    var price = double.tryParse(widget.priceEditController.text);
    if (amount != null && price != null &&
        amount > 0 && price > 0) {
      if (!isBuying) {
        amount = -amount;
      }
      Trade trade = Trade(
        id: asset.id,
        amount: amount,
        price: price,
      );

      if (!Portfolio.portfolio.trades.containsKey(asset.id)) {
        print('Added to trades of assets');
        Portfolio.portfolio.trades[asset.id] = [];
        asset.trades = Portfolio.portfolio.trades[asset.id];
      }
      Portfolio.portfolio.trades[asset.id].add(trade);
      Portfolio.portfolio.setAssetFromTrades(asset.id);

      Trade.writeTradesToFile(Portfolio.portfolio);
    } else {
      print('Raise input was invalid!');
    }
    widget.onNewTrade?.call();
  }
}