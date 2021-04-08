XTouchMini xTouch = new XTouchMini();

float circleX = 0;
float circleY = 0;
float circleSize = 10;

int circleColor = 255;
int bgColor = 0;

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
	xTouch.setRoundingConstraintsForKnob(10, 3); // change values in increments of 10
	
	// Fader will control background color (0-255)
	xTouch.setRangeForFader(0, 255);
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
	if(value == false) return;
	
	// set circle color
	switch(button.id){
		case 1 :
			circleColor = color(255, 0, 0);
		break;
		case 2 : 
			circleColor = color(0,255, 0);
		break;
		case 3 : 
			circleColor = color(0,0,255);
		break;
		case 4 : 
			circleColor = color(255, 0, 255);
		break;
		case 5 : 
			circleColor = color(255, 255, 0);
		break;
		case 6 :
			circleColor = color(0, 255, 255);
		break;
		
		default :
			circleColor = color(128);
		break;	
		
	}
}
