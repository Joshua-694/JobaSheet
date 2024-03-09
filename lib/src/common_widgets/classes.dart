class InspectionRecord {
  String activity;
  String observations;
  String imagePath;
  DateTime dateTime; // Add this field

  InspectionRecord({
    required this.activity,
    required this.observations,
    required this.imagePath,
    required this.dateTime,
  });
}

class Material {
  String name;
  int quantity;

  Material({required this.name, required this.quantity});

  void addQuantity(int amount) {
    quantity += amount;
  }

  bool deductQuantity(int amount) {
    if (quantity - amount >= 0) {
      quantity -= amount;
      return true;
    }
    return false;
  }
}
