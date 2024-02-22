class Plan {
  int? id;
  String planName;
  String location;
  String area;
  String selectedDate; // Eklenen alan: Seçilen tarih

  Plan({
    this.id,
    required this.planName,
    required this.location,
    required this.area,
    required this.selectedDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'planName': planName,
      'location': location,
      'area': area,
      'selectedDate': selectedDate, // Alanı ekle
    };
  }

  factory Plan.fromMap(Map<String, dynamic> map) {
    return Plan(
      id: map['id'],
      planName: map['planName'],
      location: map['location'],
      area: map['area'],
      selectedDate: map['selectedDate'], // Alanı ekle
    );
  }
}
