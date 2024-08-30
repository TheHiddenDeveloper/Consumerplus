import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/db_service.dart';
import '../../models/appliance.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dbService = Provider.of<DBService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<List<Appliance>>(
          stream: dbService.appliances,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final appliances = snapshot.data!;
              return ListView.builder(
                itemCount: appliances.length,
                itemBuilder: (context, index) {
                  final appliance = appliances[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      title: Text(
                        appliance.name,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Power: ${appliance.power} W',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            'Usage: ${appliance.hoursPerDay} hours/day',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            'Monthly Consumption: ${appliance.calculateMonthlyConsumption().toStringAsFixed(2)} kWh',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            'Monthly Cost: GHS ${appliance.calculateCost().toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
