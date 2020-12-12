# ![banner](./banner.png)

![GitHub](https://img.shields.io/github/license/Hacktix/gbctv?style=for-the-badge)
![GitHub Release Date](https://img.shields.io/github/release-date/Hacktix/gbctv?label=Latest%20Release&style=for-the-badge)
![GitHub last commit](https://img.shields.io/github/last-commit/Hacktix/gbctv?style=for-the-badge)
![GitHub repo size](https://img.shields.io/github/repo-size/Hacktix/gbctv?style=for-the-badge)

## What's that?
GBCTV is a program which uses the Gameboy Colors infrared interface in order to record and play back IR signals. In essence - this program turns your Gameboy Color into a crappy TV remote!

## How do I use it?
You'll need to use a flashcart in order to get the ROM loaded on your actual device, as running it on an emulator probably wouldn't be very useful. You can grab the newest release [here](https://github.com/Hacktix/gbctv/releases) and simply just start it up.

### Recording Profiles
GBCTV offers a system of "recording profiles". These profiles work as sort of "slots" into which signals can be recorded. When no recording is in progress, the profile number can be switched by pressing left and right on the D-Pad.

### Recording Signals
Press the A button once prompted to start an IR recording. The program waits for an incoming IR signal before starting the recording. If the small recording-dot icon disappears before any signal was provided there was most likely some sort of interference. In this case, just hit A again until it records the signal properly. The recording overwrites anything else stored in the currently selected profile.

### Playing Back Signals
Pressing the B button (while no recording is in progress) starts playback of the signal stored in the currently selected Recording Profile. Holding down the B button loops this signal over and over.

**Note:** Pressing B before recording any signals will end up sending random signals and may cause unintended side effects. I would recommend against doing this.

## How does it work?
As soon as the A button is pressed, the program waits for an IR signal. Once it receives one it starts dumping the value of the IR register into RAM every few microseconds. The recording initiation mechanism of waiting for a "high" signal isn't an optimal solution as it's triggered by interference as well, but it works fine most of the time and eliminates the need for the user to synchronize button presses down to an accuracy of around 2 milliseconds.

Due to the high sample rate required to record IR pulses that only last up to 10 microseconds, RAM is the limiting factor here. The 8KB of WRAM the Gameboy comes with is enough to record the aforementioned 2 milliseconds of signals, which should be good enough for most remotes, but may not suffice for every purpose imaginable.

## Plans for the future?
Addition of save-able "signal profiles" using cartridge RAM is planned and a feature which allows recording longer signals (~5ms instead of ~2ms) is in consideration, but not decided on yet. Of course, bugfixes and small QoL updates may be pushed at any time.
