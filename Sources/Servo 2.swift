/*
 PCA9685

 Copyright (c) 2018 Nader Rahimizad
 Licensed under the MIT license, as follows:

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.)
 */

#if os(Linux)
    import Glibc
#else
    import Darwin.C
#endif

import SwiftyGPIO

/*
 
 Reference: https://en.wikipedia.org/wiki/Servo_control#Pulse_duration
 http://akizukidenshi.com/download/ds/towerpro/SG90.pdf
 https://servodatabase.com/servo/towerpro
 
 This library can control any servo (e.g.: SG90 servo) motor with a PWM, defaults to 20ms period and duty cycle that represent these positions:
 
 1ms = 5%: -90°, left position
 1.5ms = 7.5%: -90°, middle position
 2ms = 10%: +90°, right position
 
 Your servo could have slightly different settings (1-2% difference),
 play around with the values in the Position enum (expressed in percentage)
 to find the right duty cycles for your servo.
 /Volumes/pi/SwiftyServo/CONTRIBUTING.md
 */

public class Servo{
    var pwm: PCA9685
    
    public var frequency: UInt {
        didSet {
            self.onFrequencyChanged()
        }
    }
    
    // Depending on your servo make, the pulse width min and max may vary, you
    // want these to be as small/large as possible without hitting the hard stop
    // for max range. You'll have to tweak them as necessary to match your servo
    var servoMin = 150 // this is the 'minimum' pulse length count (out of 4096)
    var servoMax = 600 // this is the 'maximum' pulse length count (out of 4096)
    
    public init(_ supportedBoard: SupportedBoard = .RaspberryPi3) {
        self.pwm = PCA9685(supportedBoard: supportedBoard)
        
        // This sets the frequency for all channels
        // Range: 24 - 1526 Hz
        // Analog servos run at ~60 Hz updates
        self.frequency = 1440
    }
    
    // you can use this function if you'd like to set the pulse length in seconds
    // e.g. pulse(0, 0.001) is a ~1 millisecond pulse width. its not precise!
    public func pulse(_ channel: UInt8 = 0, pulse: Int) {
        var pulselength: Int;
        var puleMicroSeconds: Int
        
        pulselength = 1000000;   // 1,000,000 us per second
        pulselength = pulselength / 60;   // 60 Hz
        pulselength = pulselength / 4096;  // 12 bits of resolution
        puleMicroSeconds = pulse * 1000000;  // convert to us
        puleMicroSeconds = puleMicroSeconds / pulselength;
        self.pwm.setChannel(channel, onStep: 0, offStep: UInt16(puleMicroSeconds))
    }
    
    /*
       Writes a value to the servo, controlling the shaft accordingly. On a standard servo, this will set the angle of the shaft
       (in degrees), moving the shaft to that orientation. On a continuous rotation servo, this will set the speed of the servo
       (with 0 being full-speed in one direction, 180 being full speed in the other, and a value near 90 being no movement).
     */
    public func angle(_ channel: UInt8 = 0, angle: Int = 0) {
        guard channel < 16 else { fatalError("angle must be 0-180 degrees") }
        
        var angleDegrees = angle
        // Can set an individual channel's on and off steps.
        // Range: 0 - 4095 Steps
        // Example: ~50% Duty Cycle
        if angle < 0 { angleDegrees = 0 }
        if angle > 180 { angleDegrees = 180 }
        let value = (angleDegrees - servoMin)/(servoMax - servoMin)
        self.pwm.setChannel(channel, onStep: 0, offStep: UInt16(value))
    }
    
    func onFrequencyChanged() {
        self.pwm.frequency = frequency
    }
}
