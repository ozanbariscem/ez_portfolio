import 'package:nanas_coins/models/Language.dart';
import 'package:nanas_coins/models/Portfolio.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_candlesticks/flutter_candlesticks.dart';
import 'package:nanas_coins/widget/trade_history_card.dart';

import '../models/Asset.dart';
import '../models/BuildUtils.dart';

import '../widget/asset_summary_card.dart';
import '../widget/holdings_card.dart';

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

  int getKLineDays = 180;

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
    widget.asset.getKlines(getKLineDays).then((value) {
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
    widget.asset.getKlines(getKLineDays).then((value) {
      if (!mounted) {
        return;
      }
      gotKline = true;
      setState(() {});
    });
  }

  Widget buildSummaryCard(Asset asset) {
    if (gotData == true || widget.asset.marketCap != null) {
      return AssetSummaryCard(asset: asset);
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AutoSizeText('Graph',
                      style: BuildUtils.headerTextStyle(
                        context, 0.024, FontWeight.bold
                      ),
                      maxLines: 1,
                    ),
                    AutoSizeText(
                      '${Language.language.map["LAST"]} $getKLineDays ${Language.language.map["DAY"]}',
                      style: BuildUtils.headerTextStyle(
                        context, 0.012, FontWeight.normal
                      ),
                      maxLines: 1,
                    ),
                  ],
                ),
                BuildUtils.buildEmptySpaceHeight(context, 0.01),
                Container(
                  height: MediaQuery.of(context).size.height * .22,
                  child: OHLCVGraph(
                    data: widget.asset.kline,
                    enableGridLines: true,
                    enableVolume: false,
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
            HoldingsCard(asset: widget.asset),
            BuildUtils.buildEmptySpaceHeight(context),
            TradeHistoryCard(
              asset: widget.asset,
              onNewTrade: () { setState(() {}); },
              onTradeDelete: () { setState(() {}); },
            ),
          ],
        ),
      ))
    );
  }
}
