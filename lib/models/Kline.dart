class Kline {
  static List createFrom(List json) {
    List data = List.filled(json.length, "");
    for (int i = 0; i < json.length; i++) {
      data[i] = {"volumeto": 0, "open": 0.0, "high": 0.0, "low": 0.0, "close": 0.0};
      data[i]["volumeto"] = json[i][0]; // keep in mind this is actually the time
      data[i]["open"] = json[i][1];
      data[i]["high"] = json[i][2];
      data[i]["low"] = json[i][3];
      data[i]["close"] = json[i][4];
    }
    return data;
  }
}