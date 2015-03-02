
+++
date = "2012-12-22T00:00:00+11:00"
draft = false
title = "Raspberry Pi Temperature and Humidity Project Construction"
categories = [ "Raspberry Pi", "Hardware" ]

+++

For some time I have had a [Raspberry Pi](http://www.raspberrypi.org/) languishing on my desk, like many I bought one early on and played around with
it for a while and then got busy with other stuff. Recently however I have been looking into distributed sensor networks
which led me to consider how I could use the Raspberry Pi to aid in my research. If I could get a number of these devices
connected up together gathering some measurements of some sort, I could a) make some graphs, b) produce some useful
test data and c) get some real world experience with sensor networks.


So I did a bit of research on what hardware I could connect up to the Raspberry Pi with the least amount of circuitry
this led me to the AdaFruit site and in particular this article [DHT Humidity Sensing on Raspberry Pi with GDocs Logging](http://learn.adafruit.com/dht-humidity-sensing-on-raspberry-pi-with-gdocs-logging/overview).
This was as almost what I was after but still had a little to much "construction". After searching around I managed to
deduce that a small pre-made Arduino compatible board existed with all the circuitry already assembled,  all that remained was
to solder 3 wires onto the board and get this connected to the Raspberry Pi. After some foraging around in my computer
"junk" I found some old case wiring which had small 4 pin connectors which could be plugged into the gpio header and could
have their pins rejigged into any combination of one, two or 4 pin headers for maximum flexibility.

So to build this project you will need the following items, I have included the approximate cost.

* 1 x Raspberry Pi ($42)
* 1 x 700mW power supply ($12)
* 1 x freetronics [Humidity and Temperature Sensor Module](http://www.freetronics.com/humid) ($20)
* 2 x 4 pin connectors, as found in old PC cases or CD drive audio cables

Total cost $74.

Assembly is quite simple.

Solder three wires into the freetronics board, in my case I had red which i soldered into the data pin, white which
I soldered into the 3.3v pin and black which I soldered into the ground pin.

![Sensor Connection](/images/2012-12-21_RaspberryPi_Project_Sensor.jpg)

Move the ground wire into it's own 4 pin connector, and put the 3.3v and data pins at either end of another 4 port connector.

![Four pin Connectors](/images/2012-12-21_RaspberryPi_Project_Connectors.jpg)

Connect these as illustrated to the Raspberry Pi, being sure to triple check the location.

![Connected to the Raspberry Pi](/images/2012-12-21_RaspberryPi_Project_Connection.jpg)

Bask in the glow of the little LED on the addon board which indicates you have powered it up.

![Finished project connected to the network](/images/2012-12-21_RaspberryPi_Project.jpg)

First you will need to grab and install the bcm2835 library before building it. I grabbed the latest sources for
[Mike McCauley's bcm2835 library](http://www.open.com.au/mikem/bcm2835/) and installed them on the pi.

{{< highlight bash >}}
pi@raspberrypi ~ $ wget http://www.open.com.au/mikem/bcm2835/bcm2835-1.14.tar.gz
pi@raspberrypi ~ $ tar xvzf bcm2835-1.14.tar.gz
pi@raspberrypi ~ $ cd bcm2835-1.14
pi@raspberrypi ~/bcm2835-1.14 $ ./configure
pi@raspberrypi ~/bcm2835-1.14 $ make
...
pi@raspberrypi ~/bcm2835-1.14 $ sudo make install
{{< /highlight >}}

Download the software as instructed in the linked ADAFruit article, you will need git so install that first.

{{< highlight bash >}}
pi@raspberrypi ~ $ apt-get install git
pi@raspberrypi ~ $ git clone https://github.com/adafruit/Adafruit-Raspberry-Pi-Python-Code.git
pi@raspberrypi ~ $ cd Adafruit-Raspberry-Pi-Python-Code/
pi@raspberrypi ~/Adafruit-Raspberry-Pi-Python-Code $ cd Adafruit_DHT_Driver
{{< /highlight >}}

Build the software.

{{< highlight bash >}}
pi@raspberrypi ~/Adafruit-Raspberry-Pi-Python-Code/Adafruit_DHT_Driver $ make
{{< /highlight >}}

Run the Adafruit_DHT command.

{{< highlight bash >}}
pi@raspberrypi ~/Adafruit-Raspberry-Pi-Python-Code/Adafruit_DHT_Driver $ sudo ./Adafruit_DHT 2302 4
Adafruit_DHT 2302 4
Using pin #4
Data (40): 0x2 0x3e 0x0 0xde 0x1e
Temp =  22.2 *C, Hum = 57.4 %
{{< /highlight >}}

I am working on another post with some details of how I am using this device, and the software I will be driving it with,
this should go out in the next couple of weeks.

Hope others find this useful.

Update
-------------

`2013-02-28` Removed the change to small change to the make file as it is not required anymore.