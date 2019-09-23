function FormValidationComponent (formDOMObject, validationCallback) {
    this.form = formDOMObject;
    this.validator = validationCallback;
}

FormValidationComponent.prototype.init = function () {
    let $self = this;
    this.form.onsubmit = function (e) { return $self.validator($self.form.elements) ; };
} ;