function form_validation_component(formDOMObject, validationCallback, thisisspecial = false) {
    this.verify_connection_to_form = function (formDOMObject, requestedSpecialTreatment) {
        if (null == formDOMObject) return false;
        if (null != formDOMObject.formValidator) return false;
        if (requestedSpecialTreatment && !formDOMObject.hasAttribute('specialvalidation')) return false;
        if (requestedSpecialTreatment && formDOMObject.getAttribute('specialvalidation') != 'true') return false;
        if (!requestedSpecialTreatment && formDOMObject.getAttribute('specialvalidation') == 'true') return false;

        return true;
    };

    this.connect_to_form = function (formDOMObject, validationCallback) {
        this.form = formDOMObject;
        this.form.formValidator = this;
        this.validator = validationCallback ;
        this.validationResult = true;

        this.form.onsubmit = function (e) {
            return this.validator(this.form.elements);
        }.bind(this);
    };

    this.initialise = function () {
        this.validationResult = true;
    };

    this.validateForm = function (formElements) {
        let submitForm = this.validationResult = true;

        if (formElements !== undefined && formElements.length > 0) {
            let elements = [];
            for (let i = 0; i < formElements.length; i++) {
                let element = formElements[i];
                if (element.hasAttribute('required') || element.hasAttribute('maxlength')) {
                    elements.push(element);
                }
            }
            if (elements.length > 0) {
                for (let index = 0; index < elements.length; index++) {
                    let jElem = $(elements[index]);
                    if (jElem.length > 0) {
                        if (jElem.prop('required')) {
                            submitForm = submitForm && this.testError(
                                this.validationFunctions['required'],
                                jElem, 'required');
                        }
                        if (jElem.prop('maxlength') > 0) {
                            submitForm = submitForm && this.testError(
                                this.validationFunctions['maxlength'],
                                jElem, 'maxlength');
                        }
                        if ( jElem.prop('type') && submitForm) {
                            for ( let prop in this.validationFunctions.type ) {
                                if ( this.validationFunctions.type.hasOwnProperty(prop)) {
                                    let fn = this.validationFunctions.type[prop];
                                    if (null != fn && jElem.prop('type') == prop) {
                                        submitForm = submitForm && this.testError(
                                            fn, jElem, prop);
                                    }
                                }
                            }
                        }
                    }

                    this.validationResult = this.validationResult && submitForm;
                    submitForm = true;
                }
            }
        }

        return this.validationResult;
    };
    this.validationFunctions = {
        'required' : function(jQueryObject) {
            return ('' + jQueryObject.val() == '')
        },
        'maxlength' : function (jQueryObject) {
            let maxLength = parseInt(jQueryObject.prop('maxlength'));
            return (('' + jQueryObject.val()).length > maxLength);
        },
        'type' : {
            'number' : function (jQueryObject) {
                return jQueryObject.val() == '' || isNaN(Number(jQueryObject.val()));
            }
        }

    };
    this.testError = function (errFn, jElem, errorType) {
        let result = false;

        if (errFn(jElem)) {
            this.toggleError(jElem, true, errorType);
            result = false;
        } else {
            this.toggleError(jElem, false, errorType);
            result = true;
        }

        return result;
    };

    this.errorMessage = function (property_name, errorType) {
        switch (errorType) {
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

    this.insertElementToCreateFieldBlock = function (inputElement) {
        let continueLooping = true;
        let counter = 0;
        let elementsToWrap = [];
        elementsToWrap.push(inputElement[0]);
        // look at the previous sibling of the input element - if it is a label - we need to include it
        // look at the previous siblings of the input element - if it is a div of class govuk-error-message, we need to include it
        let prevElem = inputElement.prev() ;
        let lastElem = inputElement[0];
        while ( continueLooping && counter < 3) {
            if ( prevElem.length == 0 ) break;

            if (prevElem[0].nodeName == 'LABEL') {
                elementsToWrap.push(prevElem[0]);
            } else if ( prevElem.prop('class').indexOf('govuk-error-message') >= 0) {
                elementsToWrap.push(prevElem[0]);
                continueLooping = false;
            } else if (prevElem[0].nodeName == 'INPUT') {
                break;
            } else if ( counter >= 1 ){
                continueLooping = false;
            }
            lastElem = prevElem;
            prevElem = prevElem.prev();
            counter++;
        }
        let newElem = $('<div class="govuk-form-group"></div>').insertBefore(lastElem);
        for ( let index = 0; index < elementsToWrap.length; index++ ) {
            newElem.prepend(elementsToWrap[index]);
        }

        return newElem;
    };

    this.insertElementForRequiredMessage = function (inputElement, parent, errorType) {
        let propertyName = parent.attr("data-propertyname");
        if (propertyName == undefined ) propertyName = '';
        let labelElem = '<label class="govuk-error-message" data-validation="' + errorType + '" for="' + inputElement[0].id + '">' + this.errorMessage(propertyName, errorType) + '</label>';
        $(parent).prepend(labelElem);

        return $(parent[0].childNodes[0]);
    };

    this.toggleError = function (jQueryElement, show, errorType) {
        let jqueryElementForInputGroup = jQueryElement.parent(".govuk-form-group");
        if (jqueryElementForInputGroup.length == 0 ) {
            jqueryElementForInputGroup = this.insertElementToCreateFieldBlock(jQueryElement);
        }
        let jqueryElementForRequiredMessage = jQueryElement.siblings("label[data-validation='" + errorType + "']");
        if (jqueryElementForRequiredMessage.length == 0) {
            jqueryElementForRequiredMessage = this.insertElementForRequiredMessage(jQueryElement, jqueryElementForInputGroup, errorType);
        }
        if (!show) {
            if (this.validationResult) {
                jqueryElementForInputGroup.removeClass("govuk-form-group--error");
            }
            jqueryElementForRequiredMessage.addClass("govuk-visually-hidden");
        } else {
            jqueryElementForInputGroup.addClass("govuk-form-group--error");
            jqueryElementForRequiredMessage.removeClass("govuk-visually-hidden");
        }
    };

    if (this.verify_connection_to_form(formDOMObject, thisisspecial)) {
        this.connect_to_form(formDOMObject, validationCallback == undefined ? this.validateForm : validationCallback)
        this.initialise();
    }
}

global_formValidator = null;
$(function () {
    jqForm = $('form');
    if ( jqForm.length > 0 ) {
        global_formValidator = new form_validation_component (
            jqForm[0], undefined, false);
    }
});
