import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../models/Asset.dart';
import '../models/Language.dart';
import '../models/BuildUtils.dart';

class HoldingsCard extends StatefulWidget {
  final Asset asset;
  HoldingsCard({Key key, @required this.asset}) : super(key: key);

  @override
  _HoldingsCard createState() => _HoldingsCard();
}

class _HoldingsCard extends State<HoldingsCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .98,
      decoration: BuildUtils.buildBoxDecoration(context),
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height * .020),
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText(
                '${Language.language.map["YOUR_HOLDINGS"]}',
                style: BuildUtils.headerTextStyle(context, 0.024, FontWeight.bold),
                maxLines: 1,
              ),
              widget.asset.amount != null && widget.asset.amount != 0 ? 
              BuildUtils.buildEmptySpaceHeight(context, 0.01) : Divider(color: Colors.grey,),
              buildHoldings(context)
            ],
          )
        )
      )
    );
  }

  Widget buildHoldings(BuildContext context) {
    var children = [buildNoHoldingsNotice(context)];
    if (widget.asset.amount != null && widget.asset.amount != 0) {
      children = [
        totalValue(),
        buildAmount(),
        buildAvgPrice(),
        buildPNL()
      ];
    }
    return Row(
      children: children
    );
  }

  Widget totalValue() {
    return Expanded(
        flex: 3,
        child: Container(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    '${Language.language.map["TOTAL_IN_DOLLARS"]}',
                    style: BuildUtils.headerTextStyle(context, 0.02, FontWeight.bold),
                    maxLines: 1,
                  ),
                  Divider(color: Colors.grey),
                  AutoSizeText(
                    '${Asset.valueToText(widget.asset.amount * widget.asset.price)}',
                    style: BuildUtils.headerTextStyle(context, 0.02),
                    maxLines: 1,
                  ),
                ]
            )
        )
    );
  }

  Widget buildAmount() {
    return Expanded(
        flex: 3,
        child: Container(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    '${Language.language.map["AMOUNT"]}',
                    style: BuildUtils.headerTextStyle(context, 0.02, FontWeight.bold),
                    maxLines: 1,
                  ),
                  Divider(color: Colors.grey),
                  AutoSizeText(
                    '${Asset.valueToText(widget.asset.amount)} ${widget.asset.symbol.toUpperCase()}',
                    style: BuildUtils.headerTextStyle(context, 0.02),
                    maxLines: 1,
                  ),
                ]
            )
        )
    );
  }

  Widget buildAvgPrice() {
    return Expanded(
        flex: 3,
        child: Container(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AutoSizeText(
                    '${Language.language.map["AVG_PRICE"]}',
                    style: BuildUtils.headerTextStyle(context, 0.02, FontWeight.bold),
                    maxLines: 1,
                  ),
                  Divider(color: Colors.grey),
                  AutoSizeText(
                    '\$${widget.asset.purchasingPrice}',
                    style: BuildUtils.headerTextStyle(context, 0.02),
                    maxLines: 1,
                  ),
                ]
            )
        )
    );
  }

  Widget buildPNL() {
    return Expanded(
        flex: 3,
        child: Container(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AutoSizeText(
                    '${Language.language.map["PNL"]}',
                    style: BuildUtils.headerTextStyle(context, 0.02, FontWeight.bold),
                    maxLines: 1,
                  ),
                  Divider(color: Colors.grey,),
                  AutoSizeText(
                    '\$${Asset.valueToText(widget.asset.pnl)}',
                    style: BuildUtils.pnlTextStyle(context, widget.asset.pnl > 0, 0.02, FontWeight.normal),
                    maxLines: 1,
                  ),
                ]
            )
        )
    );
  }

  Widget buildNoHoldingsNotice(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        child: AutoSizeText(
          '${Language.language.map["NO_HOLDINGS"]}',
          style: BuildUtils.headerTextStyle(context, 0.02),
          maxLines: 1,
        ),
      ),
    );
  }
}