function FormValidationComponent(formDOMObject, validationCallback, thisisspecial = false) {
    this.verify_connection_to_form = function (formDOMObject, requestedSpecialTreatment) {
        let canConnect = false;
        if (null != formDOMObject && null == formDOMObject.formValidator) {
            if ((requestedSpecialTreatment && formDOMObject.getAttribute("specialvalidation") === "true") ||
                ((!requestedSpecialTreatment && !formDOMObject.hasAttribute("specialvalidation")) || (!requestedSpecialTreatment && !(formDOMObject.getAttribute("specialvalidation") == "true")))) {
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
                    if (element.getAttribute("type") !== "hidden") {
                        elements.push(element);
                    }
                }
            }
            if (elements.length > 0) {
                for (let index = 0; index < elements.length; index++) {
                    try {
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
                                let htmlAttributeValue = jElem[0].getAttribute("type");
                                try {
                                    for (let prop in this.validationFunctions.type) {
                                        if (this.validationFunctions.type.hasOwnProperty(prop)) {
                                            let fn = this.validationFunctions.type[prop];
                                            if (null != fn && htmlAttributeValue == prop) {
                                                submitForm = submitForm && this.testError(
                                                    fn, jElem, prop);
                                            }
                                        }
                                    }
                                } catch (e) {
                                    console.log(e);
                                }
                            }
                            if (jElem.prop("pattern") !== undefined && jElem.prop("pattern") !== "" && submitForm) {
                                submitForm = submitForm && this.testError(
                                    this.validationFunctions["regex"],
                                    jElem, "invalid");
                            }
                            if (jElem.prop("min") !== undefined && jElem.prop("min") !== "" && submitForm) {
                                submitForm = submitForm && this.testError(
                                    this.validationFunctions["min"],
                                    jElem, "min");
                            }
                            if (jElem.prop("max") !== undefined && jElem.prop("max") !== "" && submitForm) {
                                submitForm = submitForm && this.testError(
                                    this.validationFunctions["max"],
                                    jElem, "max");
                            }
                        }
                    } catch (e) {
                        console.log(e);
                    }

                    this.validationResult = this.validationResult && submitForm;
                    submitForm = true;
                }
            }
        }

        if (!this.validationResult) {
            this.toggleBannerError(true);
        }

        if ( formElements["preventsubmission"] === "true") {
            return false;
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
                if (!result && jQueryinputElem[0].getAttribute("step") === "1") {
                    result = ((jQueryinputElem.val() % 1) != 0);
                }
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
        $(this.form).find(".govuk-input--error").removeClass("govuk-input--error");
        $(this.form).find(".govuk-select--error").removeClass("govuk-select--error");
        $(this.form).find(".govuk-form-group--error").removeClass("govuk-form-group--error");
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
        let display_text = "";
        if (ul.length > 0) {
            let href_value = "#" + this.getErrorID(inputElement);
            let propertyName = this.getPropertyName(inputElement);
            if (typeof message_text === "undefined" || message_text + "" === "") {
                display_text = this.errorMessage(propertyName, error_type)
            } else {
                display_text = message_text;
            }
            // is there a message, of any other type, with the same text...
            let link = ul.find("a").filter(function () {
                return $(this).attr("data-propertyname") === propertyName && $(this).text() === display_text;
            });

            if (link.length === 0) {
                link = ul.find("a").filter(function () {
                    return $(this).attr("data-errortype") === error_type && $(this).attr("data-propertyname") === propertyName;
                });
            }

            if ( link.length === 0 ) {
                link = ul.find("a").filter(function () {
                    return $(this).attr("href") === href_value && $(this).text() === display_text;
                });
            }

            if ( link.length === 0) {
                link = ul.find("a").filter(function () {
                    return $(this).text() === display_text;
                });
            }

            // ensure duplicates
            if (link.length <= 0) {
                let link = "<a href=\"" + href_value + "\" data-propertyname='" + propertyName + "' data-errortype='" + error_type + "' >" + display_text + "</a>";
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

    this.findErrorCollection = function ( jQueryElement, errorType, propertyname ) {
      return $('div.error-collection[property_name="' + propertyname + '"');
    };

    this.findPreExistingErrorMessage = function (jQueryElement, errorType, jqueryElementForInputGroup) {
        let property_name = this.getPropertyName(jQueryElement);
        let jqueryElementForRequiredMessage = jQueryElement.siblings("label[data-validation='" + errorType + "']");
        if (jqueryElementForRequiredMessage.length === 0) {
            let errorCollectionForPropertyAndType = this.findErrorCollection(jQueryElement, errorType, property_name);
            if (errorCollectionForPropertyAndType.length > 0) {
                jqueryElementForRequiredMessage = errorCollectionForPropertyAndType.find("label[data-validation='" + errorType + "']");
            }
        }

        if ( jqueryElementForRequiredMessage.length === 0 ) {
            let collection = [];
            let parent = jQueryElement.parent() ;
            while ( parent.length > 0 && collection.length === 0) {
                collection = parent.find(".error-collection[property_name='" + property_name + "']");
                parent = parent.parent();
            }
            if ( collection.length > 0 ) {
                jqueryElementForRequiredMessage = collection.find("label[data-validation='" + errorType + "']");
            } else {
                jqueryElementForRequiredMessage = this.insertElementForRequiredMessage(jQueryElement, jqueryElementForInputGroup, errorType);
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

        if ( jQueryElement.prop("class").indexOf('govuk-date-input') < 0 ) {
            if (!jQueryElement.siblings().is(jqueryElementForRequiredMessage)) {
                // clone error element and place it above the input element
                jqueryElementForRequiredMessage = jqueryElementForRequiredMessage.clone();
                jqueryElementForRequiredMessage.prop("id", this.getErrorID(jQueryElement));
                if (jQueryElement.prop("type") === "radio") {
                    jqueryElementForRequiredMessage.insertBefore(jQueryElement.parent());
                } else {
                    jqueryElementForRequiredMessage.insertBefore(jQueryElement);
                }
            }
        }

        if (jqueryElementForRequiredMessage.length > 0) {
            error_text = jqueryElementForRequiredMessage[0].innerText;
        }

        if (!show) {
            if (this.validationResult) {
                this.removeErrorClass(jqueryElementForInputGroup);
            }
            this.removeErrorClass(jQueryElement);
            jqueryElementForRequiredMessage.addClass("govuk-visually-hidden");
        } else {
            this.addErrorClass(jQueryElement);
            this.addErrorClass(jqueryElementForInputGroup);
            jqueryElementForRequiredMessage.removeClass("govuk-visually-hidden");
            this.insertListElementInBannerError(jQueryElement, errorType, error_text);
        }
    };

    this.addErrorClass = function (jQueryElement) {
        if (jQueryElement[0].tagName === "INPUT") {
            jQueryElement.addClass("govuk-input--error");
        } else if (jQueryElement[0].tagName === "SELECT") {
            jQueryElement.addClass("govuk-select--error");
        } else if (jQueryElement.prop("class").indexOf('govuk-form-group') >= 0) {
            jQueryElement.addClass("govuk-form-group--error");
        }
    };

    this.removeErrorClass = function (jQueryElement) {
        if (jQueryElement[0].tagName === "INPUT") {
            jQueryElement.removeClass("govuk-input--error");
        } else if (jQueryElement[0].tagName === "SELECT") {
            jQueryElement.removeClass("govuk-select--error");
        } else if (jQueryElement.prop("class").indexOf('govuk-form-group') >= 0) {
            jQueryElement.removeClass("govuk-form-group--error");
        }
    };

    this.getErrorID = function (jqueryInputElement) {
        return "error_" + jqueryInputElement[0].id;
    };
    this.getPropertyName = function (jqueryInputElement) {
        let propertyName = jqueryInputElement.attr("data-propertyname");
        if (typeof propertyName === "undefined" || propertyName === "") {
            let newParent = null;
            if ((newParent = jqueryInputElement.closest("[data-propertyname]")).length > 0) {
                propertyName = newParent.attr("data-propertyname")
            } else {
                propertyName = "";
            }
        }
        if (typeof propertyName === "undefined" || propertyName === "") {
            propertyName = jqueryInputElement[0].id;
        }

        return propertyName;
    };


    if (this.verify_connection_to_form(formDOMObject, thisisspecial)) {
        this.connect_to_form(formDOMObject, typeof validationCallback === "undefined" ? this.validateForm : validationCallback);
        this.initialise();
    }
}

const anyArbitraryName = {};

$(function () {
    anyArbitraryName.global_formValidators = [];
    let jqForms = $("form");
    if (jqForms.length > 0) {
        for (let index = 0; index < jqForms.length; index++) {
            anyArbitraryName.global_formValidators[jqForms[index].id] = new FormValidationComponent(
                jqForms[index], void 0, false);
            anyArbitraryName.global_formValidators.push(anyArbitraryName.global_formValidators[jqForms[index].id]);
        }
    }
});
