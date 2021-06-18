import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../models/Asset.dart';
import '../models/Trade.dart';
import '../models/Language.dart';
import '../models/Portfolio.dart';
import '../models/BuildUtils.dart';
import '../widget/new_trade_card.dart';

class TradeHistoryCard extends StatefulWidget {
  final Asset asset;
  final Function onNewTrade;
  final Function onTradeDelete;

  TradeHistoryCard({
    Key key,
    @required this.asset,
    @required this.onNewTrade,
    @required this.onTradeDelete
  }) : super(key: key);

  @override
  _TradeHistoryCard createState() => _TradeHistoryCard();
}

class _TradeHistoryCard extends State<TradeHistoryCard> {
  TextEditingController _priceEditController;
  TextEditingController _amountEditController;
  FocusNode _amountEditFocus;

  bool enterTrade;

  @override
  void initState() {
    super.initState();
    _priceEditController = new TextEditingController(text: '');
    _amountEditController = new TextEditingController(text: '');
    _amountEditFocus = FocusNode();

    enterTrade = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .98,
      decoration: BuildUtils.buildBoxDecoration(context),
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height * .015),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTopBar(context),
            buildNewTrade(context),
            Divider(color: Colors.grey),
            widget.asset.trades.length > 0 ?
            buildTradeHistory(context) :
            buildNoTradeHistory(context)
          ],
        )
      )
    );
  }

  Widget buildTopBar(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 9,
          child: Container(
            child: AutoSizeText(
              '${Language.language.map["TRADE_HISTORY"]}',
              style: BuildUtils.headerTextStyle(context, 0.024, FontWeight.bold),
              maxLines: 1,
            )
          )
        ),
        Expanded(
          flex: 1,
          child: Container(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.032,
              child: IconButton(
                padding: new EdgeInsets.all(0.0),
                iconSize: MediaQuery.of(context).size.height * 0.032,
                icon: Icon(EvaIcons.plus),
                onPressed: () {
                  setState(() {
                    _priceEditController.text = widget.asset.price.toString();
                    _amountEditFocus.requestFocus();
                    enterTrade = !enterTrade;
                  });
                },
              )
            )
          )
        )
      ],
    );
  }

  Widget buildNewTrade(BuildContext context) {
    if (enterTrade) {
      return NewTradeCard(
        asset: widget.asset,
        priceEditController: _priceEditController,
        amountEditController: _amountEditController,
        amountEditFocus: _amountEditFocus,
        onNewTrade: () { setState(() { widget.onNewTrade?.call(); }); },
      );
    } else {
      // Since columns can't have null children
      return BuildUtils.buildEmptySpaceHeight(context, 0.00);
    }
  }

  Widget buildTradeHistory(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * .22
      ),
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: widget.asset.trades.length,
        itemBuilder: (context, i) {
          return Column(
            children: [
              Container(
                width: double.infinity,
                child: buildTradeCard(context, widget.asset.trades[i])
              ),
              BuildUtils.buildEmptySpaceHeight(context)
            ],
          );
        },
      )
    );
  }

  Widget buildNoTradeHistory(BuildContext context) {
    return Container(
      child: AutoSizeText(
        '${Language.language.map["NO_TRADE"]}',
        style: BuildUtils.headerTextStyle(context, 0.02),
        maxLines: 1,
      )
    );
  }

  Widget buildTradeCard(BuildContext context, Trade trade) {
    return Row(
      children: [
        Expanded(
          flex: 25,
          child: Container(
            child: AutoSizeText(
              trade.amount >= 0 ? '${Language.language.map["BOUGHT"]}' : '${Language.language.map["SOLD"]}',
              style: BuildUtils.pnlTextStyle(context, trade.amount >= 0, 0.02),
              maxLines: 1,
            )
          ),
        ),
        Expanded(
          flex: 25,
          child: Container(
            child: AutoSizeText(
              '${Asset.valueToText(trade.amount.abs())} ${widget.asset.symbol.toUpperCase()}',
              style: BuildUtils.headerTextStyle(context, 0.02, FontWeight.normal),
              textAlign: TextAlign.start,
              maxLines: 1,
            )
          ),
        ),
        Expanded(
          flex: 10,
          child: Container(
            child: AutoSizeText(
              '${Language.language.map["AT"]}',
              style: BuildUtils.pnlTextStyle(context, trade.amount >= 0, 0.02),
              textAlign: TextAlign.center,
              minFontSize: 5,
              maxLines: 1,
            )
          ),
        ),
        Expanded(
          flex: 25,
          child: Container(
            child: AutoSizeText(
              '\$${trade.price.toString()}',
              style: BuildUtils.headerTextStyle(context, 0.02, FontWeight.normal),
              textAlign: TextAlign.end,
              maxLines: 1,
            )
          ),
        ),
        Expanded(
          flex: 5,
          child: Container(
            child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.024,
                child: IconButton(
                  padding: new EdgeInsets.all(0.0),
                  iconSize: MediaQuery.of(context).size.height * 0.024,
                  icon: Icon(
                    CupertinoIcons.trash,
                    color: BuildUtils.red,
                  ),
                  onPressed: () {
                    setState(() {
                      deleteTrade(trade);
                      widget.onTradeDelete?.call();
                    });
                  },
                )
            )
          ),
        ),
      ],
    );
  }

  void deleteTrade(Trade trade) {
    widget.asset.trades.remove(trade);
    Trade.writeTradesToFile(Portfolio.portfolio);
  }
}