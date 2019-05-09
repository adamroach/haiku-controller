# Haiku Controller
Open Hardware Design for Controller for [Big Ass Fan's "Haiku" Fans](https://www.bigassfans.com/for-home/)

*I'm still getting this set up. Please stand by.*

Big Ass Fans has entered the home market with a line of exceptionally efficient
and visually attractive fans. The main (more expensive) *Haiku* line comes standard
with a WiFi interface that allows control from smartphones as well as integration
with home assistants like Amazon Alexa and Google Home. Aside from this, however,
the only way to control the fan is with a line-of-sight IR remote that is easy to
misplace. The lower-end *Haiku L* fans have an
[optional WiFi module](https://store.bigassfans.com/en_us/haiku-wifi-module-for-l-series-ceiling-fan-1)
to provide this integration. They also allow use of an
[in-wall controller](https://store.bigassfans.com/en_us/haiku-wired-wall-control-1)
that sells for $100, and requires the optional WiFi module to be installed.
Oddly, this in-wall controller is not available for the more-expensive *Haiku* line
of fans.

I have one of each kind of fan in my house, and became fed up with the state of
things: to control the fan from both entrances to the bedroom, I would need to
spend an additional $200 on in-wall controllers. And for the 84-inch monster in
the den, there was simply no option for control: I'm stuck with the remote. So
I decided to make my own in-wall controllers.

Luckily, the protocol used to control the fans via WiFi is a very simple, UDP-based
protocol. Even better, someone has already put together a [complete Node.js API
for interfacing with them](https://github.com/sean9keenan/BigAssFansAPI), which
makes our task much easier.

I'm putting my work out in this repository to help other people out who have found
themselves in a similar situation. Even in the worst case, you should end up
spending less than the $100 that the official in-wall controller costs. Plus, if
you're willing to do a little hacking, you can customize things to look and behave
however you want.

I'd love to hear from you if you find this work useful, especially if you make
modifications to either the design or the software. Pull requests will be
graciously accepted.

## Manifest

This is a list of the materials you will need to build a switch. I've included
links to Amazon for any components that are available there. I encourge you to
look around at local maker and hobbiest shops, though, as they frequently have
better prices. Beyond those things listed here, you'll also need a small
quantity of wire, some solder, and a handful of tools like a jewelers'
screwdriver and a soldering iron.

The "Min Cost" column represents the price of the smallest quantity of the
specific item *available from Amazon*, and is meant to represent the maximum
price you'll pay for the materials.  With luck, you'll either have some of
these things lying around, or you'll be able to find them in smaller
quantities than is available from Amazon.

The Pi Zero W is generally available from around $10 online, but can be found
in many brick-and-mortar stores for $5. If you're lucky enough to live near
a [Microcenter](https://www.microcenter.com/), they're a reliable source for
inexpensive Pi Zero W's (and several of the other listed components, too).

If you're replacing an existing switch, re-use its mounting screws to put the
switch in the electrical box. Otherwise, you may need to pick up two #6-32 x 1½"
screws at a local hardware store.


|Quantity|Item                    |Min. Cost|Unit Cost|Source                               |
|-------:|------------------------|--------:|--------:|-------------------------------------|
|       1|PI Zero W               |    $5.00|    $5.00|Source Locally                       |
|       1|16 GB Micro SD          |    $3.00|    $3.00|Source Locally                       |
|    25 g|PLA                     |   $15.99|    $0.40|https://www.amazon.com/dp/B00ME7E5X0/|
|       2|3x7 mm proto boards     |   $11.65|    $0.93|https://www.amazon.com/dp/B07FK3NLFZ/|
|      12|M2x6 screws             |    $8.99|    $0.27|https://www.amazon.com/dp/B07K8G6VF2/|
|       4|1/8th watt 1kΩ resistors|    $6.78|    $0.27|https://www.amazon.com/dp/B0185FIJ9A/|
|       4|6x6x5mm push buttons    |    $6.99|    $0.47|https://www.amazon.com/dp/B07H547BTV/|
|   12 cm|2mm inch shrink tubing  |    $6.99|    $0.09|https://www.amazon.com/dp/B00EXLPLTW/|
|       1|HLK-PM01                |    $9.92|    $4.96|https://www.amazon.com/dp/B073QH1XT8/|
|**Total**|                       |**$75.31**|**$15.39**|                                   |


## Soldering the Components

*TBD*

<p align="center"><img src="images/button-solder-connections.jpg?raw=true" width="50%" height="50%" />
<br /><i>Connecting the Buttons</i></p>

## Printing and Assembling the Switch

If you have a 3D printer, you can either start with the `two-switch.scad` file in the
`scad` directory and render your own model, or you can [download a pre-rendered model
from Thingiverse](https://www.thingiverse.com/thing:3615419). I've designed things so
that you shouldn't have to use any support material. Due to the relatively tight
tolerances, I would recommend using PLA as your material. PETG might work, although
I'm unsure about its ability to make the long bridges necessary for the front plate.
ABS is likely to warp too badly to be usable.

If you don't have a 3D printer, there are [services available via
Thingiverse](https://www.thingiverse.com/apps/3d-print-with-print-a-thing/run?thing_id=3615419)
that will print and ship items to you. The 3D model used for this
project cost around $16 or so via such services when I last checked.


*TBD*

## Setting up the Rasbperry Pi

*TBD*

## Final Installation

*TBD*
