function FormValidationComponent (formDOMObject, validationCallback, thisisspecial = false) {
    if ( null != formDOMObject && null == formDOMObject.formValidator &&
        ( ( thisisspecial && formDOMObject.getAttribute('specialvalidation') == 'true') ||
          ( !thisisspecial && (formDOMObject.hasAttribute('specialvalidation') && formDOMObject.getAttribute('specialvalidation') == 'false'))
        )) {
        this.form = formDOMObject;
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
                let jElem = $(elements[index]);
                if ( jElem.length > 0 ) {
                    if (jElem.prop('required')) {
                        submitForm = submitForm && this.testError (function (jqueryObject) {return ('' + jqueryObject.val() != '')}, jElem, 'required');
                    }
                    if (jElem.prop('maxlength')) {
                            submitForm = submitForm && this.testError ( function (jqueryObject) {
                            let maxLength = parseInt(jqueryObject.prop('maxlength'));
                            return !('' + jqueryObject.val().length > maxLength);
                        }, jElem, 'maxlength');
                    }
                }
            }
        }
        this.validationResult = submitForm;
    }

    return submitForm;
};
FormValidationComponent.prototype.testError = function ( errFn, jElem, errorType) {
    let result = false ;

    if ( !errFn(jElem) ) {
        this.toggleError(jElem, true, errorType);
        result = false;
    } else {
        this.toggleError(jElem, false, 'required');
        result = true;
    }

    return result;
};
FormValidationComponent.prototype.toggleError = function ( jQueryElement, show, errorType ) {
    let jqueryElementForInputGroup = jQueryElement.parent (".govuk-form-group");
    let jqueryElementForRequiredMessage = jQueryElement.siblings("div[data-validation='+ errorType + ']");
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
