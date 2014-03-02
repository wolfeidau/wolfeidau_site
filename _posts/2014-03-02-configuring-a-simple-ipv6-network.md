---
layout: post
title: Configuring a simple IPv6 network
tags:
  - Contiki
  - IPv6
  - ATmega256RFR2
  - 6lowpan
---

Recently I have been helping [Andy Gelme](https://twitter.com/geekscape) with a project which uses [contiki-os](contiki-os.org), and [6lowpan](http://en.wikipedia.org/wiki/6LoWPAN). This required us to setup a small [IPv6](http://en.wikipedia.org/wiki/IPv6) network from scratch, independent of the internet, this turned out to be quite a bit different an objective of most of the how to's we found so I decided to document our method, as much for others as myself.

In our case the network looked as follows:

![Simple Network](/images/ipv6lan.png "Simple Network")

In this diagram we have macbook A which is connected to a Mesh Thing running contiki-os connected via serial over USB. The ipv6 connection is provided by `slip6`, which gives use a point to point link over the serial connection. The command to start `tunslip6` is as follows:

{% highlight text %}
sudo ./tunslip6 -B 38400 -s /dev/tty.usbmodem1411 aaaa::1/64
********SLIP started on ``/dev/tty.usbmodem1411''
opened tun device ``/dev/tun0''
ifconfig tun0 inet6 up
ifconfig tun0 inet6 aaaa::1/64 add
sysctl -w net.inet6.ip6.forwarding=1
net.inet6.ip6.forwarding: 1 -> 1
ifconfig tun0

tun0: flags=8851<UP,POINTOPOINT,RUNNING,SIMPLEX,MULTICAST> mtu 1500
	inet6 fe80::bae8:56ff:ffff:ffff%tun0 prefixlen 64 optimistic scopeid 0xc
	inet6 aaaa::1 prefixlen 64 tentative
	nd6 options=1<PERFORMNUD>
	open (pid 51393)
RPL started
Online
*** Address:aaaa::1 => aaaa:0000:0000:0000
Got configuration message of type P
Setting prefix aaaa::
Server IPv6 addresses:
 aaaa::11:22ff:ffff:ffff
 fe80::11:22ff:ffff:ffff
{% endhighlight %}

So this command, for those not aware is using my USB serial device, running at 38400 baud to establish a link to the device.

At the end of this command we are providing a prefix of `aaaa::1/64`, which enables the device to pick it's own IPv6 address using [Stateless Address Autoconfiguration](http://en.wikipedia.org/wiki/IPv6#Stateless_address_autoconfiguration_.28SLAAC.29) (SLAAC). It is important to note that this means the prefix needs to use a `/64` mask.

Now as we can see in our original diagram we now need to route packets between the `aaaa::1/64` network assigned to our mesh.

Given we need to enable routing between macbook B and the Mesh Thing we need the local wireless network to provide an IPv6 prefix for auto configuration of this host.

As macbook B is going to be routing we will get it to advertise our prefix of `bbbb::1/64` on the existing wireless lan.

This is done using `rtadvd` in BSD derivatives, and `rdvd` on linux. So to get this running on OSX edit your `/etc/rtadvd.conf` as root, and add the following line.

{% highlight text %}
en1:\
 :addr="bbbb::1":prefixlen#64:
{% endhighlight %}

On linux we can use `radvd`, which can be installed via `apt-get` on ubuntu. This is configured via `/etc/radvd.conf` with the equivalent configuration below.

{% highlight text %}
interface eth1 {
  ## (Send advertisement messages to other hosts)
  AdvSendAdvert on;
  ## IPv6 subnet prefix
  prefix bbbb::1::/64 {
    AdvOnLink on;
    AdvAutonomous on;
  };
};
{% endhighlight %}

So in this case we are using en1 on macbook A is the wireless interface. We start `rtadvd`, this will after about 4 seconds send out a route advertisement which will trigger auto-configuration of all hosts on wireless network, therefore providing a prefix to macbook B which it will used by SLAAC to generate an IPv6 address.

To check our configuration worked correctly, first thing you will notice is that all hosts on the lan now have an IPv6 address in the prefix range.

{% highlight text %}
[~]$ ifconfig en0 | grep inet6
	inet6 fe80::bae8:56ff:ffff:ffff%en0 prefixlen 64 scopeid 0x4
	inet6 bbbb::bae8:56ff:ffff:ffff prefixlen 64 autoconf
	inet6 bbbb::615e:319:aaaa:aaaa prefixlen 64 autoconf temporary
{% endhighlight %}

So in order these adresses are:

* Link Local address, these always begin with `fe80::` and also includes our MAC address of `b8:e8:56:ff:ff:ff`.
* SLAAC address, which is a combination of the prefix and our MAC.
* One temporary address, which hides the network card address, this is the one that should be "used by applications", no idea what this means Wireshark says everything on the LAN is using the MAC based IPv6 addresses I need to RTFM (read the fine manual) more.

To see neighbours in OSX you can use `ndp`, the `R` flag in the example below indicates which host is a router.

{% highlight text %}
[~]$ ndp -an
Neighbor                        Linklayer Address  Netif Expire    St Flgs Prbs
bbbb::bae8:56ff:ffff:ffff        b8:e8:56:ff:ff:ff     en0 permanent R
{% endhighlight %}

On linux the equivalent command is `ip -6 neigh show`.

So for Linux, IOS and Android this is all we need to do to provide get the routing to work, however on OSX clients we have one additional step.

As OSX doesn't accept the route advertisements by default, a route solicitation daemon called `rtsold` needs to be running on all client machines aside from the router. Below is the command I ran on macbook B, note on this machine the wireless adapter was `en0`.

{% highlight bash %}
sudo rtsold en0
{% endhighlight %}

Once this is started you should be able to ping the Mesh thing from macbook B on the wireless lan.

{% highlight text %}
[~]$ ping6 aaaa::11:22ff:ffff:ffff
PING6(56=40+8+8 bytes) aaaa::1 --> aaaa::11:22ff:ffff:ffff
16 bytes from aaaa::11:22ff:ffff:ffff, icmp_seq=0 hlim=64 time=34.186 ms
16 bytes from aaaa::11:22ff:ffff:ffff, icmp_seq=1 hlim=64 time=33.553 ms
--- aaaa::11:22ff:fe33:4401 ping6 statistics ---
2 packets transmitted, 2 packets received, 0.0% packet loss
round-trip min/avg/max/std-dev = 33.553/33.870/34.186/0.316 ms
{% endhighlight %}

This is a part of my ongoing hardware hacking, for more details on how this started see [Adding an ICSP header to the ATmega256RFR2 ](http://wolfe.id.au/2013/12/22/adding-an-icsp-header-to-the-atmega256rfr2/). As a note both my [Atmel](atmel.com) board and the Mesh Thing use the ATmega256RFR2 chips.

The next goal is to setup some name services, probably via MDNS, and test accessing the web site (yes on the 8 bit micro controller) from a mobile phone connected to the wireless network.
