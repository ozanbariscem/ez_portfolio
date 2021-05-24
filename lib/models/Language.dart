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
    "OTHER": "Diğerleri", // "DİĞER",
    "DISCLAIMER": "2021, Ozan Barış CEM"
        "\nApp icon by Laura Reen, provided with CC 4.0 license."
        "\nhttps://dribbble.com/laurareen"
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
    "DISCLAIMER": "2021, Ozan Barış CEM"
        "\nApp icon by Laura Reen, provided with CC 4.0 license."
        "\nhttps://dribbble.com/laurareen"
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