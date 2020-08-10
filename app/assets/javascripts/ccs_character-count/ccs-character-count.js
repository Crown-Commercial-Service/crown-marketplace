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

CCSCharacterCount.prototype.init = function () {
	var $module = this.$module;
	var $textarea = this.$textarea;
	if (!$textarea) {
		return;
	}
	
	this.options = this.getDataset($module);
	
	var countAttribute = this.defaults.characterCountAttribute;
	if (this.options.maxwords) {
		countAttribute = this.defaults.wordCountAttribute;
	}
	
	this.maxLength = $module.getAttribute(countAttribute);
	
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
	
	if ($textarea.getAttribute("type") === "number") {
		$textarea.setAttribute("type", "text");
		if (!this.options.maxwords) {
			$textarea.setAttribute('maxlength', this.maxLength);
		}
	}
	
	var boundCreateCountMessage = this.createCountMessage.bind(this);
	this.countMessage = boundCreateCountMessage();
	
	if (this.countMessage) {
		$module.removeAttribute('maxlength');
		
		var boundChangeEvents = this.bindChangeEvents.bind(this);
		boundChangeEvents();
		
		var boundUpdateCountMessage = this.updateCountMessage.bind(this);
		boundUpdateCountMessage();
	}
};

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

CCSCharacterCount.prototype.count = function (text) {
	var length;
	var newLines = text.match(/(\r\n|\n|\r)/g);
	var addition = 0;
	if (newLines != null) {
			addition = newLines.length;
	}
	if (this.options.maxwords) {
		var tokens = text.match(/\S+/g) || [];
		length = tokens.length;
	} else {
		length = text.length;
	}
	return length + addition;
};

CCSCharacterCount.prototype.createCountMessage = function () {
	var countElement = this.$textarea;
	var elementId = countElement.id;
	var countMessage = document.getElementById(elementId + '-info');
	
	if (elementId && !countMessage) {
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

CCSCharacterCount.prototype.bindChangeEvents = function () {
	var $textarea = this.$textarea;
	if (null !== this.numberFormat) {
		$textarea.addEventListener('keydown', this.restrictToNumberFormat.bind(this));
	}
	$textarea.addEventListener('keyup', this.checkIfValueChanged.bind(this));
	
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

CCSCharacterCount.prototype.checkIfValueChanged = function () {
	if (!this.$textarea.oldValue) this.$textarea.oldValue = '';
	if (this.$textarea.value !== this.$textarea.oldValue) {
		if (null !== this.numberFormat) {
			if (this.$textarea.value !== "") {
				if (!this.numberFormat.pattern.test(this.$textarea.value)) {
					this.$textarea.value = this.$textarea.oldValue;
				} else {
					this.$textarea.oldValue = this.$textarea.value;
				}
			}
		} else {
			this.$textarea.oldValue = this.$textarea.value;
		}
		var boundUpdateCountMessage = this.updateCountMessage.bind(this);
		boundUpdateCountMessage();
	}
};

CCSCharacterCount.prototype.updateCountMessage = function () {
	var countElement = this.$textarea;
	var options = this.options;
	var countMessage = this.countMessage;
	
	var currentLength = this.count(countElement.value);
	var maxLength = this.maxLength;
	var remainingNumber = maxLength - currentLength;
	
	var thresholdPercent = options.threshold ? options.threshold : 0;
	var thresholdValue = maxLength * thresholdPercent / 100;
	if (thresholdValue > currentLength) {
		countMessage.classList.add('govuk-character-count__message--disabled');
	} else {
		countMessage.classList.remove('govuk-character-count__message--disabled');
	}
	
	if (remainingNumber < 0) {
		countElement.classList.add('govuk-textarea--error');
		countMessage.classList.remove('govuk-hint');
		countMessage.classList.add('govuk-error-message');
	} else {
		countElement.classList.remove('govuk-textarea--error');
		countMessage.classList.remove('govuk-error-message');
		countMessage.classList.add('govuk-hint');
	}
	
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
	this.valueChecker = setInterval(this.checkIfValueChanged.bind(this), 1000);
};

CCSCharacterCount.prototype.handleBlur = function () {
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
