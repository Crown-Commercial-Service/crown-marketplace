function FormValidationComponent (formDOMObject, validationCallback) {
    this.form = formDOMObject;
    this.validator = validationCallback == undefined ? this.validateForm : validationCallback;
    this.validationResult = true;
    this.formElements = [];
}
FormValidationComponent.prototype.init = function () {
    let $self = this;
    this.gatherFormElements();
    this.registerFieldChangeEvents();
    this.form.onsubmit = function (e) { return $self.validator($self.formElements) ; };
} ;
FormValidationComponent.prototype.gatherFormElements = function() {
    for ( let i = 0; i < this.form.elements.length; i++) {
        let element = this.form.elements[i];
        if (element.hasAttribute('required') || element.hasAttribute('maxlength')) {
            this.formElements.push(element);
        }
    }
};
FormValidationComponent.prototype.registerFieldChangeEvents = function () {
    let handler = this.handleFieldChangeEvent.bind(this);
    for ( let index = 0; index < this.formElements.length; index++) {
        $(this.formElements[index]).on('change', handler );
    }
};
FormValidationComponent.prototype.handleFieldChangeEvent = function ( e ) {
    let jqueryElement = $(e.currentTarget) ;
    this.validateField (jqueryElement);
};
FormValidationComponent.prototype.validateField = function ( jqueryElement ){
    let isValid = true;
    let elementValue = jqueryElement.val();
    
    if (jqueryElement.prop('required')) {
        if ('' + elementValue == '') {
            isValid = false;
            this.toggleRequiredError(jqueryElement, true, isValid);
        } else {
            this.toggleRequiredError(jqueryElement, false, isValid);
        }
    }
    if (jqueryElement.prop('maxlength')) {
        let maxLength = parseInt(jqueryElement.prop('maxlength'));
        if ( ('' + elementValue).length > maxLength) {
            isValid = false;
            this.toggleLengthError(jqueryElement, true, isValid);
        } else {
            this.toggleLengthError(jqueryElement, false, isValid );
        }
    }
    return isValid;
};
FormValidationComponent.prototype.validateForm = function (formElements) {
    let submitForm = true;

    if ( formElements !== undefined && formElements.length > 0) {
        let elements = formElements;
        if ( elements.length > 0 ) {
            for ( let index = 0; index < elements.length; index++ ) {
                let element = elements[index];
                let jElem = $(element);
                submitForm = (true && this.validateField(jElem));
            }
        }
    }
    this.validationResult = submitForm;
    return submitForm;
};
FormValidationComponent.prototype.toggleRequiredError = function (jQueryElement, show, otherSuccesses) {
    let jqueryElementForInputGroup = jQueryElement.parent (".govuk-form-group");
    let jqueryElementForRequiredMessage = jQueryElement.siblings("div[data-validation='required']");
    if (!show) {
        if (otherSuccesses ) {
            jqueryElementForInputGroup.removeClass("govuk-form-group--error");
        }
        jqueryElementForRequiredMessage.addClass("govuk-visually-hidden");
    } else {
        jqueryElementForInputGroup.addClass("govuk-form-group--error");
        jqueryElementForRequiredMessage.removeClass("govuk-visually-hidden");
    }
};
FormValidationComponent.prototype.toggleLengthError = function (jQueryElement, show, otherSuccesses) {
    let jqueryElementForInputGroup = jQueryElement.parent (".govuk-form-group");
    let jqueryElementForRequiredMessage = jQueryElement.siblings("div[data-validation='maxlength']");
    if (!show) {
        if ( otherSuccesses ) {
            jqueryElementForInputGroup.removeClass("govuk-form-group--error");
        }
        jqueryElementForRequiredMessage.addClass("govuk-visually-hidden");
    } else {
        jqueryElementForInputGroup.addClass("govuk-form-group--error");
        jqueryElementForRequiredMessage.removeClass("govuk-visually-hidden");
    }
};
