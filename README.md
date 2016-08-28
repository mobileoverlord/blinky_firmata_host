# BlinkyFirmataHost

## Prepare your Arduino
On your arduino load the StandardFirmata code by going to
Arduino -> File -> Examples -> Firmata -> StandardFirmata

Make sure that you set the appropriate serial port for your connection.

```c
Firmata.begin(57600);
while (!Serial) {
  ;
}
```

## Running

Fetch the deps and load the project into IEx

```
$ mix deps.get
$ iex -S mix
```

Connect your Arduino to your computer and in the IEx session enumerate the ports

```
Interactive Elixir (1.3.2) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> Nerves.UART.enumerate
%{"/dev/cu.Bluetooth-Incoming-Port" => %{},
  "/dev/cu.usbmodem1421" => %{manufacturer: "MediaTek Labs", product_id: 43777,
    vendor_id: 3725}}
```

We can see that the Arduino we have that is connected to our LinkIt Smart Duo
is at `/dev/cu.usbmodem1421` lets tell the Firmata protocol to open this port.

```
iex(2)> BlinkyFirmataHost.Protocol.start_link "/dev/cu.usbmodem1421"
Init
{:ok, #PID<0.156.0>}
Set Pin Map
Blink
```

You should now have a Firmata controlled led blinking every 1000ms
