import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class NotificationScreen extends StatefulWidget {
  final BluetoothDevice device;

  const NotificationScreen({Key? key, required this.device}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<BluetoothCharacteristic> characteristics = [];
  List<String> itemBarcodesList = [];

  void _discoverCharacteristics() async {
    final services = await widget.device.discoverServices();

    for (final service in services) {
      final characteristics = await service.characteristics.toList();
      setState(() {
        this.characteristics = characteristics;
      });
    }

    for(var c in characteristics){
       if(c.uuid.toString() == '6e400003-b5a3-f393-e0a9-e50e24dcca9e'){
         await c.setNotifyValue(true);
         c.value.listen((value) {
           final receivedValue = String.fromCharCodes(value);
           itemBarcodesList.add(receivedValue);
           setState(() {

           });
         });
       }
    }

  }

  @override
  void initState() {
    super.initState();
    _discoverCharacteristics();
  }

  @override
  void dispose() {
    widget.device.disconnect();
    super.dispose();
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20,),
          const Text('Please scan any product to be added to your cart',style: TextStyle(
              color: Colors.purple,
              fontSize: 16
          ),),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(left: 20),
              itemCount: itemBarcodesList.length,
              itemBuilder: (BuildContext context, int index) {
                final item = itemBarcodesList[index];
                return ListTile(
                  title: Text(item,style: const TextStyle(
                      color: Colors.purple,
                      fontSize: 16
                  ),),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}