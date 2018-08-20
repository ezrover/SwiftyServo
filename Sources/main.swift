    // It doesn't really matter what Raspberry Pi Board you use.
        let servo = Servo(.RaspberryPi3)
        
        // This sets the frequency for all channels
        // Range: 24 - 1526 Hz
        servo.frequency = 1440 // Hz
        
        // 90%
        servo.angle(15, angle: 90)


