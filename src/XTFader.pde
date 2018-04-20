class XTFader {

	int rawValue;
	float value = 0;
	float rangeMin = 0, rangeMax = 127;

	XTFader() {}

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

		faderDidChange(oldValue, this.value);
	}

	void setValue(float val) {
		setRawValue(getRawValue(val));
	}
}

