import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:permission_handler/permission_handler.dart';
import 'connecting.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;

  @override
 void initState(){
   super.initState();
   checkPermissions();
   enableBluetooth();
 }
 void enableBluetooth() async{
   bool bluetoothStatus = await flutterBlue.isOn;
   if(bluetoothStatus == false){
     bool x = await flutterBlue.turnOn();
     bluetoothStatus = x;
   }
 }

 void checkPermissions() async{
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location, Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothAdvertise,
      Permission.bluetoothConnect,
    ].request();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Center(child: Text('Robobox Smart Cart')),
        backgroundColor: Colors.white,
        foregroundColor: Colors.purple,
        elevation: 0,
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset('assets/qrcode.json'),
            const SizedBox(
              height: 50.0,
            ),
            const Text(
              'Welcome to Robobox Smart Cart Demo',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w600,
                color: Colors.purple,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            const Text(
              'please scan cart\'s QR code',
              style: TextStyle(
                fontSize: 22.0,
                color: Colors.purple,
              ),
            ),
            const SizedBox(
              height: 50.0,
            ),
            ElevatedButton(
              onPressed: () async {
                String? cameraScanResult = await scanner.scan();
                if(cameraScanResult != null) {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) =>
                           connectDevice(targetDevice: cameraScanResult,))
                  );
                }
                },
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.purple),
                fixedSize: MaterialStatePropertyAll(Size(200, 50)),
              ),
              child: const Text('SCAN QR'),
            )
          ],
        ),
      ),
    );
  }
}
