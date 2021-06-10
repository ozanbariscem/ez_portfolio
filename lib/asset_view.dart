import 'package:nanas_coins/models/Portfolio.dart';
import 'package:flutter/cupertino.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_candlesticks/flutter_candlesticks.dart';

import 'models/Asset.dart';
import 'models/BuildUtils.dart';
import 'models/Trade.dart';

class AssetView extends StatefulWidget {
  final Asset asset;

  AssetView({Key key, @required this.asset}) : super(key: key);

  @override
  _AssetView createState() => _AssetView();
}

class _AssetView extends State<AssetView> {
  TextEditingController _priceEditController;
  TextEditingController _amountEditController;
  FocusNode _amountEditFocus;

  bool gotData;
  bool gotKline;

  bool enterTrade;

  @override
  void initState() {
    super.initState();
    _priceEditController = new TextEditingController(text: '');
    _amountEditController = new TextEditingController(text: '');
    _amountEditFocus = FocusNode();

    gotData = false;
    gotKline = false;
    enterTrade = false;

    if (Portfolio.portfolio.trades.containsKey(widget.asset.id))
      widget.asset.trades = Portfolio.portfolio.trades[widget.asset.id];

    widget.asset.getData().then((value) {
      if (!mounted) {
        return;
      }
      gotData = true;
      setState(() {});
    });
    widget.asset.getKlines('1d', 30).then((value) {
      if (!mounted) {
        return;
      }
      gotKline = true;
      setState(() {});
    });
  }

  Future<void> _refresh() async {
    gotData = false;
    gotKline = false;

    widget.asset.getData().then((value) {
      if (!mounted) {
        return;
      }
      gotData = true;
      setState(() {});
    });
    widget.asset.getKlines('1d', 30).then((value) {
      if (!mounted) {
        return;
      }
      gotKline = true;
      setState(() {});
    });
  }

  void newTrade(asset, [isBuy = true]) {
    var amount = double.tryParse(_amountEditController.text);
    var price = double.tryParse(_priceEditController.text);
    if (amount != null && price != null &&
        amount > 0 && price > 0) {
      if (!isBuy) {
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
  }

  Widget buildSummaryCard(Asset asset) {
    if (gotData == true || widget.asset.marketCap != null) {
      return Container(
          //height: MediaQuery.of(context).size.height * .18,
          width: MediaQuery.of(context).size.width * .98,
          decoration: BuildUtils.buildBoxDecoration(context),
          child: Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.height * .015),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.network(asset.image,
                              width: MediaQuery.of(context).size.height * .035),
                          BuildUtils.buildEmptySpaceWidth(context, .01),
                          Text(
                            asset.name,
                            style: BuildUtils.headerTextStyle(
                                context, 0.03, FontWeight.bold),
                          )
                        ],
                      ),
                      Text('Rank #${asset.marketCapRank}',
                          style: BuildUtils.headerTextStyle(context, 0.015)),
                      BuildUtils.buildEmptySpaceHeight(context, 0.04),
                      InkWell(
                        child: Text(
                          asset.page
                              .replaceAll('https://', '')
                              .replaceAll('/', ''),
                          style: BuildUtils.linkTextStyle(
                            context: context,
                          ),
                        ),
                        onTap: () => launch(asset.page),
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            EvaIcons.twitter,
                            color: Colors.lightBlue,
                          ),
                          InkWell(
                            child: Text(
                              'Twitter',
                              style: BuildUtils.linkTextStyle(
                                context: context,
                              ),
                            ),
                            onTap: () => launch(
                                'https://www.twitter.com/${asset.twitter}'),
                          ),
                        ],
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            '\$${asset.price}',
                            style: BuildUtils.headerTextStyle(
                                context, 0.035, FontWeight.bold),
                          ),
                          BuildUtils.buildEmptySpaceWidth(context, 0.02),
                          Text(
                            '${Asset.valueToText(asset.priceChangePercent)}%',
                            style: BuildUtils.pnlTextStyle(
                                context, asset.priceChangePercent > 0, 0.02),
                          )
                        ],
                      ),
                      BuildUtils.buildEmptySpaceHeight(context, 0.01),
                      Text('Market Cap',
                          style: BuildUtils.headerTextStyle(
                              context, 0.018, FontWeight.bold)),
                      Text('\$${asset.marketCap}',
                          style: BuildUtils.headerTextStyle(context, 0.018)),
                      BuildUtils.buildEmptySpaceHeight(context, 0.01),
                      Text('Circulating Supply',
                          style: BuildUtils.headerTextStyle(
                              context, 0.018, FontWeight.bold)),
                      Text(
                          '${asset.circulatingSupply.toInt()} / ${asset.maxSupply == null ? '∞' : asset.maxSupply.toInt()}',
                          style: BuildUtils.headerTextStyle(context, 0.018)),
                    ],
                  )
                ],
              )));
    }
    else {
      return Container(
        decoration: BuildUtils.buildBoxDecoration(context),
        child: Column(
          children: [
            BuildUtils.buildEmptySpaceHeight(context, 0.06),
            CircularProgressIndicator(),
            BuildUtils.buildEmptySpaceHeight(context, 0.06),
          ],
        ),
      );
    }
  }

  Widget buildHoldingsCard(Asset asset) {
    return Container(
        //height: MediaQuery.of(context).size.height * .2,
        width: MediaQuery.of(context).size.width * .98,
        decoration: BuildUtils.buildBoxDecoration(context),
        child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.height * .020),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Your Holdings',
                    style: BuildUtils.headerTextStyle(
                        context, 0.024, FontWeight.bold)),
                BuildUtils.buildEmptySpaceHeight(context, 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Total Amount',
                        style: BuildUtils.headerTextStyle(
                            context, 0.02, FontWeight.bold)),
                    Text('Avg. Price',
                        style: BuildUtils.headerTextStyle(
                            context, 0.02, FontWeight.bold)),
                    Text('PNL',
                        style: BuildUtils.headerTextStyle(
                            context, 0.02, FontWeight.bold)),
                  ],
                ),
                Divider(color: Colors.grey),
                asset.amount != null && asset.amount > 0
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                              '${Asset.valueToText(asset.amount)} ${asset.symbol.toUpperCase()}',
                              style: BuildUtils.headerTextStyle(context, 0.02)),
                          Text('\$${Asset.valueToText(asset.purchasingPrice)}',
                              style: BuildUtils.headerTextStyle(context, 0.02)),
                          Text('\$${Asset.valueToText(asset.pnl)}',
                              style: BuildUtils.pnlTextStyle(context,
                                  asset.pnl > 0, 0.02, FontWeight.normal)),
                        ],
                      )
                    : Text('You don\'t have any ${asset.name}.',
                        style: BuildUtils.headerTextStyle(context, 0.02))
              ],
            )));
  }

  Widget buildTradeCard(Asset asset) {
    return Container(
        width: MediaQuery.of(context).size.width * .98,
        decoration: BuildUtils.buildBoxDecoration(context),
        child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.height * .015),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Trade History',
                          style: BuildUtils.headerTextStyle(
                              context, 0.024, FontWeight.bold)),
                      IconButton(
                        icon: Icon(EvaIcons.plus),
                        onPressed: () {
                          setState(() {
                            _priceEditController.text = widget.asset.price.toString();
                            _amountEditFocus.requestFocus();
                            enterTrade = !enterTrade;
                          });
                        }, )]
                  ),
                  BuildUtils.buildEmptySpaceHeight(context, 0.01),
                  enterTrade ? buildNewTrade(asset) : BuildUtils.buildEmptySpaceHeight(context, 0.00),
                  Divider(color: Colors.grey),
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: widget.asset.trades.length,
                    itemBuilder: (context, i) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                  widget.asset.trades[i].amount.abs().toString() + ' ' +
                                      widget.asset.symbol.toUpperCase(),
                                  style: BuildUtils.headerTextStyle(
                                      context, 0.02, FontWeight.normal)),
                              Text(
                                  (widget.asset.trades[i].amount >= 0 ? ' bought at ' : ' sold at '),
                                  style: BuildUtils.pnlTextStyle(context, widget.asset.trades[i].amount >= 0, 0.02)),
                              Text(
                                  widget.asset.trades[i].price.toString(),
                                  style: BuildUtils.headerTextStyle(
                                      context, 0.02, FontWeight.normal)),
                            ],
                          ),
                          Divider(color: Colors.grey)
                        ],
                      );
                    },
                  )
                ])));
  }

  Widget buildNewTrade(Asset asset) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            width: MediaQuery.of(context).size.width * .30,
            height: MediaQuery.of(context).size.height * .05,
            child: TextField(
              obscureText: false,
              controller: _amountEditController,
              focusNode: _amountEditFocus,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Amount',
              ),
            )),
        Container(
            width: MediaQuery.of(context).size.width * .30,
            height: MediaQuery.of(context).size.height * .05,
            child: TextField(
              obscureText: false,
              controller: _priceEditController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Price',
              ),
            )),
        ElevatedButton(
            onPressed: () {
              newTrade(asset);
            },
            style: ElevatedButton.styleFrom(
              primary: BuildUtils.green,
            ),
            child: Text(
              'Buy',
              style: BuildUtils.elevatedButtonTextStyle(context: context),
            )),
        ElevatedButton(
            onPressed: () {
              newTrade(asset, false);
            },
            style: ElevatedButton.styleFrom(
              primary: BuildUtils.red,
            ),
            child: Text(
              'Sell',
              style: BuildUtils.elevatedButtonTextStyle(context: context),
            ))
      ],
    );
  }

  Widget buildGraphCard(Asset asset) {
    if (gotKline == true || widget.asset.kline != null) {
      return Container(
          height: MediaQuery.of(context).size.height * .3,
          width: MediaQuery.of(context).size.width * .98,
          decoration: BuildUtils.buildBoxDecoration(context),
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.height * .015),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Graph',
                    style: BuildUtils.headerTextStyle(
                        context, 0.024, FontWeight.bold)),
                BuildUtils.buildEmptySpaceHeight(context, 0.01),
                Container(
                  height: MediaQuery.of(context).size.height * .22,
                  child: OHLCVGraph(
                    data: widget.asset.kline,
                    enableGridLines: true,
                    volumeProp: 0,
                    increaseColor: Colors.lightGreen.shade800,
                    decreaseColor: Colors.red.shade800,
                  ),
                )
              ],
            ),
          ));
    }
    else {
      return Container(
        decoration: BuildUtils.buildBoxDecoration(context),
        child: Column(
          children: [
            BuildUtils.buildEmptySpaceHeight(context, 0.1),
            CircularProgressIndicator(),
            BuildUtils.buildEmptySpaceHeight(context, 0.1),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('${widget.asset.name}')),
        backgroundColor: BuildUtils.backgroundColor,
        body: Center(
            child: RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            children: [
              BuildUtils.buildEmptySpaceHeight(context),
              buildSummaryCard(widget.asset),
              BuildUtils.buildEmptySpaceHeight(context),
              buildGraphCard(widget.asset),
              BuildUtils.buildEmptySpaceHeight(context),
              buildHoldingsCard(widget.asset),
              BuildUtils.buildEmptySpaceHeight(context),
              buildTradeCard(widget.asset),
            ],
          ),
        )));
  }
}
