import 'package:flutter/material.dart';
import 'package:flutter_chat_app/common/ui_helpers.dart';
import 'package:flutter_chat_app/model/api_response.dart';
import 'package:flutter_chat_app/model/user_conversation.dart';
import 'package:flutter_chat_app/service/api_service.dart';
import 'package:flutter_chat_app/service/route_generator_service.dart';
import 'package:flutter_chat_app/shared/constants.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrCodeScannerScreen extends StatefulWidget {
  const QrCodeScannerScreen({super.key});

  @override
  State<QrCodeScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrCodeScannerScreen> {
  final GlobalKey qrKey = GlobalKey();
  APIService apiService = APIService();

  onQRViewCreated(QRViewController qrViewController) {
    qrViewController.scannedDataStream.listen((qrData) async {
      qrViewController.pauseCamera();
      String? qrCode = qrData.code;
      final apiResponse = await apiService.joinGroup(qrCode!);
      Navigator.of(Constants().navigatorKey.currentContext!).pushNamed(RouteGeneratorService.chatScreen, arguments: apiResponse);
    });
  }

  @override
  Widget build(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height < 400) ? 220.0 : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(),
      body: SafeArea(
        child: QRView(
          key: qrKey,
          onQRViewCreated: onQRViewCreated,
          overlay: QrScannerOverlayShape(
            borderColor: Colors.red,
            borderRadius: 10,
            borderLength: 30,
            borderWidth: 10,
            cutOutSize: scanArea,
          ),
        ),
      ),
    );
  }
}
