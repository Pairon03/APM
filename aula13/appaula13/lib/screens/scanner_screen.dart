// tela para escanear o qrcode

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  bool _handled = false;
  final MobileScannerController _controller = MobileScannerController(
    detectionTimeoutMs: 600,
    facing:  CameraFacing.back,
    torchEnabled: false
  );
  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture){
    if(_handled) return;
    final barcodes = capture.barcodes;
    if(barcodes.isEmpty)return;

    final raw = barcodes.first.rawValue;
    if(raw == null || raw.isEmpty) return;
    _handled =true;
    Navigator.pop(context,raw); // devolve o valor lido
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.black,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: Text(
          'App aula 13 TA - Escanear QR Code',
          style: TextStyle(color: Colors.white),
        ),

        actions: [
          IconButton(onPressed: ()=>_controller.toggleTorch(), icon: Icon(Icons.flash_on,color: Colors.white,)),
          IconButton(onPressed: ()=>_controller.switchCamera(), icon: Icon(Icons.cameraswitch,color: Colors.white,))
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(controller: _controller,onDetect: _onDetect,),
          IgnorePointer(
            child: Center(
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white70,width: 2),
                  borderRadius: BorderRadius.circular(12)
                ),
              ),
            ),
          )
        ],
      ),

    );
  }
}