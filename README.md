<p align="center" style="padding-bottom:50px;">
<img src="https://github.com/ezrover/SwiftyServo/raw/master/2327-14.jpg"/>
</p>

# Swifty Adafruit Servo HAT with PCA9685 and I2C

[![Build Status](https://travis-ci.org/ezrover/SwiftyServo.svg?branch=master)](https://travis-ci.org/ezrover/SwiftyServo)
![Swift](https://img.shields.io/badge/Swift-4.1.2-orange.svg)
[![MIT license](http://img.shields.io/badge/license-MIT-brightgreen.svg)](http://opensource.org/licenses/MIT)
![Raspbian](https://img.shields.io/badge/OS-Raspbian%20Stretch-green.svg)

A Swift based Servo driver for the PCA9685 PWM controller over I2C, using SwiftyGPIO.

## Getting Started

A simple example looks like this:

```
// It doesn't really matter what Raspberry Pi Board you use.
let servo = Servo(.RaspberryPi3)
        
// This sets the frequency for all channels
// Range: 24 - 1526 Hz
servo.frequency = 1440 // Hz
        
// 90 degrees
servo.angle(15, angle: 90)
```

## Develop on Mac with Xcode, cross compile with Docker, run on the Raspberry Pi
Tools like VirtualBox are for creating virtual machines. Docker is used to create containers. As explained in the InfoWorld article Containers 101: Linux container and Docker explained. '[containers are] something that feels like a virtual machine, but sheds all the weight and startup overhead of a guest operating system.'

The other thing I like about them is that they are great for running headless. You can fire them up from the command line. Then you can either set them to continue running, or do a job, then exit. You can even interact with them at the command line level.

To compile code all it needs to do is to start, compile our code and then exit.

Mac: We will pull the docker image for cross compiling from Dockerhub
Raspberry Pi: Install Samba and give access to yourself and your Mac
Raspberry Pi: Use git to clone a local copy of this project
Mac: Open the shared Raspberry Pi folder, open example app with Xcode, modify main.swift as needed
Mac: Run the docker container to build the example
Raspberry Pi: Test it on the Pi to make sure it works

## Step 1: Prepare Raspberry Pi for Xcode development
1: Get the latest updates
$ sudo apt-get update

2: Install git, and Samba
$ sudo apt-get install git samba samba-common-bin

3: Configure Samba
$ sudo nano /etc/samba/smb.conf
Find the line that says read only and set it equal to no.

4: Create a Samba password for remote access as user pi.
$ sudo smbpasswd -a pi

5: Stop and restart the Samba server
$ sudo /etc/init.d/samba stop
$ sudo /etc/init.d/samba restart

Copy the file to your Pi
In Finder wait a bit and you should see your Pi show up under Shared in the left hand column. Connect as user pi using the samba password that you just created.

## Shared Volume
One of the neat tricks about Docker is you can start (run) an image with a path parameter using the run -v flag. You can tell it to map a folder on your hard-drive to a folder within the container. Press CMD-Key and Opt-key and dray Pi smb shared forlder to your desktop. Here is a sample docker run command that will map the the shortcut to pi folder /Volumes/pi/SwiftyServo on your Mac to a folder called /home/swift inside the docker image.

#!/bin/sh
docker run -it -v /Volumes/pi/SwiftyServo:/home/swift helje5/rpi-swift-dev bash

If you place a swift project in /Volumes/pi/SwiftyServo on your Mac, you can compile it within an Ubuntu image using this command:

swift build

## Step 2: Install Docker
Go to https://docs.docker.com/engine/installation/ and install Docker.

## Step 3: Pull the Docker image
docker pull helje5/rpi-swift-dev

## Step 4: Clone This Project on your Raspberry Pi
Clone the project into / on your Pi which maps into /Volumes/pi/SwiftyServo on your Mac Desktop with Samba (after you create a shortcut using Cmd+Opt dragging pi to your desktop)

## Step 5: BUILD THE DEMO

#!/bin/sh
Mac:  docker run -it -v /Volumes/pi/SwiftyServo:/home/swift helje5/rpi-swift-dev bash

## STEP 6: RUN THE EXECUTABLE ON YOUR PI
When docker command in step 5 is run, it opens to shell screen in your terminal and you are viewing the shell command of the builtin linux

A new executable should now exist:

Docker Terminal: ~$ ls
2327-14.jpg  CONTRIBUTING.md  Examples	LICENSE  Package.swift	README.md  Sources
Docker Terminal: ~$ swift make
Docker Terminal: ~$ cd Examples
Docker Terminal: ~$ ls
Package.resolved  Package.swift  README.md  Sources  Tests
Docker Terminal: ~$ swift make
Docker Terminal: ~$ ./example


## Built With

* [SwiftyGPIO](https://github.com/uraimo/SwiftyGPIO)
* [Adafruit-PCA9685](https://github.com/adafruit/Adafruit_Python_PCA9685) - Inspiration/Basis of Implementation.
* [PCA9685](https://github.com/Kaiede/PCA9685) - Inspiration/Basis of Implementation.
* [Xcode+Docker](https://hub.docker.com/r/helje5/rpi-swift-dev/) - Develope on Mac with Xcode+Docker, test on RaspberryPi.
* [Cross Compilation](https://desertbot.io/blog/how-to-cross-compile-for-raspberry-pi) - Inspirational.

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

## Authors

* **Adam Thayer** - *Initial work* on [PCA9685](https://github.com/Kaiede/PCA9685)
* **ezRover** - *Integration work* and Xcode development

See also the list of [contributors](https://github.com/Kaiede/RPiLight/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
