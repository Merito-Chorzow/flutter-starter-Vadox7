import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';

class SensorService {
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;
  
  double? _accelX;
  double? _accelY;
  double? _accelZ;
  double? _gyroX;
  double? _gyroY;
  double? _gyroZ;
  
  bool _isListening = false;

  double? get accelX => _accelX;
  double? get accelY => _accelY;
  double? get accelZ => _accelZ;
  double? get gyroX => _gyroX;
  double? get gyroY => _gyroY;
  double? get gyroZ => _gyroZ;

  bool get isListening => _isListening;

  void startListening() {
    if (_isListening) return;

    _isListening = true;

    // Akcelerometr
    _accelerometerSubscription = accelerometerEventStream().listen(
      (AccelerometerEvent event) {
        _accelX = event.x;
        _accelY = event.y;
        _accelZ = event.z;
      },
      onError: (error) {
        _isListening = false;
      },
    );

    // Żyroskop
    _gyroscopeSubscription = gyroscopeEventStream().listen(
      (GyroscopeEvent event) {
        _gyroX = event.x;
        _gyroY = event.y;
        _gyroZ = event.z;
      },
      onError: (error) {
        _isListening = false;
      },
    );
  }

  void stopListening() {
    _accelerometerSubscription?.cancel();
    _gyroscopeSubscription?.cancel();
    _accelerometerSubscription = null;
    _gyroscopeSubscription = null;
    _isListening = false;
  }

  Map<String, double?> getCurrentValues() {
    return {
      'accelX': _accelX,
      'accelY': _accelY,
      'accelZ': _accelZ,
      'gyroX': _gyroX,
      'gyroY': _gyroY,
      'gyroZ': _gyroZ,
    };
  }

  void dispose() {
    stopListening();
  }
}

