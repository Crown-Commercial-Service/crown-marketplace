function FormValidationComponent (formDOMObject, validationCallback, thisisspecial = false) {
    if ( null != formDOMObject && null == formDOMObject.formValidator &&
        ( ( thisisspecial && formDOMObject.getAttribute('specialvalidation') == 'true') ||
          ( !thisisspecial && (formDOMObject.hasAttribute('specialvalidation') && formDOMObject.getAttribute('specialvalidation') == 'false'))
        )) {
        this.form = formDOMObject;
        this.form.formValidator = this;
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
                        submitForm = submitForm && this.testError (
                            function (jqueryObject) {return ('' + jqueryObject.val() == '')},
                            jElem, 'required');
                    }
                    if (jElem.prop('maxlength')) {
                        submitForm = submitForm && this.testError (
                            function (jqueryObject) {
                                let maxLength = parseInt(jqueryObject.prop('maxlength'));
                                return (('' + jqueryObject.val()).length > maxLength);
                            },
                            jElem, 'maxlength');
                    }
                }
            }
        }
        this.validationResult = submitForm;
    }

    return submitForm;
};

FormValidationComponent.prototype.errorMessage = function( property_name, errorType ) {
    switch ( errorType ) {
        case 'required':
            return property_name + " can't be blank";
            break;
        case 'maxlength':
            return property_name + ' is too long';
            break;
        default:
            return property_name + ' has a problem';
            break;
    }
};

FormValidationComponent.prototype.testError = function ( errFn, jElem, errorType) {
    let result = false ;

    if ( errFn(jElem) ) {
        this.toggleError(jElem, true, errorType);
        result = false;
    } else {
        this.toggleError(jElem, false, errorType);
        result = true;
    }

    return result;
};

FormValidationComponent.prototype.insertElementForRequiredMessage = function (inputElement, parent, errorType ) {
    let propertyName = parent.attr("data-propertyname");
    let labelElem = '<label class="govuk-error-message" data-validation="' + errorType + '" for="' + inputElement[0].id + '">' + this.errorMessage(propertyName, errorType) + '</label>';
    $(parent).prepend(labelElem);
    return $(parent[0].childNodes[0]);
};

FormValidationComponent.prototype.toggleError = function ( jQueryElement, show, errorType ) {
    let jqueryElementForInputGroup = jQueryElement.parent (".govuk-form-group");
    let jqueryElementForRequiredMessage = jQueryElement.siblings("label[data-validation='"+ errorType + "']");
    if ( jqueryElementForRequiredMessage.length == 0 ) {
        jqueryElementForRequiredMessage = this.insertElementForRequiredMessage ( jQueryElement, jqueryElementForInputGroup, errorType);
    }
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
global_formValidator = null;
$(function () {
    jqForm = $('form');
    if ( jqForm.length > 0 ) {
        global_formValidator = new FormValidationComponent (
            jqForm[0], undefined, false);
        global_formValidator.init();
    }
});
