import 'package:flutter_background_service/flutter_background_service.dart';

class ReceiveCallService {
  final serviceHandler = FlutterBackgroundService();

  Future<void> initializeReceiveCallService() async {
    await serviceHandler.configure(
        iosConfiguration: IosConfiguration(),
        androidConfiguration: AndroidConfiguration(
          onStart: receiveCall,
          isForegroundMode: true,
        ));
  }

  void receiveCall(ServiceInstance service) {}
}
