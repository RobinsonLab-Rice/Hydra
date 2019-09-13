
/* WS2812Serial derived control program
 *  Ben Avants 2018
 *  
 *  MAX unsigned long value: 4,294,967,295
 *  This is 1 hour, 11 minutes, and 34.967295 seconds max
 *  Please limit timing delays to 1 hour to be sure not to have a problem with rollover
*/
#include <WS2812Serial.h>

const int numleds = 210;
const int sigpin = 24;

// Usable pins:
//   Teensy LC:   1, 4, 5, 24
//   Teensy 3.2:  1, 5, 8, 10, 20, 31
//   Teensy 3.5:  1, 5, 8, 10, 20, 26, 32, 33, 48
//   Teensy 3.6:  1, 5, 8, 10, 20, 26, 32, 33

byte drawingMemory[numleds*3];         //  3 bytes per LED
DMAMEM byte displayMemory[numleds*12]; // 12 bytes per LED

WS2812Serial leds(numleds, displayMemory, drawingMemory, sigpin, WS2812_GRB);

// Blink time count
boolean doBlink = true;
unsigned long lastBlink = 0ul;
unsigned long loopMicros = 0ul;

// Serial input holder
String message = "";

// More intense...
/*
#define RED    0xFF0000
#define GREEN  0x00FF00
#define BLUE   0x0000FF
#define YELLOW 0xFFFF00
#define PINK   0xFF1088
#define ORANGE 0xE05800
#define WHITE  0xFFFFFF
*/

// Less intense...
#define RED    0x160000
#define GREEN  0x001600
#define BLUE   0x000016
#define YELLOW 0x101400
#define PINK   0x120009
#define ORANGE 0x100400
//#define WHITE  0x101010

// Variables for "White" intensity ratios - value between 0 and 1
double WhiteR = 1;
double WhiteG = 0.6275;
double WhiteB = 0.55;

// Bytes for currently selected color - used for dimming, gradients, programming blocks of LEDs (like whole rows)
uint8_t currentR = 32;
uint8_t currentG = 0;
uint8_t currentB = 0;

// Bytes for Flash color - used for light stimulus
uint8_t flashR = 0;
uint8_t flashG = 0;
uint8_t flashB = 230;

// Flash time count
boolean doFlash = false;
unsigned long lastStimulation = 0ul;
unsigned long lastFlash = 0ul;
unsigned long stimPeriod = 3600000000ul; // initially 3,600,000,000 microseconds or 1 hour
unsigned long pulseDuration = 60000000ul; // initially 60,000,000 microseconds or 1 minute
unsigned long flashPeriod = 1000000ul; // initially 1,000,000 microseconds or 1 second
boolean Flashing = false;
boolean FlashOn = false;

// Variables to deal with rows and striping
// numled (above) must be a multiple of <LEDsPerRow * numberOfRows>, ie. <10 * 5> = 50 => numled = [50, 100, 150, ...]
int LEDsPerRow = 10;
int numberOfRows = 10;
boolean RowsAlternate = true;

void setup() {
  pinMode(13,OUTPUT);
  digitalWriteFast(13,HIGH);
  leds.begin();
  for (int i=0; i < numleds; i++) {
    leds.setPixel(i, RED);
  }
  leds.show();
  digitalWriteFast(13,LOW);
  message.reserve(65);
  Serial.begin(250000);
}

void loop() {
  loopMicros = micros();
  if (doBlink && loopMicros - lastBlink >= 500000) {
    digitalWriteFast(13,!digitalReadFast(13));
    lastBlink = loopMicros;
  }
  if (doFlash && loopMicros - lastStimulation >= stimPeriod) {
    Flashing = true;
    lastStimulation = loopMicros;
    lastFlash = loopMicros;
    // load Flash color to all LEDs
    for (int i=0; i < leds.numPixels(); i++) {
      leds.setPixel(i,flashR,flashG,flashB);
    }
    leds.show();
    FlashOn = true;
  }
  if (Flashing) {
    if (loopMicros - lastFlash >= flashPeriod)  {
      lastFlash = loopMicros;
      if (FlashOn)  {
        for (int i=0; i < leds.numPixels(); i++) {
          leds.setPixel(i,currentR,currentG,currentB);
        }
        leds.show();
        FlashOn = false;
      }
      else  {
        for (int i=0; i < leds.numPixels(); i++) {
          leds.setPixel(i,flashR,flashG,flashB);
        }
        leds.show();
        FlashOn = true;
        if (!doFlash) {
          FlashOn = false;
          Flashing = false;
        }
      }
    }
    if (loopMicros - lastStimulation > pulseDuration) {
      for (int i=0; i < leds.numPixels(); i++) {
        leds.setPixel(i,currentR,currentG,currentB);
      }
      leds.show();
      FlashOn = false;
      Flashing = false;
    }
  }
  if (Serial.available()) {
    message = "";
    for (char ii = 0; ii < 65; ii++)  {
      char c = Serial.read();
      if (c != 10)  {
        message += c;
        if (message.length() == 64) {
          break;
        }
      }
      else {
        break;
      }
    }
    parseMessage();
    message = "";
  }
}

void parseMessage() {
  if (message.startsWith("setall")) {
    //Serial.println("made it to setall");
    int ind = message.indexOf(':',6);
    if (ind > 0) {
      int c1 = message.indexOf(',',ind+1);
      if (c1 > 0) {
        int c2 = message.indexOf(',',c1+1);
        currentR = message.substring(ind+1).toInt();
        currentG = message.substring(c1+1).toInt();
        currentB = message.substring(c2+1).toInt();
        for (int i=0; i < numleds; i++) {
          leds.setPixel(i,currentR,currentG,currentB);
        }
        leds.show();
        Serial.print(currentR);
        Serial.print(", ");
        Serial.print(currentG);
        Serial.print(", ");
        Serial.println(currentB);
      }
      else  {
        int val = message.substring(ind+1).toInt();
        if (val > -1) {
          for (int i=0; i < numleds; i++) {
            leds.setPixel(i, val);
          }
          leds.show();
          Serial.println(val);
        }
      }
    }
  }
  else if (message.startsWith("setone")) {
    int ind1 = message.indexOf(':',6);
    int ind2 = message.indexOf('-',8);
    if (ind1 > 0 && ind2 > 0) {
      int led = message.substring(ind1+1,ind2).toInt();
      int c1 = message.indexOf(',',ind2+1);
      if (led > -1 && led <= leds.numPixels()) {
        if (c1 > 0) {
          int c2 = message.indexOf(',',c1+1);
          uint8_t r = message.substring(ind2+1).toInt();
          uint8_t g = message.substring(c1+1).toInt();
          uint8_t b = message.substring(c2+1).toInt();
          leds.setPixel(led,r,g,b);
        }
        else  {
          int val = message.substring(ind2+1).toInt();
          leds.setPixel(led, val);
        }
      }
    }
  }
  else if (message.startsWith("update")) {
    leds.show();
    Serial.println("Updated");
  }
  else if (message.startsWith("blink")) {
    int ind = message.indexOf(':',5);
    if (ind > 0) {
      int val = message.substring(ind+1).toInt();
      if (val > 0)  {
        if (!doBlink) {
          doBlink = true;
          digitalWriteFast(13,HIGH);
          lastBlink = loopMicros;
        }
      }
      else  {
        doBlink = false;
        digitalWriteFast(13,LOW);
      }
    }
  }
  else if (message.startsWith("flash:")) {
    int ind = message.indexOf(':',5);
    if (ind > 0) {
      int val = message.substring(ind+1).toInt();
      if (val > 0)  {
        if (!doFlash) {
          doFlash = true;
          lastStimulation = loopMicros - stimPeriod;
        }
      }
      else  {
        doFlash = false;
      }
    }
  }
  else if (message.startsWith("ID")) {
    Serial.println("Teensy LC - WS2812 Driver");
  }
  else if (message.startsWith("currentwhite")) {
    int ind = message.indexOf(':',12);
    double dimValue = 1;
    if (ind > 0) {
      dimValue = message.substring(ind+1).toFloat();
      if (dimValue < 0) {
        dimValue = 0;
      }
      else if (dimValue > 1)  {
        dimValue = 1;
      }
    }
    else {
      
    }
    currentR = round(WhiteR * dimValue * 255);
    currentG = round(WhiteG * dimValue * 255);
    currentB = round(WhiteB * dimValue * 255);
    Serial.print("Current color set to white at intensity of ");
    Serial.println(dimValue);
  }
  else if (message.startsWith("setwhite")) {
    int ind = message.indexOf(':',8);
    if (ind > 0) {
      int c1 = message.indexOf(',',ind+1);
      if (c1 > 0) {
        int c2 = message.indexOf(',',c1+1);
        if (c2 > 0) {
          WhiteR = message.substring(ind+1).toFloat();
          WhiteG = message.substring(c1+1).toFloat();
          WhiteB = message.substring(c2+1).toFloat();
          Serial.print("White color ratios set to: ");
          Serial.print(WhiteR);
          Serial.print(", ");
          Serial.print(WhiteG);
          Serial.print(", ");
          Serial.println(WhiteB);
        }
        else  {
          Serial.println("Message error, bad format");
        }
      }
      else  {
        Serial.println("Message error, bad format");
      }
    }
    else {
      Serial.println("Message error, bad format");
    }
  }
  else if (message.startsWith("currentcolor")) {
    int ind = message.indexOf(':',12);
    if (ind > 0) {
      int c1 = message.indexOf(',',ind+1);
      if (c1 > 0) {
        int c2 = message.indexOf(',',c1+1);
        if (c2 > 0) {
          currentR = message.substring(ind+1).toFloat();
          currentG = message.substring(c1+1).toFloat();
          currentB = message.substring(c2+1).toFloat();
          Serial.print("Current color ratios set to: ");
          Serial.print(currentR);
          Serial.print(", ");
          Serial.print(currentG);
          Serial.print(", ");
          Serial.println(currentB);
        }
        else  {
          Serial.println("Message error, bad format");
        }
      }
      else  {
        Serial.println("Message error, bad format");
      }
    }
    else {
      Serial.println("Message error, bad format");
    }
  }
  else if (message.startsWith("flashcolor:")) {
    //Serial.println("Made it to flash: ");
    int ind = message.indexOf(':',10);
    if (ind > 0) {
      int c1 = message.indexOf(',',ind+1);
      if (c1 > 0) {
        int c2 = message.indexOf(',',c1+1);
        if (c2 > 0) {
          flashR = message.substring(ind+1).toFloat();
          flashG = message.substring(c1+1).toFloat();
          flashB = message.substring(c2+1).toFloat();
          Serial.print("Stim color values set to: ");
          Serial.print(flashR);
          Serial.print(", ");
          Serial.print(flashG);
          Serial.print(", ");
          Serial.println(flashB);
        }
        else  {
          Serial.println("Message error, bad format");
        }
      }
      else  {
        Serial.println("Message error, bad format");
      }
    }
    else {
      Serial.println("Message error, bad format");
    }
  }
  else if (message.startsWith("gradient1")) {
    int ind = message.indexOf(':',9);
    double dimValue = 1 / numberOfRows;
    if (ind > 0) {
      dimValue = message.substring(ind+1).toFloat();
      if (dimValue < 0) {
        dimValue = 0;
      }
      else if (dimValue > 1)  {
        dimValue = 1;
      }
    }
    else {
      
    }
    Gradient1(dimValue);
    Serial.println("Gradient 1 set");
  }
  else if (message.startsWith("stimperiod")) {
    int ind = message.indexOf(':',10);
    if (ind > 0) {
      double val = message.substring(ind+1).toFloat();
      stimPeriod = (unsigned long) (val * 3600000000.0);
      Serial.print("Stimulation Period set to: ");
      Serial.println(stimPeriod);
    }
    else {
      Serial.println("Message error, bad format");
    }
  }
  else if (message.startsWith("flashperiod")) {
    int ind = message.indexOf(':',11);
    if (ind > 0) {
      double val = message.substring(ind+1).toFloat();
      flashPeriod = (unsigned long) (val * 1000000.0);
      Serial.print("Flash Period set to: ");
      Serial.println(flashPeriod);
    }
    else {
      Serial.println("Message error, bad format");
    }
  }
  else if (message.startsWith("pulseduration")) {
    int ind = message.indexOf(':',13);
    if (ind > 0) {
      double val = message.substring(ind+1).toFloat();
      pulseDuration = (unsigned long) (val * 60000000.0);
      Serial.print("Pulse duration set to: ");
      Serial.println(pulseDuration);
    }
    else {
      Serial.println("Message error, bad format");
    }
  }
//  else if (message.startsWith("")) {
//    
//  }
  else  {
    Serial.print("Command Unrecognized: <");
    Serial.print(message);
    Serial.println(">");
  }
}

void Gradient1(double dimValue)  {
  uint8_t r = currentR;
  uint8_t g = currentG;
  uint8_t b = currentB;
  for (int ii = 0; ii < numleds; ii++) {
    if (ii%LEDsPerRow == 0) {
      r = round(r*dimValue);
      g = round(g*dimValue);
      b = round(b*dimValue);
    }
    if (ii%(LEDsPerRow*numberOfRows) == 0)  {
      r = currentR;
      g = currentG;
      b = currentB;
    }
    leds.setPixel(ii,r,g,b);
  }
  leds.show();
}



