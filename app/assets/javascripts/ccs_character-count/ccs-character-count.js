function CCSCharacterCount($module) {
	this.$module = $module;
	this.$textarea = $module.querySelector('.ccs-character-count');
	this.$countContainer = $module.querySelector('.ccs-character-count-container');
}

CCSCharacterCount.prototype.defaults = {
	characterCountAttribute: 'data-maxlength',
	wordCountAttribute: 'data-maxwords',
	numberFormatAttribute: 'data-numbertype'
};

CCSCharacterCount.prototype.numberFormats = {
	'integer': {
		filteredKeyCodes: [8, 9, 13, 27, 46, 110],
		pattern: /^\d+$/
	},
	'decimal': {
		filteredKeyCodes: [8, 9, 13, 27, 46, 110, 190],
		pattern: /^[0-9]+(\.[0-9]{1,2})?$/
	}
};

// Initialize component
CCSCharacterCount.prototype.init = function () {
	// Check for module
	var $module = this.$module;
	var $textarea = this.$textarea;
	if (!$textarea) {
		return;
	}
	
	// Read options set using dataset ('data-' values)
	this.options = this.getDataset($module);
	
	// Determine the limit attribute (characters or words)
	var countAttribute = this.defaults.characterCountAttribute;
	if (this.options.maxwords) {
		countAttribute = this.defaults.wordCountAttribute;
	}
	
	// Save the element limit
	this.maxLength = $module.getAttribute(countAttribute);
	
	// Check for limit
	if (!this.maxLength) {
		return;
	}
	
	this.numberFormat = null;
	if ($module.getAttribute(this.defaults.numberFormatAttribute)) {
		var numberFormat = $module.getAttribute(this.defaults.numberFormatAttribute);
		if (null !== this.numberFormats[numberFormat]) {
			this.numberFormat = this.numberFormats[numberFormat];
		}
	}
	
	// adjust input if it is numeric to ensure maxlength is honoured and bind
	// key event to prevent non-numeric input
	if ($textarea.getAttribute("type") === "number") {
		$textarea.setAttribute("type", "text");
		if (!this.options.maxwords) {
			$textarea.setAttribute('maxlength', this.maxLength);
		}
	}
	
	// Generate and reference message
	var boundCreateCountMessage = this.createCountMessage.bind(this);
	this.countMessage = boundCreateCountMessage();
	
	// If there's a maximum length defined and the count message exists
	if (this.countMessage) {
		// Remove hard limit if set
		$module.removeAttribute('maxlength');
		
		// Bind event changes to the textarea
		var boundChangeEvents = this.bindChangeEvents.bind(this);
		boundChangeEvents();
		
		// Update count message
		var boundUpdateCountMessage = this.updateCountMessage.bind(this);
		boundUpdateCountMessage();
	}
};

// Read data attributes
CCSCharacterCount.prototype.getDataset = function (element) {
	var dataset = {};
	var attributes = element.attributes;
	if (attributes) {
		for (var i = 0; i < attributes.length; i++) {
			var attribute = attributes[i];
			var match = attribute.name.match(/^data-(.+)/);
			if (match) {
				dataset[match[1]] = attribute.value;
			}
		}
	}
	return dataset;
};

// Counts characters or words in text
CCSCharacterCount.prototype.count = function (text) {
	var length;
	if (this.options.maxwords) {
		var tokens = text.match(/\S+/g) || []; // Matches consecutive non-whitespace chars
		length = tokens.length;
	} else {
		length = text.length;
	}
	return length;
};

// Generate count message and bind it to the input
// returns reference to the generated element
CCSCharacterCount.prototype.createCountMessage = function () {
	var countElement = this.$textarea;
	var elementId = countElement.id;
	// Check for existing info count message
	var countMessage = document.getElementById(elementId + '-info');
	
	if (elementId && !countMessage) {
		// If there is no existing info count message we add one right after the field
		if (!this.$countContainer) {
			countElement.insertAdjacentHTML('afterend', '<span id="' + elementId + '-info" class="ccs-character-count-message govuk-hint" style="order:99" aria-live="polite"></span>');
			
		} else {
			this.$countContainer.insertAdjacentHTML('beforeend', '<span id="' + elementId + '-info" class="ccs-character-count-message govuk-hint" style="order:99" aria-live="polite"></span>');
		}
	} else {
		countMessage.style.order = '99';
		if (countMessage.className.indexOf('no-move') === -1) {
			if (!this.$countContainer) {
				countElement.insertAdjacentElement('afterend', countMessage);
			} else {
				this.$countContainer.insertAdjacentElement('beforeend', countMessage);
			}
		}
	}
	this.describedBy = countElement.getAttribute('aria-describedby');
	this.describedByInfo = this.describedBy + ' ' + elementId + '-info';
	countElement.setAttribute('aria-describedby', this.describedByInfo);
	countMessage = document.getElementById(elementId + '-info');
	return countMessage;
};

// Bind input propertychange to the elements and update based on the change
CCSCharacterCount.prototype.bindChangeEvents = function () {
	var $textarea = this.$textarea;
	if ( null !== this.numberFormat ) {
		$textarea.addEventListener('keydown', this.restrictToNumberFormat.bind(this));
	}
	$textarea.addEventListener('keyup', this.checkIfValueChanged.bind(this));
	
	// Bind focus/blur events to start/stop polling
	$textarea.addEventListener('focus', this.handleFocus.bind(this));
	$textarea.addEventListener('blur', this.handleBlur.bind(this));
};

CCSCharacterCount.prototype.restrictToNumberFormat = function (e) {
	var key = e.keyCode ? e.keyCode : e.which;
	var keyRestrictions = this.numberFormat.filteredKeyCodes;
	
	if (!(keyRestrictions.indexOf(key) !== -1 ||
		(key === 65 && (e.ctrlKey || e.metaKey)) ||
		(key >= 35 && key <= 40) ||
		(key >= 48 && key <= 57 && !(e.shiftKey || e.altKey)) ||
		(key >= 96 && key <= 105)
	)) {
		e.preventDefault();
	}
};

// Speech recognition software such as Dragon NaturallySpeaking will modify the
// fields by directly changing its `value`. These changes don't trigger events
// in JavaScript, so we need to poll to handle when and if they occur.
CCSCharacterCount.prototype.checkIfValueChanged = function () {
	if (!this.$textarea.oldValue) this.$textarea.oldValue = '';
	if (this.$textarea.value !== this.$textarea.oldValue) {
		if (null !== this.numberFormat) {
			if (!this.numberFormat.pattern.test(this.$textarea.value)) {
				this.$textarea.value = this.$textarea.oldvalue;
			} else {
				this.$textarea.oldValue = this.$textarea.value;
			}
		} else {
			this.$textarea.oldValue = this.$textarea.value;
		}
		var boundUpdateCountMessage = this.updateCountMessage.bind(this);
		boundUpdateCountMessage();
	}
};

// Update message box
CCSCharacterCount.prototype.updateCountMessage = function () {
	var countElement = this.$textarea;
	var options = this.options;
	var countMessage = this.countMessage;
	
	// Determine the remaining number of characters/words
	var currentLength = this.count(countElement.value);
	var maxLength = this.maxLength;
	var remainingNumber = maxLength - currentLength;
	
	// Set threshold if presented in options
	var thresholdPercent = options.threshold ? options.threshold : 0;
	var thresholdValue = maxLength * thresholdPercent / 100;
	if (thresholdValue > currentLength) {
		countMessage.classList.add('govuk-character-count__message--disabled');
	} else {
		countMessage.classList.remove('govuk-character-count__message--disabled');
	}
	
	// Update styles
	if (remainingNumber < 0) {
		countElement.classList.add('govuk-textarea--error');
		countMessage.classList.remove('govuk-hint');
		countMessage.classList.add('govuk-error-message');
	} else {
		countElement.classList.remove('govuk-textarea--error');
		countMessage.classList.remove('govuk-error-message');
		countMessage.classList.add('govuk-hint');
	}
	
	// Update message
	var charVerb = 'remaining';
	var charNoun = 'character';
	var displayNumber = remainingNumber;
	if (options.maxwords) {
		charNoun = 'word';
	}
	charNoun = charNoun + ((remainingNumber === -1 || remainingNumber === 1) ? '' : 's');
	
	charVerb = (remainingNumber < 0) ? 'too many' : 'remaining';
	displayNumber = Math.abs(remainingNumber);
	
	countMessage.innerHTML = 'You have ' + displayNumber + ' ' + charNoun + ' ' + charVerb;
};

CCSCharacterCount.prototype.handleFocus = function () {
	// Check if value changed on focus
	this.valueChecker = setInterval(this.checkIfValueChanged.bind(this), 1000);
};

CCSCharacterCount.prototype.handleBlur = function () {
	// Cancel value checking on blur
	clearInterval(this.valueChecker);
};

function nodeListForEach(nodes, callback) {
	if (window.NodeList.prototype.forEach) {
		return nodes.forEach(callback);
	}
	for (var i = 0; i < nodes.length; i++) {
		callback.call(window, nodes[i], i, nodes);
	}
}

var $characterCount = document.querySelectorAll('[data-module="ccs-character-count"]');
nodeListForEach($characterCount, function ($characterCount) {
	new CCSCharacterCount($characterCount).init();
});
