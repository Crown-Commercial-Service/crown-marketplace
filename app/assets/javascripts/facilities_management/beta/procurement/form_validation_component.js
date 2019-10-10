function form_validation_component(formDOMObject, validationCallback, thisisspecial = false) {
    this.verify_connection_to_form = function (formDOMObject, requestedSpecialTreatment) {
        let canConnect = false;
        if (null != formDOMObject && null == formDOMObject.formValidator) {
            if ( (requestedSpecialTreatment && formDOMObject.getAttribute('specialvalidation') == 'true') ||
                 (!requestedSpecialTreatment && !formDOMObject.hasAttribute('specialvalidation') || formDOMObject.getAttribute('specialvalidation') == 'false') ) {
                canConnect = true;
            }
        }
        return canConnect;
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
                        if ( '' + jElem.prop('pattern') != '' && submitForm) {
                            submitForm = submitForm && this.testError(
                                this.validationFunctions['regex'],
                                jElem, 'pattern');
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
        'required' : function(jQueryinputElem) {
            return ('' + jQueryinputElem.val() == '')
        },
        'maxlength' : function (jQueryinputElem) {
            let maxLength = parseInt(jQueryinputElem.prop('maxlength'));
            return (('' + jQueryinputElem.val()).length > maxLength);
        },
        'regex' : function ( jQueryinputElem) {
            let reg = new RegExp ( jQueryinputElem.prop('pattern') ) ;
            return !reg.test(jQueryinputElem.val());
        },
        'type' : {
            'number' : function (jQueryinputElem) {
                return jQueryinputElem.val() == '' || isNaN(Number(jQueryinputElem.val()));
            },
            'email' :  function (jQueryinputElem) {
                let regEx = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                return !regEx.test(jQueryinputElem.val());
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
            case 'number':
                return property_name + ' is not a number';
                break;
            case 'email':
                return property_name + ' is not a valid email address';
                break;
            case 'pattern':
                return property_name + ' is not valid';
                break;
            default:
                return property_name + ' is not valid for the type';
                break;
        }
    };

    this.insertElementToCreateFieldBlock = function (inputElement) {
        let continueLooping = true;
        let counter = 0;
        let elementsToWrap = [];
        // look at the previous sibling of the input element - if it is a label - we need to include it
        // look at the previous siblings of the input element - if it is a div of class govuk-error-message, we need to include it
        let prevElem = inputElement.prev() ;
        if ( inputElement.next().length > 0 && inputElement.next().prop('class').indexOf('character-count') >= 0 ) {
            elementsToWrap.push(inputElement.next()[0]);
        }
        elementsToWrap.push(inputElement[0]);
        while ( continueLooping && counter < 3) {
            if ( prevElem.length == 0 ) break;

            if (prevElem[0].nodeName == 'LABEL') {
                elementsToWrap.push(prevElem[0]);
            } else if ( prevElem.prop('class').indexOf('govuk-error-message') >= 0) {
                elementsToWrap.push(prevElem[0]);
            } else if ( counter >= 1 ){
                continueLooping = false;
            }
            prevElem = prevElem.prev();
            counter++;
        }
        let newElem = $('<div class="govuk-form-group"></div>').insertBefore(inputElement);
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
        this.connect_to_form(formDOMObject, validationCallback == undefined ? this.validateForm : validationCallback);
        this.initialise();
    }
}

const anyArbritatryName = {};

$(function () {
    anyArbritatryName.global_formValidators = [];
    let jqForms = $('form');
    if ( jqForms.length > 0 ) {
        for ( let index=0; index < jqForms.length; index++) {
            anyArbritatryName.global_formValidators[jqForms[index].id] = new form_validation_component (
                jqForms[index], undefined, false);
            anyArbritatryName.global_formValidators.push(anyArbritatryName.global_formValidators[jqForms[index].id]);
        }
    }
});
