import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:web_socket_channel/html.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final channel = HtmlWebSocketChannel.connect('ws://xxx.xxx.xxx.xxx:xx');
    return MaterialApp(
      title: 'ESP8266 Dashboard',
      theme: ThemeData.dark(),
      home: Dashboard(channel: channel),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Dashboard extends StatefulWidget {
  final HtmlWebSocketChannel channel;

  const Dashboard({super.key, required this.channel});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  double voltage = double.nan;
  double current = 0;
  double power = 0;
  double energy = 0;
  double frequency = 0;
  double pf = 0;

  bool isConnected = true;
  DateTime? lastUpdated;

  @override
  void initState() {
    super.initState();
    widget.channel.stream.listen((message) {
      try {
        final data = json.decode(message);

        setState(() {
          voltage = data['voltage'] ?? double.nan;
          current = data['current'] ?? 0;
          power = data['power'] ?? 0;
          energy = data['energy'] ?? 0;
          frequency = data['frequency'] ?? 0;
          pf = data['pf'] ?? 0;

          // Connection logic
          isConnected = !voltage.isNaN && voltage <= 300;

          if (isConnected) {
            lastUpdated = DateTime.now();
          }
        });
      } catch (e) {
        setState(() {
          isConnected = false;
        });
      }
    }, onError: (error) {
      setState(() {
        isConnected = false;
      });
    });
  }

  Widget buildMeter(String label, double value, double maxValue, Color color) {
    return CircularPercentIndicator(
      radius: 120,
      animation: true,
      lineWidth: 20,
      percent: (value / maxValue).clamp(0, 1),
      center: Text(
        value.isNaN ? '--' : value.toStringAsFixed(2),
        style: const TextStyle(fontSize: 20, color: Colors.white),
      ),
      footer: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Text(
          label,
          style: const TextStyle(fontSize: 20, color: Colors.white70),
        ),
      ),
      progressColor: color,
      backgroundColor: Colors.grey[800]!,
      circularStrokeCap: CircularStrokeCap.round,
    );
  }

  @override
  Widget build(BuildContext context) {
    int crossAxisCount = MediaQuery.of(context).size.width ~/ 400;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('ESP8266 Live Dashboard'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                Icon(
                  Icons.circle,
                  color: isConnected ? Colors.green : Colors.red,
                  size: 15,
                ),
                const SizedBox(width: 6),
                Text(
                  isConnected ? 'Online' : 'Offline',
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: crossAxisCount.clamp(2, 4),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  buildMeter('Voltage (V)', voltage, 300, Colors.orange),
                  buildMeter('Current (A)', current, 1, Colors.cyan),
                  buildMeter('Power (W)', power, 20, Colors.red),
                  buildMeter('Energy (kWh)', energy, 10, Colors.amber),
                  buildMeter('Frequency (Hz)', frequency, 60, Colors.green),
                  buildMeter('Power Factor', pf, 1, Colors.purple),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                lastUpdated != null
                    ? 'Last Updated: ${lastUpdated!.toLocal().toString().split('.')[0]}'
                    : 'Waiting for data...',
                style: const TextStyle(fontSize: 16, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
