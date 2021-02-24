#ifndef CAPTOUCH_H
#define CAPTOUCH_H

#include "Demo.h"

#define CAP_SAMPLES      20   // Number of samples to take for a capacitive touch read.
#define CAP_THRESHOLD    200

class CapTouchDemo: public Demo {
  public:
    uint16_t CAP_THRESHOLD = 200;  // Threshold for a capacitive touch (higher = less sensitive).

    CapTouchDemo() {
      CAP_THRESHOLD = 200;
    }
    ~CapTouchDemo() {}


    virtual void loop() {
      for (int i = 0; i < 10; ++i) {
        CircuitPlayground.strip.setPixelColor(i, 0);
      }

      // Check if any of the cap touch inputs are pressed and turn on those pixels.
      // Also play a tone if in tone playback mode.
      if (CircuitPlayground.readCap(0, CAP_SAMPLES) >= CAP_THRESHOLD) {
        CircuitPlayground.strip.setPixelColor(3, CircuitPlayground.colorWheel(256 / 10 * 3));
      }
      if (CircuitPlayground.readCap(1, CAP_SAMPLES) >= CAP_THRESHOLD) {
        CircuitPlayground.strip.setPixelColor(4, CircuitPlayground.colorWheel(256 / 10 * 4));
      }
      if (CircuitPlayground.readCap(2, CAP_SAMPLES) >= CAP_THRESHOLD) {
        CircuitPlayground.strip.setPixelColor(1, CircuitPlayground.colorWheel(256 / 10));
      }
      if (CircuitPlayground.readCap(3, CAP_SAMPLES) >= CAP_THRESHOLD) {
        CircuitPlayground.strip.setPixelColor(0, CircuitPlayground.colorWheel(0));
      }
      if (CircuitPlayground.readCap(6, CAP_SAMPLES) >= CAP_THRESHOLD) {
        CircuitPlayground.strip.setPixelColor(6, CircuitPlayground.colorWheel(256 / 10 * 6));
      }
      if (CircuitPlayground.readCap(9, CAP_SAMPLES) >= CAP_THRESHOLD) {
        CircuitPlayground.strip.setPixelColor(8, CircuitPlayground.colorWheel(256 / 10 * 8));
      }
      if (CircuitPlayground.readCap(10, CAP_SAMPLES) >= CAP_THRESHOLD) {
        CircuitPlayground.strip.setPixelColor(9, CircuitPlayground.colorWheel(256 / 10 * 9));
      }
      if (CircuitPlayground.readCap(12, CAP_SAMPLES) >= CAP_THRESHOLD) {
        CircuitPlayground.strip.setPixelColor(5, CircuitPlayground.colorWheel(256 / 10 * 5));
      }

      // Light up the pixels.
      CircuitPlayground.strip.show();
    }
};

#endif
