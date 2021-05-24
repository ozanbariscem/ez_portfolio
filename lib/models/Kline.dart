class Kline {
  static List createFrom(List json) {
    List data = new List(json.length);
    for (int i = 0; i < json.length; i++) {
      data[i] = {"open": 0.0, "high": 0.0, "low": 0.0, "close": 0.0, "volumeto": 0.0};
      data[i]["open"] = double.parse(json[i][1]);
      data[i]["high"] = double.parse(json[i][2]);
      data[i]["low"] = double.parse(json[i][3]);
      data[i]["close"] = double.parse(json[i][4]);
      data[i]["volumeto"] = double.parse(json[i][5]);
    }
    return data;
  }
}