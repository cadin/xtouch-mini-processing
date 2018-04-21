# xtouch-mini-processing
A Processing interface for the Behringer X-Touch Mini USB Controller.

This project makes it easy to interface with the X-Touch Mini in Processing. It's a thin wrapper around The MidiBus MIDI library that simplifies addressing and controlling the knobs and buttons on the X-Touch Mini.

## Getting Started


### Prerequisites
You will need three things to make this project work:

1. [Processing 3](https://processing.org/download/) (of course)
2. [Behringer X-Touch Mini USB Controller](https://www.musictri.be/Categories/Behringer/Computer-Audio/Desktop-Controllers/X-TOUCH-MINI/p/P0B3M)
3. [The MidiBus](http://smallbutdigital.com/projects/themidibus/) MIDI library for Processing


### Installing

**Install The MidiBus Library**  
Install The MidiBus library in Processing via the Contribution Manager:  
In the Processing IDE, choose `Sketch > Import Library... > Add Library...`
Find The MidiBus and click `Install`.


**Copy the XTouch Classes to Your Project**  
Copy the `XTouch.pde` from the `dist` folder into the folder for your Processing sketch.



### Usage

First create an instance of the XTouchMini class:
```
XTouchMini xTouch = new XTouchMini();
```

Implement these functions in your sketch to intercept the various hardware events:
```
void knobDidChange(XTKnob knob, float oldValue, float newValue) {
	println("knobDidChange (" + knob.id + "): " + oldValue, newValue);
}

void knobDidPress(XTKnob knob) {
	println("knobDidPress: " + knob.id);
}

void knobDidRelease(XTKnob knob) {
	println("knobDidRelease: " + knob.id);
}

void faderDidChange(float oldValue, float newValue) {
	println("faderDidChange: " + oldValue, newValue);
}

void buttonDidChange(XTButton button, boolean value) {
	println("buttonDidChange: (" + button.id + "): " + value);
}
```

Knob ids are 1–8 for Layer A, and 9–16 for Layer B.  
Button ids are 1–16 for Layer A, and 17–32 for Layer B.  
There is only a single Fader shared across both layers.  

Set values on the controller like so:
```
// set value 100 for knob #2
xTouch.setValueForKnob(100, 2);

// set value true (on) for button #3
xTouch.setValueForButton(true, 3);
```

Find more info in the `examples` folder, or in the `docs`.


## Build from Source

The build script for this project (`build.sh`) simply copies all the classes into a single file in the `dist` folder.

```
cd [xtouch-mini-processing]
./build.sh
```

## License

This project is licensed under the Unlicense - see the [LICENSE.md](LICENSE.md) file for details.