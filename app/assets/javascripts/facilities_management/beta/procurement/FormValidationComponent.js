function FormValidationComponent (formDOMObject, validationCallback) {
    this.form = formDOMObject;
    if ( null != formDOMObject && null == this.form.formValidator && this.form.getAttribute('specialvalidation') != true ) {
        this.form.formValidator = this;
        this.validator = validationCallback == undefined ? this.validateForm : validationCallback;
        this.validationResult = true;
    }
}

FormValidationComponent.prototype.init = function () {
    let $self = this;
    if ( null != this.form ) {
        this.form.onsubmit = function (e) {
            return $self.validator($self.form.elements);
        };
    }
};

FormValidationComponent.prototype.validateForm = function (formElements) {
    let submitForm = this.validationResult = true;

    if ( formElements !== undefined && formElements.length > 0) {
        let elements = [];
        for ( let i = 0; i < formElements.length; i++) {
            let element = formElements[i];
            if ( element.hasAttribute('required') || element.hasAttribute('maxlength') ) {
                elements.push(element);
            }
        }
        if ( elements.length > 0 ) {
            for ( let index = 0; index < elements.length; index++ ) {
                let element = elements[index];
                let jElem = $(element);
                let elementValue = jElem.val();
                if (jElem.prop('required')) {
                    if ('' + elementValue == '') {
                        this.toggleRequiredError(jElem, true);
                        this.validationResult = submitForm = false;
                    } else {
                        this.toggleRequiredError(jElem, false);
                    }
                }
                if (jElem.prop('maxlength')) {
                    let maxLength = parseInt(jElem.prop('maxlength'));
                    if ( ('' + elementValue).length > maxLength) {
                        this.toggleLengthError(jElem, true );
                        this.validationResult = submitForm = false;
                    } else {
                        this.toggleLengthError(jElem, false );
                    }
                }
            }
        }
    }

    return submitForm;
};
FormValidationComponent.prototype.toggleRequiredError = function (jQueryElement, show) {
    let jqueryElementForInputGroup = jQueryElement.parent (".govuk-form-group");
    let jqueryElementForRequiredMessage = jQueryElement.siblings("div[data-validation='required']");
    if (!show) {
        if (this.validationResult ) {
            jqueryElementForInputGroup.removeClass("govuk-form-group--error");
        }
        jqueryElementForRequiredMessage.addClass("govuk-visually-hidden");
    } else {
        jqueryElementForInputGroup.addClass("govuk-form-group--error");
        jqueryElementForRequiredMessage.removeClass("govuk-visually-hidden");
    }
};
FormValidationComponent.prototype.toggleLengthError = function (jQueryElement, show) {
    let jqueryElementForInputGroup = jQueryElement.parent (".govuk-form-group");
    let jqueryElementForRequiredMessage = jQueryElement.siblings("div[data-validation='maxlength']");
    if (!show) {
        if (this.validationResult ) {
            jqueryElementForInputGroup.removeClass("govuk-form-group--error");
        }
        jqueryElementForRequiredMessage.addClass("govuk-visually-hidden");
    } else {
        jqueryElementForInputGroup.addClass("govuk-form-group--error");
        jqueryElementForRequiredMessage.removeClass("govuk-visually-hidden");
    }
};
