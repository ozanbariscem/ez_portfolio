import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../view/asset_view.dart';

import '../models/Portfolio.dart';
import '../models/Language.dart';
import '../models/Asset.dart';
import '../models/BuildUtils.dart';


class PortfolioTableCard extends StatefulWidget {
  final Portfolio portfolio;
  PortfolioTableCard({
    Key key,
    @required this.portfolio
  }) : super(key: key);

  @override
  _PortfolioTableCard createState() => _PortfolioTableCard();
}

class _PortfolioTableCard extends State<PortfolioTableCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * .98,
        decoration: BuildUtils.buildBoxDecoration(context),
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.height * .01),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AutoSizeText(
                '${Language.language.map["PORTFOLIO"]}',
                style: BuildUtils.headerTextStyle(context, 0.024, FontWeight.bold),
                maxLines: 1,
              ),
              BuildUtils.buildEmptySpaceHeight(context, 0.02),
              buildTable(
                context: context,
                data: widget.portfolio.assets.values.toList()
              )
            ],
          ),
        ));
  }

  Widget buildTable({
    BuildContext context,
    List data,
  }) {
    var rows = data.map((e) => buildTableRow(
        data: e,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AssetView(asset: e)));
        }
      )
    ).toList();

    return Column(
      children: [
        Row(
          children: [
            buildTableRowElement(
              flex: 10,
              text: '${Language.language.map["NAME"]}',
              style: BuildUtils.headerTextStyle(context, 0.02, FontWeight.bold),
              align: TextAlign.start,
            ),
            buildTableRowElement(
              flex: 20,
              text: '${Language.language.map["AMOUNT"]}',
              style: BuildUtils.headerTextStyle(context, 0.02, FontWeight.bold),
            ),
            buildTableRowElement(
              flex: 20,
              text: '${Language.language.map["PRICE"]}',
              style: BuildUtils.headerTextStyle(context, 0.02, FontWeight.bold),
            ),
            buildTableRowElement(
              flex: 15,
              text: '${Language.language.map["CHANGE"]}',
              style: BuildUtils.headerTextStyle(context, 0.02, FontWeight.bold),
            ),
            buildTableRowElement(
              flex: 15,
              text: '${Language.language.map["PNL"]}',
              style: BuildUtils.headerTextStyle(context, 0.02, FontWeight.bold),
              align: TextAlign.end,
            ),
          ],
        ),
        Divider(color: Colors.grey),
        Column(
          children: rows,
        )
      ],
    );
  }

  Widget buildTableRow({
    var data,
    Function onTap
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Row(
            children: [
              buildTableRowElement(
                flex: 10,
                text: '${data.name.length > 7 ? data.symbol.toUpperCase() : data.name}',
                style: BuildUtils.headerTextStyle(context, .02),
                align: TextAlign.start,
              ),
              buildTableRowElement(
                flex: 20,
                text: '${Asset.valueToText(data.amount)}',
                style: BuildUtils.headerTextStyle(context, .02),
              ),
              buildTableRowElement(
                flex: 20,
                text: '\$${data.price}',
                style: BuildUtils.headerTextStyle(context, .02),
              ),
              buildTableRowElement(
                flex: 15,
                text: '${Asset.valueToText(data.priceChangePercent)}%',
                style: BuildUtils.pnlTextStyle(
                    context,
                    data.priceChangePercent > 0,
                    0.02,
                    FontWeight.normal),
              ),
              buildTableRowElement(
                flex: 15,
                text: '\$${Asset.valueToText(data.pnl)}',
                style: BuildUtils.pnlTextStyle(context,
                    data.pnl > 0, 0.02, FontWeight.normal),
                align: TextAlign.end,
              ),
            ],
          ),
        ),
        Divider(color: Colors.grey)
      ]
    );
  }

  Widget buildTableRowElement(
  {
    int flex = 1,
    String text,
    TextStyle style,
    TextAlign align = TextAlign.center
  }) {
    return Expanded(
      flex: flex,
      child: AutoSizeText(
        text,
        style: style,
        textAlign: align,
        maxLines: 1,
      )
    );
  }
 }