import 'package:flutter/material.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WifiPage(),
    );
  }
}

class WifiPage extends StatefulWidget {
  @override
  _WifiPageState createState() => _WifiPageState();
}

class _WifiPageState extends State<WifiPage> {
  List<WifiNetwork> _wifiNetworks = [];

  @override
  void initState() {
    super.initState();
    initPermissions();
  }

  Future<void> initPermissions() async {
    // Request location permission
    var status = await Permission.location.request();
    if (status.isGranted) {
      // Location permission granted, now request Wi-Fi permissions
      var wifiStatus = await Permission.locationWhenInUse.request();
      if (wifiStatus.isGranted) {
        // Enable Wi-Fi
        await initWifi();
      } else {
        // Handle the case when Wi-Fi permission is not granted
        // You may want to show an error message or request permission again
      }
    } else {
      // Handle the case when location permission is not granted
      // You may want to show an error message or request permission again
    }
  }

  Future<void> initWifi() async {
    // Check if Wi-Fi is enabled
    bool isWifiEnabled = await WiFiForIoTPlugin.isEnabled();

    // If Wi-Fi is not enabled, enable it
    if (!isWifiEnabled) {
      await WiFiForIoTPlugin.setEnabled(true);
    }

    // Fetch the list of available Wi-Fi networks
    List<WifiNetwork> wifiList = await WiFiForIoTPlugin.loadWifiList();

    setState(() {
      _wifiNetworks = wifiList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wi-Fi Demo'),
      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                setState(() {});
              },
              child: Text("REfresh")),
          Container(
            height: 500,
            child: ListView.builder(
              itemCount: _wifiNetworks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_wifiNetworks[index].ssid!),
                  subtitle: Text(
                      'Signal strength: ${_wifiNetworks[index].level} dBm'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
