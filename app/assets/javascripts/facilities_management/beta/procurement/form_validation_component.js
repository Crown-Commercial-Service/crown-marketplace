function form_validation_component(formDOMObject, validationCallback, thisisspecial = false) {
    this.verify_connection_to_form = function (formDOMObject, requestedSpecialTreatment) {
        let canConnect = false;
        if (null != formDOMObject && null == formDOMObject.formValidator) {
            if ((requestedSpecialTreatment && formDOMObject.getAttribute("specialvalidation") == "true") ||
                (!requestedSpecialTreatment && !formDOMObject.hasAttribute("specialvalidation") || formDOMObject.getAttribute("specialvalidation") == "false")) {
                canConnect = true;
            }
        }
        return canConnect;
    };

    this.connect_to_form = function (formDOMObject, validationCallback) {
        this.form = formDOMObject;
        this.form.formValidator = this;
        this.validator = validationCallback.bind(this);
        this.validationResult = true;

        this.bannerErrorContainer = $('[data-module="error-summary"]');

        this.form.onsubmit = function (e) {
            return this.validator(this.form.elements);
        }.bind(this);
    };

    this.validateTheForm = function () {
        return this.validator(this.form.elements);
    };

    this.initialise = function () {
        this.validationResult = true;
    };

    this.validateForm = function (formElements) {
        let submitForm = this.validationResult = true;
        this.clearBannerErrorList();
        this.toggleBannerError(false);
        this.clearAllFieldErrors();

        if (formElements !== undefined && formElements.length > 0) {
            let elements = [];
            for (let i = 0; i < formElements.length; i++) {
                let element = formElements[i];
                if (element.hasAttribute("type") || element.hasAttribute("required") || element.hasAttribute("maxlength")) {
                    elements.push(element);
                }
            }
            if (elements.length > 0) {
                for (let index = 0; index < elements.length; index++) {
                    let jElem = $(elements[index]);
                    if (jElem.length > 0) {
                        if (jElem.prop("required")) {
                            submitForm = submitForm && this.testError(
                                this.validationFunctions["required"],
                                jElem, "required");
                        }
                        if (jElem.prop("maxlength") > 0) {
                            submitForm = submitForm && this.testError(
                                this.validationFunctions["maxlength"],
                                jElem, "maxlength");
                        }
                        if (jElem.prop("type") && submitForm) {
                            for (let prop in this.validationFunctions.type) {
                                if (this.validationFunctions.type.hasOwnProperty(prop)) {
                                    let fn = this.validationFunctions.type[prop];
                                    if (null != fn && jElem.prop("type") == prop) {
                                        submitForm = submitForm && this.testError(
                                            fn, jElem, prop);
                                    }
                                }
                            }
                        }
                        if ( jElem.prop("pattern") !== undefined && jElem.prop("pattern") !== "" && submitForm) {
                            submitForm = submitForm && this.testError(
                                this.validationFunctions["regex"],
                                jElem, "pattern");
                        }
                        if ( jElem.prop("min") !== undefined && jElem.prop("min") !== "" && submitForm) {
                            submitForm = submitForm && this.testError(
                                this.validationFunctions["min"],
                                jElem, "min");
                        }
                        if ( jElem.prop("max") !== undefined && jElem.prop("max") !== "" && submitForm) {
                            submitForm = submitForm && this.testError(
                                this.validationFunctions["max"],
                                jElem, "max");
                        }
                    }

                    this.validationResult = this.validationResult && submitForm;
                    submitForm = true;
                }
            }
        }

        if (!this.validationResult) {
            this.toggleBannerError(true);
        }
        return this.validationResult;
    };
    this.validationFunctions = {
        "required": function (jQueryinputElem) {
            let inputType = jQueryinputElem[0].type;
            jQueryinputElem[0].type = "text";
            let result = ("" + jQueryinputElem.val() === "");
            jQueryinputElem[0].type = inputType;
            return result;
        },
        "maxlength": function (jQueryinputElem) {
            let maxLength = parseInt(jQueryinputElem.prop("maxlength"));
            if (!isNaN(maxLength) && maxLength > 0) {
                let inputType = jQueryinputElem[0].type;
                jQueryinputElem[0].type = "text";
                let result = (("" + jQueryinputElem.val()).length > maxLength);
                jQueryinputElem[0].type = inputType;
                return result;
            }
            return false;
        },
        "max": function (jQueryInputElem) {
            let inputValue = Number(jQueryInputElem.val());
            let maxVal = parseInt(jQueryInputElem.prop("max"));
            if (!isNaN(inputValue) && !isNaN(maxVal)) {
                return inputValue > maxVal;
            }
            return false;
        },
        "min": function (jQueryInputElem) {
            let inputValue = Number(jQueryInputElem.val());
            let minVal = parseInt(jQueryInputElem.prop("min"));

            if (!isNaN(inputValue) && !isNaN(minVal)) {
                return inputValue < minVal;
            }

            return false;
        },
        "range": function (jQueryInputElem) {
            let inputValue = Number(jQueryInputElem.val());
            let maxVal = parseInt(jQueryInputElem.prop("max"));
            let minVal = parseInt(jQueryInputElem.prop("min"));
            if (!isNaN(inputValue) && !isNaN(maxVal)) {
                return inputValue > maxVal;
            }
            if (!isNaN(inputValue) && !isNaN(minVal)) {
                return inputValue < minVal;
            }

            return false;
        },
        "regex": function (jQueryinputElem) {
            let reg = new RegExp(jQueryinputElem.prop("pattern"));
            return !reg.test(jQueryinputElem.val());
        },
        "type": {
            "text": function (jQueryinputElem) {
                return false;
            },
            "number": function (jQueryinputElem) {
                let inputType = jQueryinputElem[0].type;
                jQueryinputElem[0].type = "text";
                let result = jQueryinputElem.val() === "" || isNaN(Number(jQueryinputElem.val()));
                jQueryinputElem[0].type = inputType;
                return result;
            },
            "email": function (jQueryinputElem) {
                let regEx = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                return !regEx.test(jQueryinputElem.val());
            },
            "date": function (jQueryInputElem) {
                let theDate = Date.parse(jQueryInputElem.val());
                return theDate === NaN;
            }
        }
    };

    this.clearAllFieldErrors = function () {
        $(this.form).find("label[class=govuk-error-message]").closest(".govuk-form-group .govuk-form-group--error").find(".govuk-input--error").removeClass("govuk-input--error");
        $(this.form).find("label[class=govuk-error-message]").closest(".govuk-form-group .govuk-form-group--error").removeClass("govuk-form-group--error");
        $(this.form).find("label[class=govuk-error-message]").addClass("govuk-visually-hidden");
    };
    this.clearFieldErrors = function (jElem) {
        let errorCollection = jElem.siblings("label[class=govuk-error-message]");
        jElem.closest(".govuk-form-group .govuk-form-group--error").removeClass("govuk-form-group--error");
        jElem.removeClass("govuk-input--error");
        errorCollection.addClass("govuk-visually-hidden");
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

    this.errorMessage = function (propertyName, errorType) {
        switch (errorType) {
            case "required":
                return propertyName + " is required";
            case "maxlength":
                return propertyName + " is too long";
            case "min":
                return propertyName + " is too low";
            case "max":
                return propertyName + " is too high";
            case "range":
                return propertyName + " is too low or too high";
            case "number":
                return propertyName + " is not a number";
            case "email":
                return propertyName + " is not a valid email address";
            case "pattern":
                return propertyName + " is not valid";
            default:
                return propertyName + " is not valid for the type";
        }
    };

    this.insertElementToCreateFieldBlock = function (inputElement) {
        let continueLooping = true;
        let counter = 0;
        let elementsToWrap = [];
        // look at the previous sibling of the input element - if it is a label - we need to include it
        // look at the previous siblings of the input element - if it is a div of class govuk-error-message, we need to include it
        let prevElem = inputElement.prev();
        if (inputElement.next().length > 0 && inputElement.next().prop("class").indexOf("character-count") >= 0) {
            elementsToWrap.push(inputElement.next()[0]);
        }
        elementsToWrap.push(inputElement[0]);
        while (continueLooping && counter < 3) {
            if (prevElem.length === 0) break;

            if (prevElem[0].nodeName === "LABEL") {
                elementsToWrap.push(prevElem[0]);
            } else if (prevElem.prop("class").indexOf("govuk-error-message") >= 0) {
                elementsToWrap.push(prevElem[0]);
            } else if (counter >= 1) {
                continueLooping = false;
            }
            prevElem = prevElem.prev();
            counter++;
        }
        let newElem = $('<div class="govuk-form-group"></div>').insertBefore(inputElement);
        for (let index = 0; index < elementsToWrap.length; index++) {
            newElem.prepend(elementsToWrap[index]);
        }

        return newElem;
    };

    this.insertElementForRequiredMessage = function (inputElement, parent, errorType) {
        let propertyName = this.getPropertyName(parent);
        let labelElem = '<label id="' + this.getErrorID(inputElement) + '" class="govuk-error-message" data-validation="' + errorType + '" for="' + inputElement[0].id + '">' + this.errorMessage(propertyName, errorType) + '</label>';
        $(parent).prepend(labelElem);
        let newElement = $(parent[0].childNodes[0]);
        let parentElement = inputElement.prev();
        if (parentElement.length > 0 && parentElement[0].tagName === "LABEL") {
            newElement.detach().insertBefore(parentElement);
        } else {
            newElement.detach().insertBefore(inputElement);
        }
        return newElement;
    };

    this.clearBannerErrorList = function () {
        if (null != this.bannerErrorContainer) {
            let ul = this.bannerErrorContainer.find("ul");
            ul.empty();
        }
    };

    this.insertListElementInBannerError = function (inputElement, error_type, message_text) {
        let ul = this.bannerErrorContainer.find("ul");
        let display_text = "" ;
        if (ul.length > 0) {
            let propertyName = this.getPropertyName(inputElement);
            if (undefined === message_text || message_text + "" === "" ) {
                display_text = this.errorMessage(propertyName, error_type)
            } else {
                display_text = message_text;
            }
            // is there a message, of any other type, with the same text...
            let link = ul.find("a").filter(function () {
                return $(this).attr("data-propertyname") === propertyName && $(this).text() === display_text;
            });

            if ( link.length === 0 ) {
                link = ul.find("a").filter(function () {
                    return $(this).attr("data-errortype") === error_type && $(this).attr("data-propertyname") === propertyName;
                });
            }
            // ensure duplicates
            if (link.length <= 0) {
                let link = "<a href=\"#" + this.getErrorID(inputElement) + "\" data-propertyname='" + propertyName + "' data-errortype='" + error_type + "' >" + display_text + "</a>";
                ul.append("<li>" + link + "</li>");
            }
        }
    };

    this.removeListElementInBannerError = function (inputElement, error_type) {
        let ul = this.bannerErrorContainer.find("ul");
        if (ul.length > 0) {
            let propertyName = this.getPropertyName(inputElement);
            let link = ul.find("a").filter(function () {
                return $(this).attr("data-propertyname") === propertyName && $(this).attr("data-errortype") === error_type;
            });

            if (link.length > 0) {
                link.remove();
            }
        }
    };

    this.toggleBannerError = function (bShow) {
        if (null != this.bannerErrorContainer) {
            if (bShow) {
                this.bannerErrorContainer.removeClass("govuk-visually-hidden");
                $("html, body").animate({
                    scrollTop: this.bannerErrorContainer.offset().top
                }, 500);
            } else {
                this.bannerErrorContainer.addClass("govuk-visually-hidden");
            }
        }
    };
    this.findPreExistingErrorMessage = function (jQueryElement, errorType, jqueryElementForInputGroup) {
        let jqueryElementForRequiredMessage = jQueryElement.siblings("label[data-validation='" + errorType + "']");
        if (jqueryElementForRequiredMessage.length === 0) {
            jqueryElementForRequiredMessage = jQueryElement.parent().find(".error-collection").find("label[data-validation='" + errorType + "']").first();
            if (jqueryElementForRequiredMessage.length === 0) {
                jqueryElementForRequiredMessage = jQueryElement.parent().parent().find(".error-collection").find("label[data-validation='" + errorType + "']").first();
                if (jqueryElementForRequiredMessage.length === 0) {
                    jqueryElementForRequiredMessage = this.insertElementForRequiredMessage(jQueryElement, jqueryElementForInputGroup, errorType);
                }
            }
        }

        return jqueryElementForRequiredMessage;
    };
    this.toggleError = function (jQueryElement, show, errorType) {
        let jqueryElementForInputGroup = jQueryElement.closest(".govuk-form-group");
        let error_text = "";
        if (jqueryElementForInputGroup.length === 0) {
            jqueryElementForInputGroup = this.insertElementToCreateFieldBlock(jQueryElement);
        }
        let jqueryElementForRequiredMessage = this.findPreExistingErrorMessage(jQueryElement, errorType, jqueryElementForInputGroup);

        if (! jQueryElement.siblings().is(jqueryElementForRequiredMessage)) {
            // clone error element and place it above the input element
            jqueryElementForRequiredMessage = jqueryElementForRequiredMessage.clone();
            jqueryElementForRequiredMessage.prop("id", this.getErrorID(jQueryElement));
            jqueryElementForRequiredMessage.insertBefore(jQueryElement);
        }

        if (jqueryElementForRequiredMessage.length > 0 ) {
            error_text = jqueryElementForRequiredMessage[0].innerText;
        }
        
        if (!show) {
            if (this.validationResult) {
                jqueryElementForInputGroup.removeClass("govuk-form-group--error");
                if (jQueryElement[0].tagName === "INPUT") {
                    jQueryElement.removeClass("govuk-input--error");
                }
            }
            jqueryElementForRequiredMessage.addClass("govuk-visually-hidden");
        } else {
            if (jQueryElement[0].tagName === "INPUT") {
                jQueryElement.addClass("govuk-input--error");
            }
            jqueryElementForInputGroup.addClass("govuk-form-group--error");
            jqueryElementForRequiredMessage.removeClass("govuk-visually-hidden");
            this.insertListElementInBannerError(jQueryElement, errorType, error_text);
        }
    };

    this.getErrorID = function (jqueryInputElement) {
        return "error_" + jqueryInputElement[0].id;
    };
    this.getPropertyName = function (jqueryInputElement) {
        let propertyName = jqueryInputElement.attr("data-propertyname");
        if (propertyName === undefined || propertyName === "") {
            let newParent = null;
            if ((newParent = jqueryInputElement.closest("[data-propertyname]")).length > 0) {
                propertyName = newParent.attr("data-propertyname")
            } else {
                propertyName = "";
            }
        }
        if (propertyName === undefined || propertyName === "") {
            propertyName = jqueryInputElement[0].id;
        }

        return propertyName;
    };


    if (this.verify_connection_to_form(formDOMObject, thisisspecial)) {
        this.connect_to_form(formDOMObject, validationCallback === undefined ? this.validateForm : validationCallback);
        this.initialise();
    }
}

const anyArbritatryName = {};

$(function () {
    anyArbritatryName.global_formValidators = [];
    let jqForms = $("form");
    if (jqForms.length > 0) {
        for (let index = 0; index < jqForms.length; index++) {
            anyArbritatryName.global_formValidators[jqForms[index].id] = new form_validation_component(
                jqForms[index], undefined, false);
            anyArbritatryName.global_formValidators.push(anyArbritatryName.global_formValidators[jqForms[index].id]);
        }
    }
});
