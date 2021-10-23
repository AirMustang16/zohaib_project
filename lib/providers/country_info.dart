class CountryInfo {
  var provinces;
  var Antwerpen;
  var Limburg;
  var Oost;
  var Vlaams;
  var West;

  CountryInfo(this.provinces, this.Antwerpen, this.Limburg, this.Oost,
      this.Vlaams, this.West);

  CountryInfo.fromJson(Map<String, dynamic> json) {
    provinces = json['provinces'];
    Antwerpen = json['Antwerpen'];
    Limburg = json['Limburg'];
    Oost = json['Oost-Vlaanderen'];
    Vlaams = json['Vlaams-Brabant'];
    West = json['West-Vlaanderen'];
  }
  Map<String, dynamic> toJson() => {
        'provinces': provinces,
        'Antwerpen': Antwerpen,
        'Limburg': Limburg,
        'Oost-Vlaanderen': Oost,
        'Vlaams-Brabant': Vlaams,
        'West-Vlaanderen': West,
      };
}
