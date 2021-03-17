function CCSCharacterCount($module) {
  this.$module = $module;
  this.$textarea = $module.querySelector('.ccs-character-count');
  this.$countContainer = $module.querySelector('.ccs-character-count-container');
}

CCSCharacterCount.prototype.defaults = {
  characterCountAttribute: 'data-maxlength',
  wordCountAttribute: 'data-maxwords',
  numberFormatAttribute: 'data-numbertype',
};

CCSCharacterCount.prototype.numberFormats = {
  integer: {
    filteredKeyCodes: [8, 9, 13, 27, 46, 110],
    pattern: /^\d+$/,
  },
  decimal: {
    filteredKeyCodes: [8, 9, 13, 27, 46, 110, 190],
    pattern: /^[0-9]+(\.[0-9]{1,2})?$/,
  },
};

CCSCharacterCount.prototype.init = function () {
  const { $module } = this;
  const { $textarea } = this;
  if (!$textarea) {
    return;
  }

  this.options = this.getDataset($module);

  let countAttribute = this.defaults.characterCountAttribute;
  if (this.options.maxwords) {
    countAttribute = this.defaults.wordCountAttribute;
  }

  this.maxLength = $module.getAttribute(countAttribute);

  if (!this.maxLength) {
    return;
  }

  this.numberFormat = null;
  if ($module.getAttribute(this.defaults.numberFormatAttribute)) {
    const numberFormat = $module.getAttribute(this.defaults.numberFormatAttribute);
    if (this.numberFormats[numberFormat] !== null) {
      this.numberFormat = this.numberFormats[numberFormat];
    }
  }

  if ($textarea.getAttribute('type') === 'number') {
    $textarea.setAttribute('type', 'text');
    if (!this.options.maxwords) {
      $textarea.setAttribute('maxlength', this.maxLength);
    }
  }

  const boundCreateCountMessage = this.createCountMessage.bind(this);
  this.countMessage = boundCreateCountMessage();

  if (this.countMessage) {
    $module.removeAttribute('maxlength');

    const boundChangeEvents = this.bindChangeEvents.bind(this);
    boundChangeEvents();

    const boundUpdateCountMessage = this.updateCountMessage.bind(this);
    boundUpdateCountMessage();
  }
};

CCSCharacterCount.prototype.getDataset = function (element) {
  const dataset = {};
  const { attributes } = element;
  if (attributes) {
    for (let i = 0; i < attributes.length; i++) {
      const attribute = attributes[i];
      const match = attribute.name.match(/^data-(.+)/);
      if (match) {
        dataset[match[1]] = attribute.value;
      }
    }
  }
  return dataset;
};

CCSCharacterCount.prototype.count = function (text) {
  let length;

  if (this.options.maxwords) {
    const tokens = text.match(/\S+/g) || [];
    length = tokens.length;
  } else {
    length = text.length;
  }
  return length;
};

CCSCharacterCount.prototype.createCountMessage = function () {
  const countElement = this.$textarea;
  const elementId = countElement.id;
  let countMessage = document.getElementById(`${elementId}-info`);

  if (elementId && !countMessage) {
    if (!this.$countContainer) {
      countElement.insertAdjacentHTML('afterend', `<span id="${elementId}-info" class="ccs-character-count-message govuk-hint" style="order:99" aria-live="polite"></span>`);
    } else {
      this.$countContainer.insertAdjacentHTML('beforeend', `<span id="${elementId}-info" class="ccs-character-count-message govuk-hint" style="order:99" aria-live="polite"></span>`);
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
  this.describedByInfo = `${this.describedBy} ${elementId}-info`;
  countElement.setAttribute('aria-describedby', this.describedByInfo);
  countMessage = document.getElementById(`${elementId}-info`);
  return countMessage;
};

CCSCharacterCount.prototype.bindChangeEvents = function () {
  const { $textarea } = this;
  if (this.numberFormat !== null) {
    $textarea.addEventListener('keydown', this.restrictToNumberFormat.bind(this));
  }
  $textarea.addEventListener('keyup', this.checkIfValueChanged.bind(this));

  $textarea.addEventListener('focus', this.handleFocus.bind(this));
  $textarea.addEventListener('blur', this.handleBlur.bind(this));
};

CCSCharacterCount.prototype.restrictToNumberFormat = function (e) {
  const key = e.keyCode ? e.keyCode : e.which;
  const keyRestrictions = this.numberFormat.filteredKeyCodes;

  if (!(keyRestrictions.indexOf(key) !== -1
		|| (key === 65 && (e.ctrlKey || e.metaKey))
		|| (key >= 35 && key <= 40)
		|| (key >= 48 && key <= 57 && !(e.shiftKey || e.altKey))
		|| (key >= 96 && key <= 105)
  )) {
    e.preventDefault();
  }
};

CCSCharacterCount.prototype.checkIfValueChanged = function () {
  if (!this.$textarea.oldValue) this.$textarea.oldValue = '';
  if (this.$textarea.value !== this.$textarea.oldValue) {
    if (this.numberFormat !== null) {
      if (this.$textarea.value !== '') {
        if (!this.numberFormat.pattern.test(this.$textarea.value)) {
          this.$textarea.value = this.$textarea.oldValue;
        } else {
          this.$textarea.oldValue = this.$textarea.value;
        }
      }
    } else {
      this.$textarea.oldValue = this.$textarea.value;
    }
    const boundUpdateCountMessage = this.updateCountMessage.bind(this);
    boundUpdateCountMessage();
  }
};

CCSCharacterCount.prototype.updateCountMessage = function () {
  const countElement = this.$textarea;
  const { options } = this;
  const { countMessage } = this;

  const currentLength = this.count(countElement.value);
  const { maxLength } = this;
  const remainingNumber = maxLength - currentLength;

  const thresholdPercent = options.threshold ? options.threshold : 0;
  const thresholdValue = maxLength * thresholdPercent / 100;
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

  let charVerb = 'remaining';
  let charNoun = 'character';
  let displayNumber = remainingNumber;
  if (options.maxwords) {
    charNoun = 'word';
  }
  charNoun += ((remainingNumber === -1 || remainingNumber === 1) ? '' : 's');

  charVerb = (remainingNumber < 0) ? 'too many' : 'remaining';
  displayNumber = Math.abs(remainingNumber);

  countMessage.innerHTML = `You have ${displayNumber} ${charNoun} ${charVerb}`;
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
  for (let i = 0; i < nodes.length; i++) {
    callback.call(window, nodes[i], i, nodes);
  }
}

$(() => {
  const $characterCount = document.querySelectorAll('[data-module="ccs-character-count"]');

  nodeListForEach($characterCount, ($characterCount) => {
    new CCSCharacterCount($characterCount).init();
  });
});
