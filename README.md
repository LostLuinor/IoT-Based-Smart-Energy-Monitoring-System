# IoT-Based Smart Energy Monitoring System

## Overview
This project implements an **IoT-based Smart Energy Monitoring System** designed to monitor electrical parameters such as voltage, current, power, energy consumption, frequency, and power factor in real-time. The system leverages the **ESP8266 Wi-Fi module** and the **PZEM-004T energy sensor** to collect data from a connected load (e.g., a household bulb). The data is transmitted via **WebSocket** to a **Flutter-based mobile application** for real-time visualization and a **Python script** for data logging into a CSV file for historical analysis. This solution is cost-effective, scalable, and suitable for smart home or small-scale industrial energy monitoring.

This repository contains the source code for the ESP8266 firmware, the Flutter mobile application, and the Python logging script, along with documentation and setup instructions.

## Features
- **Real-Time Monitoring**: Measures and displays electrical parameters (voltage, current, power, energy, frequency, power factor) every 2 seconds.
- **Mobile Application**: A user-friendly Flutter-based Android app for live data visualization using circular progress indicators.
- **Data Logging**: A Python script logs data into a CSV file with timestamps for historical analysis.
- **WebSocket Communication**: Ensures low-latency, bidirectional data transmission between the ESP8266 and clients.
- **Affordable Hardware**: Built using low-cost components like ESP8266 and PZEM-004T.
- **Non-Intrusive Measurement**: Uses a closed-loop current transformer (CT) for safe current monitoring.

## System Architecture
The system consists of three main layers:
1. **Data Acquisition**: The ESP8266 interfaces with the PZEM-004T sensor to collect electrical parameters via a UART serial interface.
2. **Data Transmission**: The ESP8266 broadcasts data over a WebSocket server on port 81 to connected clients.
3. **User Interaction**: A Flutter-based mobile app displays real-time data, and a Python script logs data to a CSV file.

![System Architecture](docs/system_architecture.png) *(Add your architecture diagram here)*

## Hardware Requirements
- **ESP8266 Wi-Fi Module**: Acts as the core microcontroller for data processing and Wi-Fi communication.
- **PZEM-004T Energy Sensor**: Measures electrical parameters (voltage, current, power, energy, frequency, power factor).
- **Closed-Loop Current Transformer (CT)**: Non-intrusive current measurement for the PZEM-004T.
- **Household Bulb and Socket**: Used as the test load for demonstration.
- **Power Supply**: 5V DC for the ESP8266 and appropriate AC supply for the load.

## Software Requirements
- **Arduino IDE**: For programming the ESP8266.
- **Flutter and Dart**: For developing the Android mobile application.
- **Python**: For running the data logging script.
- **Libraries**:
  - Arduino: `SoftwareSerial`, `ESP8266WiFi`, `WebSocketsServer`
  - Python: `websocket-client`, `csv`
  - Flutter: Standard Dart packages for WebSocket communication and UI rendering.

## Installation
### 1. Hardware Setup
1. Connect the PZEM-004T sensor to the ESP8266 using the UART interface (TX/RX pins).
2. Attach the closed-loop CT to the live wire of the AC circuit (e.g., bulb socket).
3. Power the ESP8266 with a 5V DC supply and ensure the bulb is connected to an AC supply.
4. Verify all connections as per the wiring diagram (see `docs/wiring_diagram.png`).

### 2. Firmware Setup
1. Install the **Arduino IDE** and add support for the ESP8266 board via the Boards Manager.
2. Install required libraries: `SoftwareSerial`, `ESP8266WiFi`, and `WebSocketsServer`.
3. Open the `firmware/energy_monitor.ino` file in the Arduino IDE.
4. Update the Wi-Fi credentials (`SSID` and `PASSWORD`) in the firmware code.
5. Upload the code to the ESP8266.

### 3. Mobile Application Setup
1. Install **Flutter** and set up the development environment (Android Studio or VS Code).
2. Clone this repository and navigate to the `mobile_app` directory.
3. Run `flutter pub get` to install dependencies.
4. Update the WebSocket server IP address in `lib/main.dart` to match the ESP8266's IP.
5. Build and run the app on an Android device using `flutter run`.

### 4. Data Logging Setup
1. Install **Python 3.x** and required libraries: `pip install websocket-client`.
2. Navigate to the `python_logger` directory.
3. Update the WebSocket server IP address in `logger.py`.
4. Run the script: `python logger.py`.

## Usage
1. Power on the hardware setup and ensure the ESP8266 connects to the Wi-Fi network.
2. Launch the Flutter mobile app to view real-time electrical parameters in a grid-based dashboard.
3. Run the Python logging script to save data to a CSV file (`data_log.csv`) for historical analysis.
4. Monitor the connection status in the app and verify data consistency in the CSV file.

## Testing and Validation
The system was tested using a household bulb as the load. Key observations:
- Voltage: ~230V (stable for AC supply).
- Frequency: ~50Hz (standard for most regions).
- Power factor: ~1 for resistive loads (e.g., incandescent bulbs), lower for LEDs.
- Real-time updates: Refreshed every 2-3 seconds in the mobile app.
- Data logging: Consistent CSV entries with timestamps.

Limitations:
- Occasional Wi-Fi disconnections in weak signal areas.
- Potential for improvement with retry logic and data buffering.

## Directory Structure
```
├── docs/                    # Documentation and diagrams
├── firmware/                # ESP8266 Arduino code
│   └── energy_monitor.ino
├── mobile_app/              # Flutter mobile application
│   ├── lib/
│   └── pubspec.yaml
├── python_logger/           # Python data logging script
│   └── logger.py
└── README.md
```

## Future Enhancements
- **Cloud Integration**: Store data in a cloud platform like Firebase for remote access.
- **Automated Alerts**: Notify users via email/SMS when consumption exceeds thresholds.
- **Multi-Sensor Support**: Extend the system to monitor multiple loads simultaneously.
- **Improved Robustness**: Add retry logic and buffering for better network stability.

## References
1. M. P. Muralidharan, L. Nislaiai, and U. Aishwarya, "IoT Based Smart Energy Meter for Power Monitoring System Using ESP8266," *International Research and Technology (REET)*, vol. 9, no. 10, Oct. 2023.
2. H. Malviya, V. Shukla, and S. S. Raghuwanshi, "IoT-Enabled Real-Time Smart Energy Meter," *International Journal for Research Trends and Innovation (IJRTI)*, vol. 8, no. 5, 2023.

## License
This project is licensed under the MIT License. See the `LICENSE` file for details.

## Contributors
- Manoj Srivatsav
- Saran J Palani
- Lishanthan Sri Ayyanar
- Sirisha Tadepalli
