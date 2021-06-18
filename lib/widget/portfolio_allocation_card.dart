import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:pie_chart/pie_chart.dart';

import '../models/Portfolio.dart';
import '../models/Language.dart';
import '../models/BuildUtils.dart';

class PortfolioAllocationCard extends StatefulWidget {
  final Portfolio portfolio;
  PortfolioAllocationCard({
    Key key,
    @required this.portfolio
  }) : super(key: key);

  @override
  _PortfolioAllocationCard createState() => _PortfolioAllocationCard();
}

class _PortfolioAllocationCard extends State<PortfolioAllocationCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .98,
      decoration: BuildUtils.buildBoxDecoration(context),
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height * .01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoSizeText(
              '${Language.language.map["ALLOCATION"]}',
              style: BuildUtils.headerTextStyle(context, 0.024, FontWeight.bold),
              maxLines: 1,
            ),
            Divider(color: Colors.grey),
            BuildUtils.buildEmptySpaceHeight(context),
            PieChart(
              dataMap: widget.portfolio.allocation,
              chartRadius: MediaQuery.of(context).size.height * .2,
              chartType: ChartType.disc,
              chartValuesOptions: ChartValuesOptions(
                showChartValues: false
              ),
              legendOptions: LegendOptions(
                legendTextStyle: BuildUtils.headerTextStyle(context),
              ),
            )
          ]
        ),
      ),
    );
  }
}