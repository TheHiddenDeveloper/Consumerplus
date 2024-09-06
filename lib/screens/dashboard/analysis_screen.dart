import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/appliance.dart';
import '../../utils/fade_route.dart';
import 'dashboard_screen.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  Stream<List<Appliance>> getAppliancesStream() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final emailKey = user.email!.replaceAll('.', ',');
      return FirebaseFirestore.instance
          .collection(emailKey)
          .doc('appliances')
          .collection('items')
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) {
                final data = doc.data();
                return Appliance(
                  id: doc.id,
                  name: data['name'],
                  power: data['power'],
                  hoursPerDay: data['hoursPerDay'],
                  consumerType: data['consumerType'],
                  isExclusive: data['isExclusive'],
                );
              }).toList());
    } else {
      return Stream.value([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Consumption Analysis')),
      body: StreamBuilder<List<Appliance>>(
        stream: getAppliancesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final appliances = snapshot.data!;
            if (appliances.isEmpty) {
              return const Center(child: Text('No appliances found.'));
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Consumption Chart',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: PieChart(
                                    PieChartData(
                                      pieTouchData: PieTouchData(
                                        touchCallback: (FlTouchEvent event,
                                            pieTouchResponse) {
                                          // Handle touch events
                                        },
                                      ),
                                      borderData: FlBorderData(show: false),
                                      sectionsSpace: 0,
                                      centerSpaceRadius: 40,
                                      sections:
                                          _createPieChartSections(appliances),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: _createLegend(appliances),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Total Consumption: ${appliances.fold(0.0, (sum, a) => sum + a.calculateMonthlyConsumption()).toStringAsFixed(2)} kWh',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          Text(
                            'Total Cost: GHS ${appliances.fold(0.0, (sum, a) => sum + a.calculateCost()).toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Consumption Analysis',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
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
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                Text(
                                  'Usage: ${appliance.hoursPerDay} hours/day',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                Text(
                                  'Monthly Consumption: ${appliance.calculateMonthlyConsumption().toStringAsFixed(2)} kWh',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                Text(
                                  'Monthly Cost: GHS ${appliance.calculateCost().toStringAsFixed(2)}',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading appliances.'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Set this to the index of the AnalysisScreen
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.push(context, FadeRoute(page: const DashboardScreen()));
              break;
            case 1:
              Navigator.push(context, FadeRoute(page: const AnalysisScreen()));
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analysis',
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _createPieChartSections(
      List<Appliance> appliances) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.amber,
      Colors.cyan,
    ];
    final colorMap = <Appliance, Color>{};
    for (var i = 0; i < appliances.length; i++) {
      colorMap[appliances[i]] = colors[i % colors.length];
    }
    return appliances.asMap().entries.map((entry) {
      final index = entry.key;
      final appliance = entry.value;
      final consumption = appliance.calculateMonthlyConsumption();
      final isTouched = index == _touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      final color = colorMap[appliance]!;

      return PieChartSectionData(
        color: color,
        value: consumption,
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  final int _touchedIndex = -1;

  List<Widget> _createLegend(List<Appliance> appliances) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.amber,
      Colors.cyan,
    ];
    final colorMap = <Appliance, Color>{};
    for (var i = 0; i < appliances.length; i++) {
      colorMap[appliances[i]] = colors[i % colors.length];
    }
    return appliances.asMap().entries.map((entry) {
      final appliance = entry.value;
      final color = colorMap[appliance]!;
      final consumption = appliance.calculateMonthlyConsumption();

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              color: color,
            ),
            const SizedBox(width: 8),
            Text(
              '${appliance.name}: ${consumption.toStringAsFixed(1)} kWh',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      );
    }).toList();
  }
}
