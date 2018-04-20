class XTButton {

	static final int MODE_MOMENTARY = 0;
	static final int MODE_TOGGLE = 1;

	int id = 0;
	int mode = MODE_MOMENTARY;
	boolean value = false;
	boolean toggleValue = false;
	int pitch = 0;
	XTButtonGroup group;

	XTButton(int id) {
		this.id = id;
	}

	XTButton(int id, int pitch){
		this.id = id;
		this.pitch = pitch;
	}

	void setValue(boolean val) {
		value = val;
		toggleValue = val;
		if(this.group != null && val == true){
			group.buttonDidChange(this, value);
		}
		buttonDidChange(this, value);
	}

	void setMode(int mode){
		this.mode = mode;
	}

	void toggle() {
		toggleValue = !toggleValue;
	}

	void addToGroup(XTButtonGroup group) {
		this.group = group;
	}

}

