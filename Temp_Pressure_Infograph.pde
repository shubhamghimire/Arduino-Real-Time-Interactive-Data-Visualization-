/*
 Project:     Temperature and relative humidity logger 
 Description: Receives temperature and relative humidity bytes from USB-UART port and displays the
              temperature on a graphics window. It also provides Start/Stop button 
              for logging the temperature samples.

*/

//import Serial communication library
import processing.serial.*;

// Declare variable "a" and "b: of type PImage. "a" is for waterdrop and "b" is for altitude image.
PImage a, b;  

// Variable declaration
PFont font22, font44, font48;
PFont font12;
float tempC, tempF, RH, Pressure, Pascal, Altitude;
float y, h, MS_Byte, LS_Byte, PS_Byte, AL_Byte;
float m, n;
Serial boardPort;
PrintWriter output;
int[] PC_Time = new int[3];
int[] MM_DD_YY = new int[3];
int i, j, xx=-15;
String curr_time, X_Time, curr_date, row_data, filename;

//variables for displaying time on infograph
int[] LPC_Time = new int[3];
int[] YY_MM_DD = new int[3];


// Button
int rectX, rectY;      // Position of square button
int rectSize = 90;     // Diameter of rect
color rectColor, baseColor;
color rectHighlight;
color currentColor;
boolean rectOver = false, data_logg = false ;


void setup() {

// Define size of window
size(900,350);

  //setup fonts for use throughout the application
  font22 = loadFont("MicrosoftYaHei-22.vlw");
  font12 = loadFont("MicrosoftYaHei-12.vlw");  
  font44 = loadFont("FranklinGothic-Demi-32.vlw");
  font48 = loadFont("GillSansMT-48.vlw");
  //init serial communication port
  boardPort = new Serial(this, "COM7", 115200);
  
  smooth();
  rectColor = color(0, 90, 140);
  rectHighlight = color(80);
  rectX = 240;
  rectY = 270;
  ellipseMode(CENTER);
  
  a=loadImage("Icons/waterdrop.jpg");
  b=loadImage("Icons/plt.png");
 
}

void draw() {
 
 while (boardPort.available() > 0)
 {
  
  String data = boardPort.readStringUntil('\n'); // read data from serial port and store it to string value
  if (data != null) // the loop runs when data is not empty
  {
    data = trim(data); // try to sanitize whitespace away from input
    float[] temp = float(split(data, ","));
    try { 
      MS_Byte = temp[0];  //Humidity data value
      LS_Byte = temp[1];  //Temperature data value in Centigrade
      PS_Byte = temp[2];  //Pressure data value in mbar
      AL_Byte = temp[3];  //Altitude from sea level
    }
    catch(Exception ex) {
      println("Error parsing data"); // in case the value can’t store in float, print out error
      println(ex);
      LS_Byte = -1;
    }
    println(MS_Byte + " " + LS_Byte + " " + PS_Byte + " " + AL_Byte); // print value from serial port
  }

 

 
 
 // Temp thermometer display
 
 background(255, 255, 255); 
 fill(200, 6, 0);
 smooth();
 stroke(0);
 strokeWeight(2);
 ellipse(100, 280, 58, 50);
 noStroke();
 fill(0, 46, 200);
 arc(100, 60, 30, 20, PI, PI+PI);
 rect(85,60,30,200);
 // Capillary
 fill(250,250, 250);
 //stroke(0);
 rect(95,60,10,200);

 //Waterdrop and mountain image properties
 
 image(a, 180, 130);
 image(b, 610, 120);
 b.resize(80,100);

// Pressure thermometer display

 fill(0,46,250);
 smooth();
 stroke(0);
 strokeWeight(2);
 ellipse(500, 280, 58, 50);
 noStroke();
 fill(0,0,0);
 arc(500, 60, 30, 20, PI, PI+PI);
 rect(485,60,30,200);
 // Capillary
 fill(250,250, 250);
 //stroke(0);
 rect(495,60,10,200);


 // Marks on Temp thermometer
 
 stroke(0);
 strokeWeight(1);
 // Fahrenheit
 textAlign(RIGHT);
 fill(0,46,250);
 for (int i = 0; i < 5; i += 1) {
  line(70, 230-40*i, 80, 230-40*i);
  if(i < 4) line(75, 210-40*i, 80, 210-40*i);
  textFont(font12); 
  text(str(40+20*i), 65, 235-40*i); 
 }
 // Centigrade
 textAlign(LEFT);
 for (int i = 0; i < 6; i += 1) {
  line(118, 242-35*i, 128, 242-35*i);
  if(i < 5) line(118, 225-35*i, 123, 225-35*i);
  textFont(font12); 
  text(str(0+10*i), 135, 247-35*i);
 }
 
 
 // Marks on Pressure Thermometer
 
 stroke(0);
 strokeWeight(1);
 //Pascal
 textAlign(RIGHT);
 fill(200,6,0);
 for (int i = 0; i < 6; i += 1) {
  line(470, 242-35*i, 480, 242-35*i);
  if(i < 5) line(475, 225-35*i, 480, 225-35*i);
  textFont(font12); 
  text(str(5000+2000*i), 465, 247-35*i); 
 }
 // mbar
 textAlign(LEFT);
 for (int i = 0; i < 6; i += 1) {
  line(518, 242-35*i, 528, 242-35*i);
  if(i < 5) line(518, 225-35*i, 523, 225-35*i);
  textFont(font12); 
  text(str(500+200*i), 535, 247-35*i);
 }
 
 
 // Text font Temp Thermometer
 
 noStroke();
 fill(0,46,250);
 textFont(font22); 
 textAlign(LEFT);
 text("F", 57, 46);
 text("C", 135, 46);
 textFont(font12);
 text("o", 45, 35);
 text("o", 125, 35);
 
 // Temperature Degree text
 fill(0,102,153);
 textFont(font22);
 text("o", 300+xx, 45);
 text("o", 300+xx, 85);

 // Text font pressure Thermometer
 fill(0,46,250);
 textFont(font22); 
 textAlign(LEFT);
 text("Pa", 440, 42);
 text("mbar", 520, 42);


 

 // BME
 tempC = LS_Byte;
 RH = MS_Byte;
 tempF = ((tempC*9)/5) + 32;   //Centigrade to Fahrenheit conversion
 Pressure = PS_Byte;
 Pascal = Pressure * 100;     // mbar to pascal conversion
 Altitude = AL_Byte;
 
 // Print Temperature Status
 fill(0,102,153);
 textFont(font44); 
 text(nfc(tempC, 1), 220+xx, 60);
 text(nfc(tempF, 1), 220+xx, 100);
 text("C", 320+xx, 60);
 text("F", 320+xx, 100);
 
 // Print Relative Humidity
 textFont(font48);
 text(nfc(RH, 1), 240, 190);
 text("%",325 , 190);
 
 //Print Altitude
 textFont(font48);
 text(nfc(Altitude, 1), 695, 185);
 text("m", 800, 185);
 
 // Print Pressure Status
 textFont(font44); 
 text(nfc(Pressure, 2), 630+xx, 100);
 text(nfc(Pascal, 0), 630+xx, 60);
 text("mbar", 765+xx, 100);
 text("Pa", 765+xx, 60);
 
 // Date and Time Status on infograph
 fill(0,90,140);
 rect(615,245,280,100);
 textFont(font44);
 fill(49, 222, 61);
 text(LPC_Date(), 650, 285);
 text(LPC_Time(), 675, 325);
 
 
 
 // Raise mercury level of Temp Thermometer
 fill(200,0, 0);
 y = -2.0*tempF + 310;
 h = 270-y;
 rect(95, y, 10, h);


 // Raise mercury level of Pressure Thermometer
 fill(0, 46, 250);
 m = -0.156 * Pressure + 310;
 n = 270-m;
 rect(495, m, 10, n);

 
 curr_time = PC_Time();
 curr_date = PC_Date();
 println(curr_date);

 if (data_logg){
 row_data = curr_date + "  "+ curr_time + "  " + nfc(tempC, 1) + "  " + nfc(tempF, 1) + "  " + nfc(RH, 2) + "    " + nfc(Pressure,1)+ "           " + nfc(Altitude,2);
 println(row_data); 
 output.println(row_data); 
 }
}  


update(mouseX, mouseY);
  if(rectOver) {
    fill(rectHighlight);
  } else {
    fill(rectColor);
  }
  stroke(210);
  rect(rectX, rectY, rectSize, rectSize-45);
  textFont(font12);
  textSize(14);
  if(data_logg){
   fill(250,255,252);
   
   text("Stop Log", rectX+15, rectY+25);
  }
  if(!data_logg){
  fill(250,255,252);
  text("Start Log", rectX+15, rectY+25);
  }
 
}

void update(int x, int y)
{
  if ( overRect(rectX, rectY, rectSize, rectSize-45) ) {
    rectOver = true;
    } else {
    rectOver = false;
  }
}

void mousePressed()
{
  if(rectOver) {
    if(data_logg){
     data_logg = false;
     output.flush(); // Write the remaining data
     output.close(); // Finish the file

  } else {
    data_logg = true;
   // Create a new file in the sketch directory
   curr_date = PC_Date();
   curr_time = PC_Time();
   String[] temp = split(curr_date, "  ");
   filename = "DataLogger_"+join(temp, "");
   temp = split(curr_time, "  ");
   filename = filename+join(temp, "")+".txt";
   output = createWriter(filename);
   output.println("MM  DD  YYYY  HH  MM  SS    C     F   RH(%)   Pressure(mbar)  Altitude(m)");
      
  }
  }
}

boolean overRect(int x, int y, int width, int height) 
{
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}
// For the timestamp in data logging text file
String PC_Time()
{
  
 PC_Time[2] = second();  // Values from 0 - 59
 PC_Time[1] = minute();  // Values from 0 - 59
 PC_Time[0] = hour();    // Values from 0 - 23
 return join(nf(PC_Time, 2), "  ");

}

// For the datestamp in data logging text file
String PC_Date()
{
  
 MM_DD_YY[2] = year();  
 MM_DD_YY[1] = day();  
 MM_DD_YY[0] = month();   
 return join(nf(MM_DD_YY, 2), "  ");
}

//For the timestamp shown in infographic
String LPC_Time()
{
  
 LPC_Time[2] = second();  // Values from 0 - 59
 LPC_Time[1] = minute();  // Values from 0 - 59
 LPC_Time[0] = hour();    // Values from 0 - 23
 return join(nf(LPC_Time, 2), " : ");

}

// For the datestamp shown in infographic
String LPC_Date()
{
  
 YY_MM_DD[2] = year();  
 YY_MM_DD[1] = day();  
 YY_MM_DD[0] = month();   
 return join(nf(YY_MM_DD, 2), " / ");
}
