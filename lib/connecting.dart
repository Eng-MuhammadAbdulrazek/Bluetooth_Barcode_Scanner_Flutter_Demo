import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'cart.dart';
import 'package:lottie/lottie.dart';

class connectDevice extends StatefulWidget {
  const connectDevice({Key? key,required this.targetDevice}) : super(key: key);
  final String? targetDevice;

  @override
  _connectDeviceState createState() => _connectDeviceState();
}

class _connectDeviceState extends State<connectDevice> {
    List<ScanResult> scanResults = [];
    // Initialize FlutterBluePlus
    final _flutterBlue = FlutterBluePlus.instance;
    late BluetoothDevice connectedDevice;

    Future<void> connectToDevice(String targetDevice,) async {
      while (true) {
        try {
          print('Scanning for devices...');
          final List<ScanResult> scanResults = await _flutterBlue.startScan(timeout: const Duration(seconds: 4));
          final List<BluetoothDevice> devices = scanResults.map((result) => result.device).toList();

          if (devices.isEmpty) {
            print('No devices found.');
            await Future.delayed(const Duration(seconds: 1));
            continue;
          }


          final BluetoothDevice device = devices.firstWhere(
                (device) => device.id.toString() == targetDevice,
            orElse: () {
              throw Exception('Target device not found 1.');
            },
          );


          if (device == null) {
            print('Target device not found 2.');
            await Future.delayed(const Duration(seconds: 1));
            continue;
          }

          await device.connect(autoConnect: false);
          print('Connected to ${device.name}');
          connectedDevice = device;
          break;
        } catch (e) {
          print('Error connecting to device: $e');
          await Future.delayed(const Duration(seconds: 1));
        }
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NotificationScreen(device: connectedDevice)),
      );
    }

    @override
  void initState() {
    super.initState();
    connectToDevice(widget.targetDevice!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.purple,
        leading: const SizedBox(width: 0,),
        title: const Text('Robobox Smart Cart'),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset('assets/bl.json'),
            const SizedBox(height: 30,),
            const Text('Please wait while connecting to',style: TextStyle(
              color: Colors.purple,
              fontSize: 16
            ),),
            const SizedBox(height: 15,),
            Text(widget.targetDevice!,style: const TextStyle(
                color: Colors.purple,
                fontSize: 20,
              fontWeight: FontWeight.w700
            ),),
          ],
        ),
      ),
    );
  }
}
