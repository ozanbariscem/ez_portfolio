import 'dart:async';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pie_chart/pie_chart.dart';

import 'models/Asset.dart';
import 'models/Portfolio.dart';
import 'models/Language.dart';
import 'models/BuildUtils.dart';

import 'asset_view.dart';
import 'search_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: BuildUtils.barColor, //red, indigo, deepPurple, blueGrey
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Nana\'s Coins'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Language language;
  Portfolio portfolio;

  bool gotPortfolio;
  bool gotData;

  @override
  void initState() {
    super.initState();
    language = Language.changeLanguage(Language.TURKISH);
    gotPortfolio = false;
    gotData = false;

    portfolio = new Portfolio();
    portfolio.getPortfolio().then((value) {
      gotPortfolio = value;
      if (gotPortfolio) {
        print('Got portfolio');
        portfolio.getAssetData().then((value) {
          print('Got data');
          gotData = value;
          if (value)
            setState(() {});
        });
      }
    });
  }

  Future<void> _refresh() async {
    await portfolio.getAssetData();
    setState(() {});
  }

  Widget splashScreen(BuildContext context, String title) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/icon.png',
                  width: MediaQuery.of(context).size.height * .07,
                  height: MediaQuery.of(context).size.height * .07),
              BuildUtils.buildEmptySpaceWidth(context, 0.02),
              Text(
                title,
                style: BuildUtils.headerTextStyle(
                    context, 0.05, FontWeight.bold),)
            ],
          ),
          BuildUtils.buildEmptySpaceHeight(context, 0.02),
          CircularProgressIndicator()
        ],
      ),
    );
  }

  Widget buildSummaryCard() {
    return Container(
        height: MediaQuery.of(context).size.height * .12,
        width: MediaQuery.of(context).size.width * .98,
        decoration: BuildUtils.buildBoxDecoration(context),
        child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.height * .01),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '${language.map["NETWORTH"]}',
                        style: BuildUtils.headerTextStyle(context),
                      ),
                      Text('\$${Asset.valueToText(portfolio.networth)}',
                          style: BuildUtils.headerTextStyle(
                              context, 0.035, FontWeight.bold))
                    ]),
                BuildUtils.buildEmptySpaceWidth(context, 0.08),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('${language.map["DAILYPNL"]}',
                          style: BuildUtils.headerTextStyle(context)),
                      Text('\$${Asset.valueToText(portfolio.dailyPnl)}',
                          style: BuildUtils.pnlTextStyle(
                              context, portfolio.dailyPnl > 0))
                    ]),
                BuildUtils.buildEmptySpaceWidth(context, .01),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('${language.map["TOTALPNL"]}',
                          style: BuildUtils.headerTextStyle(context)),
                      Text('\$${Asset.valueToText(portfolio.pnl)}',
                          style: BuildUtils.pnlTextStyle(
                              context, portfolio.pnl > 0))
                    ])
              ],
            )));
  }

  Widget buildPortfolioAllocation() {
    return Container(
      width: MediaQuery.of(context).size.width * .98,
      decoration: BuildUtils.buildBoxDecoration(context),
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height * .02),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            '${language.map["ALLOCATION"]}',
            style: BuildUtils.headerTextStyle(context, 0.025),
          ),
          BuildUtils.buildEmptySpaceHeight(context),
          PieChart(
            dataMap: portfolio.allocation,
            chartType: ChartType.disc,
            chartValuesOptions: ChartValuesOptions(
              showChartValuesOutside: false,
            ),
            legendOptions: LegendOptions(
              legendTextStyle: BuildUtils.headerTextStyle(context),
            ),
          ),
        ]),
      ),
    );
  }

  // TODO: Custom table, this one is.. bad.
  Widget buildPortfolioTable() {
    return Container(
        width: MediaQuery.of(context).size.width * .98,
        decoration: BuildUtils.buildBoxDecoration(context),
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.height * .02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${language.map["PORTFOLIO"]}',
                style: BuildUtils.headerTextStyle(context, 0.025),
              ),
              BuildUtils.buildEmptySpaceHeight(context, 0.01),
              ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * .98,
                  ),
                  child: DataTable(
                      columnSpacing: MediaQuery.of(context).size.width * .016,
                      horizontalMargin: 0,
                      columns: <DataColumn>[
                        DataColumn(
                          label: Text(
                            "${language.map["NAME"]}",
                            style: BuildUtils.headerTextStyle(
                                context, 0.02, FontWeight.bold),
                          ),
                          onSort: (_, __) {
                            setState(() {});
                          },
                        ),
                        DataColumn(
                          label: Text(
                            "${language.map["AMOUNT"]}",
                            style: BuildUtils.headerTextStyle(
                                context, 0.02, FontWeight.bold),
                          ),
                          onSort: (_, __) {
                            setState(() {});
                          },
                        ),
                        DataColumn(
                          label: Text(
                            "${language.map["PRICE"]}",
                            style: BuildUtils.headerTextStyle(
                                context, 0.02, FontWeight.bold),
                          ),
                          onSort: (_, __) {
                            setState(() {});
                          },
                        ),
                        DataColumn(
                          label: Text(
                            "${language.map["CHANGE"]}",
                            style: BuildUtils.headerTextStyle(
                                context, 0.02, FontWeight.bold),
                          ),
                          onSort: (_, __) {
                            setState(() {});
                          },
                        ),
                        DataColumn(
                          label: Text(
                            "${language.map["PNL"]}",
                            style: BuildUtils.headerTextStyle(
                                context, 0.02, FontWeight.bold),
                          ),
                          onSort: (_, __) {
                            setState(() {});
                          },
                        ),
                      ],
                      rows: portfolio.assets.values
                          .map((data) => DataRow(cells: [
                                DataCell(
                                    Text(
                                      '${data.name.length > 7 ? data.symbol.toUpperCase() : data.name}',
                                      style: BuildUtils.headerTextStyle(
                                          context, .02),
                                    ), onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AssetView(asset: data)),
                                  );
                                }),
                                DataCell(
                                  Text(
                                    '${Asset.valueToText(data.amount)}',
                                    style: BuildUtils.headerTextStyle(
                                        context, .018),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    '\$${Asset.valueToText(data.price)}',
                                    style: BuildUtils.headerTextStyle(
                                        context, .018),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    '${Asset.valueToText(data.priceChangePercent)}%',
                                    style: BuildUtils.pnlTextStyle(
                                        context,
                                        data.priceChangePercent > 0,
                                        0.018,
                                        FontWeight.normal),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    '\$${Asset.valueToText(data.pnl)}',
                                    style: BuildUtils.pnlTextStyle(context,
                                        data.pnl > 0, 0.018, FontWeight.normal),
                                  ),
                                ),
                              ]))
                          .toList()))
            ],
          ),
        ));
  }

  List<Widget> portfolioIsEmpty() {
    return [
      BuildUtils.buildEmptySpaceHeight(context, 0.005),
      Text(
        'Your portfolio is empty.',
        style: BuildUtils.headerTextStyle(context),
      ),
      BuildUtils.buildEmptySpaceHeight(context, 0.8),
      Text(
        'Search for coins to add to your portfolio. ->',
        style: BuildUtils.headerTextStyle(context, 0.015),
      ),
      BuildUtils.buildEmptySpaceHeight(context, 0.05),
      Text(
        '${language.map["DISCLAIMER"]}',
        style: BuildUtils.headerTextStyle(context),
      ),
      BuildUtils.buildEmptySpaceHeight(context, 0.05),
    ];
  }

  List<Widget> portfolioIsNotEmpty() {
    return [
      BuildUtils.buildEmptySpaceHeight(context, 0.005),

      // SUMMARY CARD
      buildSummaryCard(),
      BuildUtils.buildEmptySpaceHeight(context, 0.005),

      // PORTFOLIO ALLOCATION
      buildPortfolioAllocation(),
      BuildUtils.buildEmptySpaceHeight(context, 0.005),

      // PORTFOLIO TABLE
      buildPortfolioTable(),
      BuildUtils.buildEmptySpaceHeight(context, 0.005),

      Text(
        '${language.map["DISCLAIMER"]}',
        style: BuildUtils.headerTextStyle(context),
      ),
      BuildUtils.buildEmptySpaceHeight(context, 0.05),
    ];
  }

  Widget appBar(BuildContext context, String title) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('images/icon.png',
            width: MediaQuery.of(context).size.height * .05,
            height: MediaQuery.of(context).size.height * .05),
          BuildUtils.buildEmptySpaceWidth(context, 0.02),
          Text(title)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: gotData ? AppBar(
        title: appBar(context, widget.title),
      ) : null,
      resizeToAvoidBottomInset: false,
      backgroundColor: BuildUtils.backgroundColor,
      body: gotData ? Center(
          child: RefreshIndicator(
                    onRefresh: _refresh,
                    child: ListView(children: <Widget>[
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: gotData ?
                            portfolio.assets.isNotEmpty ?
                              portfolioIsNotEmpty() :
                              portfolioIsEmpty() :
                              [Text('Getting there')],
                        ),
                      ),
                    ]))
      ) : splashScreen(context, widget.title),
      floatingActionButton: gotData ? FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchView()),);
        },
        tooltip: 'Search',
        child: Icon(EvaIcons.search),
      ):null, // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
