import themidibus.*;

public class XTouchMini {
	int LAYER_A = 0, LAYER_B = 1;

	int CHANNEL = 10;

	int KNOB_INDEX_START_A = 1;
	int KNOB_INDEX_END_A = 8;
	int KNOB_INDEX_START_B = 11;
	int KNOB_INDEX_END_B = 18;

	int KNOB_BUTTON_INDEX_START_A = 0;
	int KNOB_BUTTON_INDEX_END_A = 7;
	int KNOB_BUTTON_INDEX_START_B = 24;
	int KNOB_BUTTON_INDEX_END_B = 31;

	int BUTTON_INDEX_START_A = 8;
	int BUTTON_INDEX_END_A = 23;
	int BUTTON_INDEX_START_B = 32;
	int BUTTON_INDEX_END_B = 47;

	int FADER_INDEX_A = 9;
	int FADER_INDEX_B = 10;


	boolean logMidiBusOutput = false;
	boolean resetControls = true;
	int currentLayer;
	MidiBus midiBus; // The MidiBus

	XTKnob[] _knobs;
	XTButton[] _buttons;
	int[] knobIdsByButtonPitch = new int[KNOB_BUTTON_INDEX_END_B + 1];

	// only make one fader since it can't change physical display per layer
	XTFader fader;

	XTouchMini() {
		MidiBus.list();
		midiBus = new MidiBus(this, 0, 1);

		createKnobs();
		createButtons();
		fader = new XTFader();
		if(resetControls) resetControls();
	}

	void resetControls(){
		for(int i = 1; i <= 18; i++){
			midiBus.sendControllerChange(CHANNEL, i, 0);
		}

		for(int j=0; j < 48; j++){
			midiBus.sendNoteOff(CHANNEL, j, 0);
		}
	}

	void createButtons() {
		_buttons = new XTButton[32];
		int pitch = BUTTON_INDEX_START_A;
		for(int i = 0; i < _buttons.length; i++){
			XTButton b = new XTButton(i+1, pitch);
			_buttons[i] = b;


			if(pitch == BUTTON_INDEX_END_A){
				pitch = BUTTON_INDEX_START_B;
			} else {
				pitch++;
			}
		}
	}

	void createKnobs() {
		_knobs = new XTKnob[16];
		int number = KNOB_INDEX_START_A;
		int pitch = KNOB_BUTTON_INDEX_START_A;
		for(int i = 0; i < _knobs.length; i++){
			int id = i+1;
			XTKnob k = new XTKnob(id, number);
			_knobs[i] = k;

			knobIdsByButtonPitch[pitch] = id;

			if(number == KNOB_INDEX_END_A){
				number = KNOB_INDEX_START_B;
				pitch = KNOB_BUTTON_INDEX_START_B;
			} else {
				pitch++;
				number++;
			}
		}
	}

	XTFader getFader() {
		// for consistency
		return fader;
	}

	void setRangeForFader(int min, int max) {
		fader.setRange(min, max);
	}

	// ### KNOBS ###
	XTKnob getKnob(int id) {
		return _knobs[id-1];
	}

	void setRangeForKnob(int min, int max, int knobID) {
		setRangeForKnob(min, max, getKnob(knobID));
	}

	void setRangeForKnob(int min, int max, XTKnob knob) {
		knob.setRange(min, max);
	}

	float getValueForKnob(int knobID) {
		return getKnob(knobID).value;
	}

	float getValueForKnob(XTKnob knob) {
		return knob.value;
	}

	void setValueForKnob(int value, int knobID) {
		XTKnob k = getKnob(knobID);
		setValueForKnob(value, k);
	}

	void setValueForKnob(int value, XTKnob knob) {
		int val = knob.getRawValue(value);
		midiBus.sendControllerChange(CHANNEL, knob.number, val);
		knob.setValue(value);
	}

	void resetKnob(int knobID){
		XTKnob k = getKnob(knobID);
		resetKnob(k);
	}

	void resetKnob(XTKnob knob) {
		knob.setRawValue(0);
		midiBus.sendControllerChange(CHANNEL, knob.number, 0);
	}

	void maxKnob(int knobID) {
		XTKnob k = getKnob(knobID);
		maxKnob(k);
	}

	void maxKnob(XTKnob knob) {
		knob.setRawValue(127);
		midiBus.sendControllerChange(CHANNEL, knob.number, 127);
	}


	// ### BUTTONS ###
	XTButton getButton(int id) {
		return _buttons[id-1];
	}

	XTButton[] getButtons(int startID, int endID){
		int len = endID - startID + 1;
		XTButton[] arr = new XTButton[len];
		int id = startID;
		for(int i = 0; i < len; i++){
			arr[i] = getButton(id);
			id++;
		}
		return arr;
	}

	boolean getValueForButton(int buttonID) {
		return getButton(buttonID).value;
	}

	boolean getValueForButton(XTButton button) {
		return button.value;
	}

	void setValueForButton(boolean value, int buttonID){
		setValueForButton(value, getButton(buttonID));
	}

	void setValueForButton(boolean value, XTButton button) {
		button.setValue(value);
		int pitch = button.pitch;
		if(value == true){
			midiBus.sendNoteOn(CHANNEL, pitch, 127);
		} else {
			midiBus.sendNoteOff(CHANNEL, pitch, 0);
		}
	}

	void setModeForButton(int mode, int buttonID) {
		getButton(buttonID).mode = mode;
	}

	void setModeForButton(int mode, XTButton button) {
		button.mode = mode;
	}

	boolean pitchIsButton(int pitch) {
		return (pitch >= BUTTON_INDEX_START_A && pitch <= BUTTON_INDEX_END_A) || (pitch >= BUTTON_INDEX_START_B && pitch <= BUTTON_INDEX_END_B);
	}

	int getButtonIdForPitch(int pitch) {
		int id = 0;
		if(pitch < 24){
			id = pitch - 7;
		} else {
			id = pitch - 15;
		}
		return id;
	}



	// ### THEMIDIBUS ###
	void noteOn(int channel, int pitch, int velocity) {
		// Receive a noteOn

		if(pitchIsButton(pitch)){
			int id = getButtonIdForPitch(pitch);
			XTButton b = getButton(id);
			if(b.mode == XTButton.MODE_MOMENTARY || b.toggleValue == false){
				b.setValue(true);
			} else {
				b.toggle();
			}
		} else {
			// knob button
			int knobID = knobIdsByButtonPitch[pitch];
			knobDidPress(getKnob(knobID));
		}

		if(logMidiBusOutput){
			println();
			println("Note On:");
			println("--------");
			println("Channel:"+channel);
			println("Pitch:"+pitch);
			println("Velocity:"+velocity);
		}
	}

	void noteOff(int channel, int pitch, int velocity) {
		// Receive a noteOff

		if(pitchIsButton(pitch)){
			int id = getButtonIdForPitch(pitch);

			XTButton b = getButton(id);

			if (b.mode == XTButton.MODE_MOMENTARY || b.toggleValue == false){
				b.setValue(false);
			} else {
				midiBus.sendNoteOn(CHANNEL, pitch, 127);
			}

		} else {
			// knob button
			int knobID = knobIdsByButtonPitch[pitch];
			knobDidRelease(getKnob(knobID));
		}

		if(logMidiBusOutput){
			println();
			println("Note Off:");
			println("--------");
			println("Channel:"+channel);
			println("Pitch:"+pitch);
			println("Velocity:"+velocity);
		}
	}

	boolean controllerNumberIsFader(int number) {
		return number == FADER_INDEX_A || number == FADER_INDEX_B;
	}

	boolean controllerNumberIsKnob(int number) {
		return (number >= KNOB_INDEX_START_A && number <= KNOB_INDEX_END_A) || (number >= KNOB_INDEX_START_B && number <= KNOB_INDEX_END_B);
	}

	int getKnobIDFromControlNumber(int number) {
		if(number > KNOB_INDEX_END_A){
			number -= 2;
		}

		return number;
	}

	void controllerChange(int channel, int number, int value) {
		// Receive a controllerChange

		if(controllerNumberIsKnob(number)) {
			int knobID = getKnobIDFromControlNumber(number);
			getKnob(knobID).setRawValue(value);

		} else if(controllerNumberIsFader(number)){
			fader.setRawValue(value);
		}

		if(logMidiBusOutput){
			println();
			println("Controller Change:");
			println("--------");
			println("Channel:"+channel);
			println("Number:"+number);
			println("Value:"+value);
		}
	}
}