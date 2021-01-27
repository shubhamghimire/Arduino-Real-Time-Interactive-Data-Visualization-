#include <M5StickC.h>
#include <SPI.h>
#include <Wire.h>

#include <Adafruit_Sensor.h>
#include <Adafruit_BME280.h>
#define SEALEVELPRESSURE_HPA (1011.25)
Adafruit_BME280 bme;           // BME280 I2C connection with M5 Stick C

RTC_TimeTypeDef RTC_TimeStruct;      // RTC modules of M5 Stick C
RTC_DateTypeDef RTC_DateStruct;

void setup() {

  M5.begin();
  Wire.begin(0, 26);

  while (!bme.begin()) {

    Serial.println("Could not find a valid BME280 sensor, check wiring!");

    M5.Lcd.println("Could not find a valid BME280 sensor, check wiring!");

  }
  M5.Lcd.setRotation(3);
  M5.Lcd.fillScreen(BLACK);

  //Setting time and date
  RTC_TimeTypeDef TimeStruct;
  TimeStruct.Hours = 9;
  TimeStruct. Minutes = 5;
  TimeStruct.Seconds = 45;
  M5.Rtc.SetTime(&TimeStruct);
  RTC_DateTypeDef DateStruct;
  DateStruct.WeekDay = 5;
  DateStruct.Month = 8;
  DateStruct.Date = 16;
  DateStruct.Year = 2019;
  M5.Rtc.SetData(&DateStruct);
}

void loop() {

  M5.Lcd.setCursor(0, 0);

  float tmp = bme.readTemperature();

  float hum = bme.readHumidity();

  float pressure = bme.readPressure() / 100.0F;

  float altitude = bme.readAltitude(SEALEVELPRESSURE_HPA);

  Serial.print(hum);
  Serial.print(",");
  Serial.print(tmp);
  Serial.print(",");
  Serial.print(pressure);
  Serial.print(",");
  Serial.println(altitude);

  displayDate();
  getTempC();
  getPressureP();
  getHumidityR();

  delay(1000);
}

void getTempC() {
  M5.Lcd.setTextColor(RED, BLACK);
  M5.Lcd.setTextSize(2);
  M5.Lcd.println(" ");
  M5.Lcd.print("T:");
  M5.Lcd.print(bme.readTemperature());
  M5.Lcd.println(" *C");
  //M5.Lcd.println(" ");
}

void getPressureP() {
  M5.Lcd.setTextColor(GREEN, BLACK);
  M5.Lcd.setTextSize(2);
  M5.Lcd.print("P:");
  M5.Lcd.print(bme.readPressure() / 100.0F);
  M5.Lcd.println(" hPa");
  //M5.Lcd.println(" ");

}

void getHumidityR() {
  M5.Lcd.setTextColor(BLUE, BLACK);
  M5.Lcd.setTextSize(2);
  M5.Lcd.print("H:");
  M5.Lcd.print(bme.readHumidity());
  M5.Lcd.println(" %");
  M5.Lcd.println(" ");
}

void getAltitude() {
  M5.Lcd.println(" ");
  //M5.Lcd.println("Altitude:");
  M5.Lcd.println(bme.readAltitude(SEALEVELPRESSURE_HPA));
  M5.Lcd.println(" m");

}

void displayDate() {
  M5.Lcd.setTextColor(WHITE, BLACK);
  M5.Lcd.setTextSize(1);
  M5.Rtc.GetTime(&RTC_TimeStruct);
  M5.Rtc.GetData(&RTC_DateStruct);
  M5.Lcd.printf("%04d-%02d-%02d  %02d:%02d:%02d\n", RTC_DateStruct.Year,     RTC_DateStruct.Month, RTC_DateStruct.Date, RTC_TimeStruct.Hours, RTC_TimeStruct.Minutes, RTC_TimeStruct.Seconds);

}
