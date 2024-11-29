class Crypto {
  String? id;
  String? name;
  String? symbol;
  double? changePercent24Hr;
  double? priceUsd;
  double? marketCapUsd;
  int? rank;

  Crypto(
    this.id,
    this.name,
    this.symbol,
    this.changePercent24Hr,
    this.priceUsd,
    this.marketCapUsd,
    this.rank,
  );

  factory Crypto.objectFromJSON(Map<String, dynamic> JsonFromObject) {
    return Crypto(
      JsonFromObject['id'],
      JsonFromObject['name'],
      JsonFromObject['symbol'],
      double.parse(
        JsonFromObject['changePercent24Hr'],
      ),
      double.parse(
        JsonFromObject['priceUsd'],
      ),
      double.parse(
        JsonFromObject['marketCapUsd'],
      ),
      int.parse(
        JsonFromObject['rank'],
      ),
    );
  }
}
