# Real-Time Data Infographics 
There is an adage in English language that a picture is worth a thousand words. It refers to the notion that complex data and descriptions can be conveyed with just a single picture. So, I am going to make an infographic which shows the real-time data of temperature, humidity and pressure in interactive way. By looking at the infographic people can understand easily the current condition of weather. And the window of infographic can also log data in a text file on command of mouse click.
M5StickC with Arduino programming will be used to process the BME280 sensor data and Processing language is used to create infographic. The data values are also display in M5StickC LCD concurrently with the Infographic.

# Items Used
-	[BME280 Temperature, Humidity and Pressure Sensor](https://www.adafruit.com/product/2652)
-	[M5StickC IOT Development Board](https://m5stack.com/products/stick-c)
-	[Breadboard](https://www.adafruit.com/product/64)
-	[Male to Male Jumper Wires](https://www.adafruit.com/product/758)
- [Arduino IDE](https://www.arduino.cc/en/software)
- [Processing IDE](https://processing.org/reference/environment/)

# Skills Required
- Breadboarding
- I2C Serial Communication protocol
- Basic Arduino Programming
- Basic Processing Programming

# Implementation Steps

## Step-1: Install IDEs, Libraries and Board Packages
Install Arduino IDE and Processing IDE to the PC along with the required libraries in Arduino IDE. The required libraries are M5 Stick C and Adafruit BME280. Also install M5StickC board package in Arduino IDE.

## Step-2: Wire Up the BME280 Sensor and M5StickC
Connect BME280 sensor and M5 Stick C using breadboard and jumper wires. I am joining the sensor and M5 Stick C using I2C interface communication. Follow the following method for I2C serial communication:
•	Connect ‘vio’ pin of sensor to the 3v3(3 volts) of M5 Stick C for the power supply.
•	Connect ‘GND’ of sensor to the ‘GND’ of M5 Stick C.
•	Connect ‘SDI’ pin of sensor to the ‘G0’ of the M5 Stick C.
•	Connect ‘SCK’ pin of sensor to the ‘G26’ of the M5 Stick C.
•	Lastly, connect ‘SDO’ of the sensor to ‘GND’ for the actual reading of values over I2C serial communication.

![Screenshot](M5StickC_Multiple_Features_Using_ButtonClass.PNG)




