class XTButtonGroup {

	XTButton[] buttons;

	int selectedButton = 0;
	XTouchMini controller;

	XTButtonGroup(XTouchMini controller, XTButton[] buttons){
		this.buttons = buttons;
		this.controller = controller;

		for(XTButton b : this.buttons){
			b.setMode(XTButton.MODE_TOGGLE);
			b.addToGroup(this);
		}
	}

	void buttonDidChange(XTButton button, boolean value) {
		if(buttons[selectedButton] != button) {
			controller.setValueForButton(false, buttons[selectedButton]);
		}

		selectedButton = indexOf(button);
	}

	int indexOf(XTButton button) {
		int index = -1;
		for(XTButton b : this.buttons){
			index++;
			if(b == button){
				return index;
			}
		}
		return -1;
	}

	boolean contains(XTButton button) {
		return indexOf(button) >= 0;
	}
}