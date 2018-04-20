class XTKnob {

	int id = 0;
	int rawValue = 0;
	float value = 0;
	float rangeMin = 0, rangeMax = 127;
	int number = 0;

	XTKnob(int id, float value, float rangeMin, float rangeMax) {
		this.id = id;
		this.rangeMin = rangeMin;
		this.rangeMax = rangeMax;

		setValue(value);
	}

	XTKnob(int id, int number) {
		this.id = id;
		this.number = number;
	}

	void setRange(float min, float max) {
		rangeMin = min;
		rangeMax = max;

		setRawValue(rawValue);
	}

	int getRawValue() {
		return rawValue;
	}

	int getRawValue(float val) {
		return int(map(val, rangeMin, rangeMax, 0, 127));
	}

	void setRawValue(int val) {
		float oldValue = value;
		rawValue = val;
		value = map(val, 0, 127, rangeMin, rangeMax);

		knobDidChange(this, oldValue, this.value);
	}

	void setValue(float val) {
		setRawValue(getRawValue(val));
	}
}


