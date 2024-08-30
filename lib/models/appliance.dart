class Appliance {
  late final String id;
  final String name;
  final double power;
  final double hoursPerDay;
  final String consumerType;
  final bool isExclusive;

  Appliance({
    required this.id,
    required this.name,
    required this.power,
    required this.hoursPerDay,
    required this.consumerType,
    required this.isExclusive,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'power': power,
      'hoursPerDay': hoursPerDay,
      'consumerType': consumerType,
      'isExclusive': isExclusive,
    };
  }

  factory Appliance.fromMap(Map<String, dynamic> map) {
    return Appliance(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? 'Unknown Appliance',
      power: (map['power'] as num?)?.toDouble() ?? 0.0,
      hoursPerDay: (map['hoursPerDay'] as num?)?.toDouble() ?? 0.0,
      consumerType: map['consumerType'] as String? ?? 'Residential',
      isExclusive: map['isExclusive'] as bool? ?? false,
    );
  }

  double calculateMonthlyConsumption() {
    return power * hoursPerDay * 30 / 1000; // Convert to kWh
  }

  double calculateCost() {
    double consumption = calculateMonthlyConsumption();
    double cost = 0;
    if (consumerType == 'Residential') {
      if (isExclusive) {
        if (consumption <= 30) {
          cost = consumption * 0.65;
        } else {
          cost = 30 * 0.65 + (consumption - 30) * 1.49;
        }
      } else {
        if (consumption <= 300) {
          cost = consumption * 1.49 + 10.73; // Including service charge
        } else {
          cost = 300 * 1.49 +
              (consumption - 300) * 1.96 +
              10.73; // Including service charge
        }
      }
    } else if (consumerType == 'Non-Residential') {
      if (consumption <= 300) {
        cost = consumption * 1.34 + 12.43; // Including service charge
      } else {
        cost = 300 * 1.34 +
            (consumption - 300) * 1.67 +
            12.43; // Including service charge
      }
    }
    return cost;
  }
}
