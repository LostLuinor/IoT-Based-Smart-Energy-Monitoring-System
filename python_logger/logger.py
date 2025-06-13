import asyncio
import websockets
import csv
from datetime import datetime  # Import datetime for timestamps

# Replace with your ESP8266 IP address
ESP8266_IP = "ws://xxx.xxx.xxx.xxx:xx"  

async def listen():
    try:
        # Open the CSV file in append mode
        with open("pzem_data.csv", mode="a", newline="") as file:
            writer = csv.writer(file)
            # Write the header row if the file is empty
            if file.tell() == 0:
                writer.writerow(["Timestamp", "Voltage", "Current", "Power", "Energy", "Frequency", "Power Factor"])
            
            async with websockets.connect(ESP8266_IP) as websocket:
                print("Connected to ESP8266 WebSocket")
                while True:
                    message = await websocket.recv()
                    print("Received message:", message)
                    
                    # Manually extract values from the string
                    try:
                        # Remove braces and split by commas
                        message = message.strip("{}")
                        data_pairs = message.split(",")
                        
                        # Extract values from key-value pairs
                        data = {}
                        for pair in data_pairs:
                            key, value = pair.split(":")
                            data[key.strip('"')] = value
                        
                        # Get the current timestamp
                        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
                        
                        # Write the extracted values along with the timestamp to the CSV
                        writer.writerow([
                            timestamp,
                            data.get("voltage", "N/A"),
                            data.get("current", "N/A"),
                            data.get("power", "N/A"),
                            data.get("energy", "N/A"),
                            data.get("frequency", "N/A"),
                            data.get("pf", "N/A")
                        ])
                    except Exception as e:
                        print("Error processing message:", e)
    except Exception as e:
        print("Error:", e)

if __name__ == "__main__":
    asyncio.run(listen())
