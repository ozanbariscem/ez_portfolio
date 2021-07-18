class Language {
  static const Map<String, String> TURKISH = {
    "ID": "tr",
    "NETWORTH": "Portfolyo Değeri",
    "DAILYPNL": "Bugünki KAR",
    "TOTALPNL": "Toplam KAR",
    "ALLOCATION": "Portfolyo Dağılımı",
    "PORTFOLIO": "Portfolyo",
    "NAME": "Ad",
    "AMOUNT": "Adet",
    "PRICE": "Fiyat",
    "CHANGE": "Değişim",
    "PNL": "KAR",
    "OTHER": "Diğerleri",
    "SEARCH": "Arama",
    "SEARCH_TIP": "Coin adı ya da sembol",
    "SEARCH_WAIT": "İki saniye müsade et, verileri çekiyoruz.",
    "SEARCH_NOT_FOUND": "Bu isimde bir coin bulamadık.",

    "RANK": "Sıralama",
    "WEBSITE": "Websayfası",
    "MARKET_CAP": "Piyasa Değeri",
    "CIRCULATING_SUPPLY": "Piyasadaki Adedi",
    "GRAPH": "Graf",
    "YOUR_HOLDINGS": "Elindekiler",
    "TRADE_HISTORY": "İşlem Geçmişi",
    "TOTAL_IN_DOLLARS": "\$ değeri",
    "AVG_PRICE": "Ort. Fiyat",

    "NO_HOLDINGS": "Elinde hiç yok.",
    "NO_TRADE": "Daha herhangi bir işlem yapmadın.",

    "BUY": "Al",
    "SELL": "Sat",

    "BOUGHT": "Al",
    "SOLD": "Sat",
    "AT": "ken fiyat",

    "PORTFOLIO_EMPTY": "Portfolyonda henüz bir coin yok",
    "PORTFOLIO_EMPTY_HELP": "Portfolyona eklemek için coin ara. ->",

    "LAST": "Son",
    "DAY": "gün",

    "CREDITS": "Credits",
  };

  static const Map<String, String> ENGLISH = {
    "ID": "en",
    "NETWORTH": "Portfolio Networth",
    "DAILYPNL": "Today\'s PNL",
    "TOTALPNL": "Total PNL",
    "ALLOCATION": "Portfolio Allocation",
    "PORTFOLIO": "Portfolio",
    "NAME": "Name",
    "AMOUNT": "Amount",
    "PRICE": "Price",
    "CHANGE": "Change",
    "PNL": "PNL",
    "OTHER": "Others",

    "SEARCH": "Search",
    "SEARCH_TIP": "Coin name or symbol",
    "SEARCH_WAIT": "Hold on we are retrieving the data for you.",
    "SEARCH_NOT_FOUND": "Couldn't find coin with given name.",

    "RANK": "Rank",
    "WEBSITE": "Website",
    "MARKET_CAP": "Market Cap",
    "CIRCULATING_SUPPLY": "Circulating Supply",
    "GRAPH": "Graph",
    "YOUR_HOLDINGS": "Your Holdings",
    "TRADE_HISTORY": "Trade History",
    "TOTAL_IN_DOLLARS": "Total in \$",
    "AVG_PRICE": "Avg. Price",

    "NO_HOLDINGS": "You don't have any.",
    "NO_TRADE": "You didn't take any trades yet.",

    "BUY": "Buy",
    "SELL": "Sell",

    "BOUGHT": "Bought",
    "SOLD": "Sold",
    "AT": "at",

    "PORTFOLIO_EMPTY": "Your portfolio is empty.",
    "PORTFOLIO_EMPTY_HELP": "Search for coins to add to your portfolio. ->",

    "LAST": "Last",
    "DAY": "days",

    "CREDITS": "Credits",
  };

  static Language language;
  Map<String, String> map;

  Language(Map<String, String> pack) {
    this.map = pack;
  }

  static Language changeLanguage(Map<String, String> pack) {
    language = new Language(pack);
    return language;
  }
}