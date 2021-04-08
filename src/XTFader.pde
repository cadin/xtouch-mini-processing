class XTFader {

	int rawValue;
	float value = 0;
	float rangeMin = 0, rangeMax = 127;

	float roundingMultiplier = 1;
	int roundingDecimals = 0;
	boolean roundValues = false;

	XTFader() {}

	void setRange(float min, float max) {
		rangeMin = min;
		rangeMax = max;

		setRawValue(rawValue);
	}

	void setRoundingConstraints(float multiplier, int decimals) {
		roundingMultiplier = multiplier;
		roundingDecimals = decimals;
		roundValues = true;
	}

	void setRoundingConstraints(int multiplier) {
		this.setRoundingConstraints(multiplier, 0);
	}

	void clearRoundingConstraints() {
		roundValues = false;
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

		if(roundValues){
			value = Utils.roundToInterval(value, roundingMultiplier, roundingDecimals);
		}

		faderDidChange(oldValue, this.value);
	}

	void setValue(float val) {
		setRawValue(getRawValue(val));
	}
}

