+++
title = "Building a WLToys A979 donkey car"
date = "2019-12-22T15:37:00+10:00"
tags = [ "robots", "development", "machine learning" ]
+++

In my spare time I spend a bit of time building and working on a scaled down self driving RC project which uses an opensource project called [donkeycar](https://github.com/autorope/donkeycar). I have been through a few generations of car, learning how both the hardware and software worked, hopefully I can provide some tips on how to avoid at least some of my mistakes in this post.

![Current Car](/images/2019-12-22-building-a-custom-donkey-car_19.07.18.png)

### Starting Out

Probably the lion share of lessons, at least initially were learnt about how to setup a custom RC car, especially the power and drive train. I have put together a bunch of recommendations:

1. Always buy at least two servos, and check the number of teeth, force, and dimensions carefully.
2. Learn to solder bullet connectors, there are some good tutorials on youtube including on how to get the nice shrink wrapped look.
3. Always use a seperate power supply for the computer on your car, there are a number of reasons you can cause voltage drops during operation of the car, keeping things isolated will avoid the computer crashing and a car running into a wall.
4. Cable ties are a life saver when hiding or stashing cables, buy a good collection of sizes.
5. Start out with brushed motors, they are cheap and work better at low speeds.  

### The Car Build

For the base of my current build I chose the WLToys A979 4WD Truck, this was for a few reasons:

1. Same base as the original [AWS Deepracer](https://aws.amazon.com/deepracer/).
2. Good solid build and lots of spares available online.
3. Short wheelbase and good turning circle so great for use indoors.
4. Cheap and easy to purchase and ship to Australia.
5. Has a brushed motor which is great at low speeds, which is very important indoors and while learning to drive.

You can buy it from [banggood](https://www.banggood.com/Wltoys-A979-118-2_4Gh-4WD-Monster-Truck-p-916960.html?rmmds=buy&ID=229&cur_warehouse=CN) for approx 90 AUD.

Then I replaced the [Electronic Speed controller(ESC)](https://en.wikipedia.org/wiki/Electronic_speed_control) with a [Turnigy 20A BRUSHED ESC](https://hobbyking.com/en_us/turnigy-20a-brushed-esc.html) as the one provided was integrated with the radio and servo using some sort of proprietary setup.

![Motor Wiring](/images/2019-12-22-building-a-custom-donkey-car_16.59.49.png)

Lastly I replaced the servo with a [Turnigy™ S3101S Servo 2.4kg / 0.14sec / 17g 24T](https://hobbyking.com/en_us/turnigytm-s3101s-servo-2-5kg-0-14sec-17g.html).

To connect all this stuff you will need some extra parts.

* Heat shrink such as [Turnigy Heat Shrink Tube 4mm Black](https://hobbyking.com/en_us/turnigy-4mm-heat-shrink-tube-black-1mtr-1.html).
* Bullet connectors such as [4mm Easy Solder Gold Connectors (10 pairs)](https://hobbyking.com/en_us/4mm-easy-solder-gold-connectors-10-pairs.html).
* XT60 connectors which are used to connect 2s batteries such as [Nylon XT60 Connectors Male/Female (5 pairs)](https://hobbyking.com/en_us/nylon-xt60-connectors-male-female-5-pairs-genuine.html).

This will also be useful with any power upgrades such as the one listed down the bottom.

### The Compute Build

To mount the compute on top of the car I used [Dingo-Mount](https://github.com/PancakeLegend/Dingo-Mount) which was cut on a laser cutter at [CCHS](https://www.hackmelbourne.org/) using some 3mm ply wood, which is light and strong.

The hardware I use on top of the car is as follows:

* [Jetson Nano](https://developer.nvidia.com/embedded/jetson-nano-developer-kit) which you can buy from [seeed studio](https://www.seeedstudio.com/NVIDIA-Jetson-Nano-Development-Kit-p-2916.html).
* [Intel 8265.NGWMG.DTX1 DUAL BAND Wireless-AC 8265 Desktop KIT](https://cplonline.com.au/intel-8265-ngwmg-dtx1-dual-band-wireless-ac-8265-desktop-kit.html).
* [Raspberry Pi Camera Module V2](https://www.raspberrypi.org/products/camera-module-v2/) also buy from from [seeed studio](https://www.seeedstudio.com/Raspberry-Pi-Camera-Module-V2-p-2800.html).
* An SSD to store all your data on, and because running this machine off sdcard is very slow. I used a [Crucial BX500 240GB 3D NAND SATA 2.5-inch SSD](https://www.amazon.com.au/Crucial-BX500-240GB-NAND-2-5-inch/dp/B07G3YNLJB/ref=sr_1_4?keywords=ssd+crucial&qid=1576992516&s=computers&sr=1-4).
* A USB to SATA cable such as [Onvian USB 3.0 To SATA 22 Pin 15+7 Pin 2.5 Inch Hard Disk Driver SSD Adapter Data Power Cable](https://www.amazon.com.au/gp/css/summary/edit.html/ref=dp_iou_view_this_order?ie=UTF8&orderID=250-3610443-5463054).
* A USB powerbank such as [18W Power Bank, ROMOSS 20000mAh Portable Charger](https://www.amazon.com.au/ROMOSS-20000mAh-Portable-External-Compatible/dp/B07H3RRZXT/ref=sr_1_4?keywords=USB+Power+bank&qid=1576992675&sr=8-4).

I used some brass standoffs, like these [M2.5 Male Female Hex Brass Spacer Standoff](https://www.amazon.com.au/Sutemribor-Female-Spacer-Standoff-Assortment/dp/B075K3QBMX/ref=sr_1_1?keywords=brass+standoffs&qid=1576992928&sr=8-1) which are similar to the ones you get when you buy a computer case, this enabled me to mount the SSD under my jetson nano, with some rubber acting avoiding the bottom of the board shorting out on the SSD.

![SSD Mounting](/images/2019-12-22-building-a-custom-donkey-car_17.00.46.png)

To drive the servo and ESC I used [Adafruit PCA9685 16-Channel Servo Driver](https://learn.adafruit.com/16-channel-pwm-servo-driver?view=all) which you can get from [Core Electronics](https://core-electronics.com.au/adafruit-16-channel-12-bit-pwm-servo-driver-i2c-interface-pca9685.html) or purchase something similar from [aliexpress](https://www.aliexpress.com/item/33047932849.html?spm=a2g0s.9042311.0.0.2c4f4c4d7mf9h7).

![Camera and Servo Board](/images/2019-12-22-building-a-custom-donkey-car_17.02.14.png)

### Power Options

If you want to use the full power of the Jetson Nano compute then you may need to get your self a SBEC such as [Turnigy 5A (8-40v) SBEC for Lipo](https://hobbyking.com/en_us/turnigy-5a-8-40v-sbec-for-lipo.html) and rig up an extra 2S1P LIPO such as [Turnigy nano-tech 2200mah 2S 25~50C Lipo Pack](https://hobbyking.com/en_us/turnigy-nano-tech-2200mah-2s-25-50c-lipo-pack.html). I use this setup currently to avoid drop outs when doing inference with higher resolution images (224px * 224px). Attached to this is a 2.1mm Barrel Cable I had laying around.

![Power Loop with SBEC](/images/2019-12-22-building-a-custom-donkey-car_17.14.22.png)

## Driving Demonstration

This is my car in auto pilot running around a tight track in the CCHS workshop.

<iframe width="1236" height="695" src="https://www.youtube.com/embed/vrqaF1Nr2qg" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>