XTouchMini xTouch = new XTouchMini();

float circleX = 0;
float circleY = 0;
float circleSize = 10;

int circleColor = 255;
int flashColor = 128;
int bgColor = 0;

XTButtonGroup buttonGroup;

void setup() {
	size(600, 400);
	noStroke();
	
	// Knob 1 will control circle's X position
	// Knob 2 will control Y position
	// set the ranges for those knobs to map to the sketch width & height
	xTouch.setRangeForKnob(0, width, 1);
	xTouch.setRangeForKnob(0, height, 2);
	
	// Knob 3 controls circle size (10-100)
	xTouch.setRangeForKnob(10, 100, 3);
	
	// Fader will control background color (0-255)
	xTouch.setRangeForFader(0, 255);
	
	// get buttons 1-6 and add them to a new button group
	// button groups act like radio buttons: 
	// only one button in the group can be on 
	// buttons in a button group are automatically set to toggle mode
	XTButton[] buttons = xTouch.getButtons(1, 6);
	buttonGroup = new XTButtonGroup(xTouch, buttons);
	xTouch.setValueForButton(true, 1);
}

void draw() {
	background(bgColor);
	
	// draw circle
	fill(circleColor);
	ellipse(circleX, circleY, circleSize, circleSize);
}

void knobDidChange(XTKnob knob, float oldValue, float newValue) {
	println("knobDidChange (" + knob.id + "): " + oldValue, newValue);
	
	// update circle's X & Y when knob values change
	switch(knob.id){
		case 1:
			circleX = newValue;
		break;
		case 2:
			circleY = newValue;
		break;
		case 3:
			circleSize = newValue;
		break;
	}
}

void knobDidPress(XTKnob knob) {
	println("knobDidPress: " + knob.id);
	
	// reset a knob when its button gets pressed
	xTouch.resetKnob(knob);
}

void knobDidRelease(XTKnob knob) {
	println("knobDidRelease: " + knob.id);
}

void faderDidChange(float oldValue, float newValue) {
	println("faderDidChange: " + oldValue, newValue);
	
	// update background color value
	bgColor = int(newValue);
}

void buttonDidChange(XTButton button, boolean value) {
	println("buttonDidChange: (" + button.id + "): " + value);
	
	int buttonIndex = buttonGroup.indexOf(button);
	if(buttonIndex >=0){
		// if button in in group: set the flash color
		switch(buttonIndex){
			case 1 :
				flashColor = color(255, 0, 0);
			break;
			case 2 : 
				flashColor = color(0,255, 0);
			break;
			case 3 : 
				flashColor = color(0,0,255);
			break;
			case 4 : 
				flashColor = color(255, 0, 255);
			break;
			case 5 : 
				flashColor = color(255, 255, 0);
			break;
			case 6 :
				flashColor = color(0, 255, 255);
			break;
		}
	} else {
		// otherwise, flash the circle when button is down
		circleColor = value ? flashColor : 255;
		
	}
}