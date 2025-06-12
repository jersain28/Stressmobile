import 'package:flutter/material.dart';
import 'package:stress/home/stress_monitor.dart';

class SmartwatchConnectionScreen extends StatefulWidget {
  const SmartwatchConnectionScreen({Key? key}) : super(key: key);

  @override
  State<SmartwatchConnectionScreen> createState() =>
      _SmartwatchConnectionScreenState();
}

class _SmartwatchConnectionScreenState
    extends State<SmartwatchConnectionScreen> {
  bool _searching = false;
  bool _connected = false;
  String? _selectedDevice;
  final List<String> _devices = [
    'SmartWatch Pro X2',
    'FitWatch Series 5',
    'HealthBand Elite',
  ];

  void _searchDevices() {
    setState(() {
      _searching = true;
      _connected = false;
      _selectedDevice = null;
    });
    // Simula búsqueda de dispositivos
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _searching = false;
      });
    });
  }

  void _connectDevice(String device) {
    setState(() {
      _selectedDevice = device;
      _connected = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text(
                'Conectar tu Smartwatch',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFFB0B8D1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Asegúrate de que el Bluetooth de tu teléfono esté activado y que tu smartwatch esté en modo de emparejamiento. Toca el botón de abajo para buscar dispositivos cercanos.',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB0B8D1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.bluetooth_searching),
                  label: const Text(
                    'Buscar dispositivos',
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: _searchDevices,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Dispositivos disponibles',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              if (_searching)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text(
                      'Buscando dispositivos cercanos...',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                ),
              if (!_searching && !_connected)
                ..._devices.map(
                  (device) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB0B8D1),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.centerLeft,
                        ),
                        onPressed: () => _connectDevice(device),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.watch, color: Colors.white),
                                SizedBox(width: 12),
                              ],
                            ),
                            Expanded(
                              child: Text(
                                device,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              if (_connected)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB0B8D1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.check_circle, color: Colors.white),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Tu smartwatch se ha conectado correctamente',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 32),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const StressMonitorScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    '¿Omitir por ahora?',
                    style: TextStyle(
                      color: Colors.black45,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
