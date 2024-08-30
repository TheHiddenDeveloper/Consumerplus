import 'package:flutter/material.dart';
import '../models/appliance.dart';

class ApplianceCard extends StatelessWidget {
  final Appliance appliance;

  const ApplianceCard({super.key, required this.appliance});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        title: Text(appliance.name),
        subtitle:
            Text('${appliance.power} W, ${appliance.hoursPerDay} hours/day'),
      ),
    );
  }
}
