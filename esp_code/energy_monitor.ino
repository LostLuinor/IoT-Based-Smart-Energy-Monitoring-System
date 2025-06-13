#include <ESP8266WiFi.h>
#include <WebSocketsServer.h>
#include <SoftwareSerial.h>
#include <PZEM004Tv30.h>

// WiFi Credentials
const char* ssid = "REDACTED";
const char* password = "REDACTED";

// PZEM over SoftwareSerial
#define RX_PIN 13  // GPIO13 (D7)
#define TX_PIN 12  // GPIO12 (D6)
SoftwareSerial pzemSerial(RX_PIN, TX_PIN);

PZEM004Tv30 pzem(pzemSerial);

// WebSocket on port 81
WebSocketsServer webSocket = WebSocketsServer(81);

void setup() {
  Serial.begin(9600);
  pzemSerial.begin(9600);

  WiFi.begin(ssid, password);
  Serial.println("Connecting to WiFi...");

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("\nConnected to WiFi");
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());

  webSocket.begin();
  webSocket.onEvent(webSocketEvent);
}

void loop() {
  webSocket.loop();

  static unsigned long lastSend = 0;
  if (millis() - lastSend > 2000) {
    float voltage = pzem.voltage();
    float current = pzem.current();
    float power   = pzem.power();
    float energy  = pzem.energy();
    float frequency = pzem.frequency();
    float pf = pzem.pf();

    String data = "{";
    data += "\"voltage\":" + String(voltage) + ",";
    data += "\"current\":" + String(current) + ",";
    data += "\"power\":"   + String(power) + ",";
    data += "\"energy\":"  + String(energy) + ",";
    data += "\"frequency\":" + String(frequency) + ",";
    data += "\"pf\":" + String(pf);
    data += "}";

    webSocket.broadcastTXT(data);
    Serial.println("Sent: " + data);
    lastSend = millis();
  }
}

void webSocketEvent(uint8_t num, WStype_t type, uint8_t * payload, size_t length) {
  if (type == WStype_CONNECTED) {
    Serial.println("WebSocket Client Connected");
  } else if (type == WStype_DISCONNECTED) {
    Serial.println("WebSocket Client Disconnected");
  } else if (type == WStype_TEXT) {
    Serial.printf("Received from client: %s\n", payload);
  }
}
