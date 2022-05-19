window.GOVUKFrontend = window.GOVUKFrontend || {};
window.GOVUKFrontend.Modules = window.GOVUKFrontend.Modules || {};

(function (Modules) {
  function Gemstepnav($module) {
    this.$module = $module;
    this.$module.actions = {}; // stores text for JS appended elements 'show' and 'hide' on steps, and 'show/hide all' button
    this.$module.rememberShownStep = false;
    this.$module.stepNavSize = false;
    this.$module.sessionStoreLink = 'govuk-step-nav-active-link';
    this.$module.activeLinkClass = 'gem-c-step-nav__list-item--active';
    this.$module.activeStepClass = 'gem-c-step-nav__step--active';
    this.$module.activeLinkHref = '#content';
    this.$module.uniqueId = false;
  }

  Gemstepnav.prototype.init = function () {
    // Indicate that js has worked
    this.$module.classList.add('gem-c-step-nav--active');

    // Prevent FOUC, remove class hiding content
    this.$module.classList.remove('js-hidden');

    this.$module.stepNavSize = this.$module.classList.contains('gem-c-step-nav--large') ? 'Big' : 'Small';
    this.$module.rememberShownStep = !!this.$module.hasAttribute('data-remember') && this.$module.stepNavSize === 'Big';

    this.$module.steps = this.$module.querySelectorAll('.js-step');
    this.$module.stepHeaders = this.$module.querySelectorAll('.js-toggle-panel');
    this.$module.totalSteps = this.$module.querySelectorAll('.js-panel').length;
    this.$module.totalLinks = this.$module.querySelectorAll('.gem-c-step-nav__link').length;
    this.$module.showOrHideAllButton = false;

    this.$module.uniqueId = this.$module.getAttribute('data-id') || false;

    if (this.$module.uniqueId) {
      this.$module.sessionStoreLink = `${this.$module.sessionStoreLink}_${this.$module.uniqueId}`;
    }

    const stepNavTracker = new this.StepNavTracker(this.$module.uniqueId, this.$module.totalSteps, this.$module.totalLinks);

    this.getTextForInsertedElements();
    this.addButtonstoSteps();
    this.addShowHideAllButton();
    this.addShowHideToggle();
    this.addAriaControlsAttrForShowHideAllButton();

    this.ensureOnlyOneActiveLink();
    this.showPreviouslyOpenedSteps();

    this.bindToggleForSteps(stepNavTracker);
    this.bindToggleShowHideAllButton(stepNavTracker);
    this.bindComponentLinkClicks(stepNavTracker);
  };

  Gemstepnav.prototype.getTextForInsertedElements = function () {
    this.$module.actions.showText = this.$module.getAttribute('data-show-text');
    this.$module.actions.hideText = this.$module.getAttribute('data-hide-text');
    this.$module.actions.showAllText = this.$module.getAttribute('data-show-all-text');
    this.$module.actions.hideAllText = this.$module.getAttribute('data-hide-all-text');
  };

  Gemstepnav.prototype.addShowHideAllButton = function () {
    const showAll = document.createElement('div');
    const steps = this.$module.querySelectorAll('.gem-c-step-nav__steps')[0];

    showAll.className = 'gem-c-step-nav__controls govuk-!-display-none-print';
    showAll.innerHTML = `${'<button type="button" aria-expanded="false" class="gem-c-step-nav__button gem-c-step-nav__button--controls js-step-controls-button">'
        + '<span class="gem-c-step-nav__chevron gem-c-step-nav__chevron--down js-step-controls-button-icon"></span>'
          + '<span class="gem-c-step-nav__button-text gem-c-step-nav__button-text--all js-step-controls-button-text">'}${
      this.$module.actions.showAllText
    }</span>`
      + '</button>';

    this.$module.insertBefore(showAll, steps);
    this.$module.showOrHideAllButton = this.$module.querySelectorAll('.js-step-controls-button')[0];
  };

  Gemstepnav.prototype.addShowHideToggle = function () {
    for (let i = 0; i < this.$module.stepHeaders.length; i++) {
      const thisel = this.$module.stepHeaders[i];

      if (!thisel.querySelectorAll('.js-toggle-link').length) {
        const showHideSpan = document.createElement('span');
        const showHideSpanText = document.createElement('span');
        const showHideSpanIcon = document.createElement('span');
        const showHideSpanFocus = document.createElement('span');
        const thisSectionSpan = document.createElement('span');

        showHideSpan.className = 'gem-c-step-nav__toggle-link js-toggle-link govuk-!-display-none-print';
        showHideSpanText.className = 'gem-c-step-nav__button-text js-toggle-link-text';
        showHideSpanIcon.className = 'gem-c-step-nav__chevron js-toggle-link-icon';
        showHideSpanFocus.className = 'gem-c-step-nav__toggle-link-focus';
        thisSectionSpan.className = 'govuk-visually-hidden';

        showHideSpan.appendChild(showHideSpanFocus);
        showHideSpanFocus.appendChild(showHideSpanIcon);
        showHideSpanFocus.appendChild(showHideSpanText);

        thisSectionSpan.innerHTML = ' this section';
        showHideSpan.appendChild(thisSectionSpan);

        thisel.querySelectorAll('.js-step-title-button')[0].appendChild(showHideSpan);
      }
    }
  };

  Gemstepnav.prototype.headerIsOpen = function (stepHeader) {
    return (typeof stepHeader.parentNode.getAttribute('show') !== 'undefined');
  };

  Gemstepnav.prototype.addAriaControlsAttrForShowHideAllButton = function () {
    const ariaControlsValue = this.$module.querySelectorAll('.js-panel')[0].getAttribute('id');

    this.$module.showOrHideAllButton.setAttribute('aria-controls', ariaControlsValue);
  };

  // called by show all/hide all, sets all steps accordingly
  Gemstepnav.prototype.setAllStepsShownState = function (isShown) {
    const data = [];

    for (let i = 0; i < this.$module.steps.length; i++) {
      const stepView = new this.StepView(this.$module.steps[i], this.$module);
      stepView.setIsShown(isShown);

      if (isShown) {
        data.push(this.$module.steps[i].getAttribute('id'));
      }
    }

    if (isShown) {
      this.saveToSessionStorage(this.$module.uniqueId, JSON.stringify(data));
    } else {
      this.removeFromSessionStorage(this.$module.uniqueId);
    }
  };

  // called on load, determines whether each step should be open or closed
  Gemstepnav.prototype.showPreviouslyOpenedSteps = function () {
    const data = this.loadFromSessionStorage(this.$module.uniqueId) || [];

    for (let i = 0; i < this.$module.steps.length; i++) {
      const thisel = this.$module.steps[i];
      const id = thisel.getAttribute('id');
      const stepView = new this.StepView(thisel, this.$module);
      const shouldBeShown = thisel.hasAttribute('data-show');

      // show the step if it has been remembered or if it has the 'data-show' attribute
      if ((this.$module.rememberShownStep && data.indexOf(id) > -1) || (shouldBeShown && shouldBeShown !== 'undefined')) {
        stepView.setIsShown(true);
      } else {
        stepView.setIsShown(false);
      }
    }

    if (data.length > 0) {
      this.$module.showOrHideAllButton.setAttribute('aria-expanded', true);
      this.setShowHideAllText();
    }
  };

  Gemstepnav.prototype.addButtonstoSteps = function () {
    for (let i = 0; i < this.$module.steps.length; i++) {
      const thisel = this.$module.steps[i];
      const title = thisel.querySelectorAll('.js-step-title')[0];
      const contentId = thisel.querySelectorAll('.js-panel')[0].getAttribute('id');
      const titleText = title.textContent || title.innerText; // IE8 fallback

      title.outerHTML = `${'<span class="js-step-title">'
          + '<button '
            + 'type="button"'
            + 'class="gem-c-step-nav__button gem-c-step-nav__button--title js-step-title-button" '
            + 'aria-expanded="false" aria-controls="'}${contentId}">`
              + '<span class="gem-c-step-nav____title-text-focus">'
                  + `<span class="gem-c-step-nav__title-text js-step-title-text">${titleText}</span>`
                  + '<span class="govuk-visually-hidden gem-c-step-nav__section-heading-divider">, </span>'
              + '</span>'
          + '</button>'
        + '</span>';
    }
  };

  Gemstepnav.prototype.bindToggleForSteps = function (stepNavTracker) {
    const that = this;
    const togglePanels = this.$module.querySelectorAll('.js-toggle-panel');

    for (let i = 0; i < togglePanels.length; i++) {
      togglePanels[i].addEventListener('click', function (event) {
        const stepView = new that.StepView(this.parentNode, that.$module);
        stepView.toggle();

        const stepIsOptional = this.parentNode.hasAttribute('data-optional');
        const toggleClick = new that.StepToggleClick(event, stepView, stepNavTracker, stepIsOptional, that.$module.stepNavSize);
        toggleClick.trackClick();

        that.setShowHideAllText();
        that.rememberStepState(this.parentNode);
      });
    }
  };

  // if the step is open, store its id in session store
  // if the step is closed, remove its id from session store
  Gemstepnav.prototype.rememberStepState = function (step) {
    if (this.$module.rememberShownStep) {
      const data = JSON.parse(this.loadFromSessionStorage(this.$module.uniqueId)) || [];
      const thisstep = step.getAttribute('id');
      const shown = step.classList.contains('step-is-shown');

      if (shown) {
        data.push(thisstep);
      } else {
        const i = data.indexOf(thisstep);
        if (i > -1) {
          data.splice(i, 1);
        }
      }
      this.saveToSessionStorage(this.$module.uniqueId, JSON.stringify(data));
    }
  };

  // tracking click events on links in step content
  Gemstepnav.prototype.bindComponentLinkClicks = function (stepNavTracker) {
    const jsLinks = this.$module.querySelectorAll('.js-link');
    const that = this;

    for (let i = 0; i < jsLinks.length; i++) {
      jsLinks[i].addEventListener('click', function (event) {
        const dataPosition = this.getAttribute('data-position');
        const linkClick = new that.ComponentLinkClick(event, stepNavTracker, dataPosition, that.$module.stepNavSize);
        linkClick.trackClick();

        if (this.getAttribute('rel') !== 'external') {
          that.saveToSessionStorage(that.$module.sessionStoreLink, dataPosition);
        }

        if (this.getAttribute('href') === that.$module.activeLinkHref) {
          that.setOnlyThisLinkActive(this);
          that.setActiveStepClass();
        }
      });
    }
  };

  Gemstepnav.prototype.saveToSessionStorage = function (key, value) {
    window.sessionStorage.setItem(key, value);
  };

  Gemstepnav.prototype.loadFromSessionStorage = function (key, value) {
    return window.sessionStorage.getItem(key);
  };

  Gemstepnav.prototype.removeFromSessionStorage = function (key) {
    window.sessionStorage.removeItem(key);
  };

  Gemstepnav.prototype.setOnlyThisLinkActive = function (clicked) {
    const allActiveLinks = this.$module.querySelectorAll(`.${this.$module.activeLinkClass}`);
    for (let i = 0; i < allActiveLinks.length; i++) {
      allActiveLinks[i].classList.remove(this.$module.activeLinkClass);
    }
    clicked.parentNode.classList.add(this.$module.activeLinkClass);
  };

  // if a link occurs more than once in a step nav, the backend doesn't know which one to highlight
  // so it gives all those links the 'active' attribute and highlights the last step containing that link
  // if the user clicked on one of those links previously, it will be in the session store
  // this code ensures only that link and its corresponding step have the highlighting
  // otherwise it accepts what the backend has already passed to the component
  Gemstepnav.prototype.ensureOnlyOneActiveLink = function () {
    const activeLinks = this.$module.querySelectorAll(`.js-list-item.${this.$module.activeLinkClass}`);

    if (activeLinks.length <= 1) {
      return;
    }

    const loaded = this.loadFromSessionStorage(this.$module.sessionStoreLink);
    const activeParent = this.$module.querySelectorAll(`.${this.$module.activeLinkClass}`)[0];
    const activeChild = activeParent.firstChild;
    const foundLink = activeChild.getAttribute('data-position');
    let lastClicked = loaded || foundLink; // the value saved has priority

    // it's possible for the saved link position value to not match any of the currently duplicate highlighted links
    // so check this otherwise it'll take the highlighting off all of them
    const checkLink = this.$module.querySelectorAll(`[data-position="${lastClicked}"]`)[0];

    if (checkLink) {
      if (!checkLink.parentNode.classList.contains(this.$module.activeLinkClass)) {
        lastClicked = checkLink;
      }
    } else {
      lastClicked = foundLink;
    }

    this.removeActiveStateFromAllButCurrent(activeLinks, lastClicked);
    this.setActiveStepClass();
  };

  Gemstepnav.prototype.removeActiveStateFromAllButCurrent = function (activeLinks, current) {
    for (let i = 0; i < activeLinks.length; i++) {
      const thisel = activeLinks[i];
      if (thisel.querySelectorAll('.js-link')[0].getAttribute('data-position').toString() !== current.toString()) {
        thisel.classList.remove(this.$module.activeLinkClass);
        const visuallyHidden = thisel.querySelectorAll('.visuallyhidden');
        if (visuallyHidden.length) {
          visuallyHidden[0].parentNode.removeChild(visuallyHidden[0]);
        }
      }
    }
  };

  Gemstepnav.prototype.setActiveStepClass = function () {
    // remove the 'active/open' state from all steps
    const allActiveSteps = this.$module.querySelectorAll(`.${this.$module.activeStepClass}`);
    for (let i = 0; i < allActiveSteps.length; i++) {
      allActiveSteps[i].classList.remove(this.$module.activeStepClass);
      allActiveSteps[i].removeAttribute('data-show');
    }

    // find the current page link and apply 'active/open' state to parent step
    const activeLink = this.$module.querySelectorAll(`.${this.$module.activeLinkClass}`)[0];
    if (activeLink) {
      const activeStep = activeLink.closest('.gem-c-step-nav__step');
      activeStep.classList.add(this.$module.activeStepClass);
      activeStep.setAttribute('data-show', '');
    }
  };

  Gemstepnav.prototype.bindToggleShowHideAllButton = function (stepNavTracker) {
    const that = this;

    this.$module.showOrHideAllButton.addEventListener('click', function (event) {
      const textContent = this.textContent || this.innerText;
      const shouldShowAll = textContent === that.$module.actions.showAllText;

      // Fire GA click tracking
      stepNavTracker.trackClick('pageElementInteraction', (shouldShowAll ? 'stepNavAllShown' : 'stepNavAllHidden'), {
        label: `${shouldShowAll ? that.$module.actions.showAllText : that.$module.actions.hideAllText}: ${that.$module.stepNavSize}`,
      });

      that.setAllStepsShownState(shouldShowAll);
      that.$module.showOrHideAllButton.setAttribute('aria-expanded', shouldShowAll);
      that.setShowHideAllText();

      return false;
    });
  };

  Gemstepnav.prototype.setShowHideAllText = function () {
    const shownSteps = this.$module.querySelectorAll('.step-is-shown').length;
    const showAllChevon = this.$module.showOrHideAllButton.querySelector('.js-step-controls-button-icon');
    const showAllButtonText = this.$module.showOrHideAllButton.querySelector('.js-step-controls-button-text');
    // Find out if the number of is-opens == total number of steps
    const shownStepsIsTotalSteps = shownSteps === this.$module.totalSteps;

    if (shownStepsIsTotalSteps) {
      showAllButtonText.innerHTML = this.$module.actions.hideAllText;
      showAllChevon.classList.remove('gem-c-step-nav__chevron--down');
    } else {
      showAllButtonText.innerHTML = this.$module.actions.showAllText;
      showAllChevon.classList.add('gem-c-step-nav__chevron--down');
    }
  };

  Gemstepnav.prototype.StepView = function (stepElement, $module) {
    this.stepElement = stepElement;
    this.stepContent = this.stepElement.querySelectorAll('.js-panel')[0];
    this.titleButton = this.stepElement.querySelectorAll('.js-step-title-button')[0];
    const textElement = this.stepElement.querySelectorAll('.js-step-title-text')[0];
    this.title = textElement.textContent || textElement.innerText;
    this.title = this.title.replace(/^\s+|\s+$/g, ''); // this is 'trim' but supporting IE8
    this.showText = $module.actions.showText;
    this.hideText = $module.actions.hideText;
    this.upChevronSvg = $module.upChevronSvg;
    this.downChevronSvg = $module.downChevronSvg;

    this.show = function () {
      this.setIsShown(true);
    };

    this.hide = function () {
      this.setIsShown(false);
    };

    this.toggle = function () {
      this.setIsShown(this.isHidden());
    };

    this.setIsShown = function (isShown) {
      const toggleLink = this.stepElement.querySelectorAll('.js-toggle-link')[0];
      const toggleLinkText = toggleLink.querySelector('.js-toggle-link-text');
      const stepChevron = toggleLink.querySelector('.js-toggle-link-icon');

      if (isShown) {
        this.stepElement.classList.add('step-is-shown');
        this.stepContent.classList.remove('js-hidden');
        toggleLinkText.innerHTML = this.hideText;
        stepChevron.classList.remove('gem-c-step-nav__chevron--down');
      } else {
        this.stepElement.classList.remove('step-is-shown');
        this.stepContent.classList.add('js-hidden');
        toggleLinkText.innerHTML = this.showText;
        stepChevron.classList.add('gem-c-step-nav__chevron--down');
      }
      this.titleButton.setAttribute('aria-expanded', isShown);
    };

    this.isShown = function () {
      return this.stepElement.classList.contains('step-is-shown');
    };

    this.isHidden = function () {
      return !this.isShown();
    };

    this.numberOfContentItems = function () {
      return this.stepContent.querySelectorAll('.js-link').length;
    };
  };

  Gemstepnav.prototype.StepToggleClick = function (event, stepView, stepNavTracker, stepIsOptional, stepNavSize) {
    this.target = event.target;
    this.stepIsOptional = stepIsOptional;
    this.stepNavSize = stepNavSize;

    this.trackClick = function () {
      const trackingOptions = { label: this.trackingLabel(), dimension28: stepView.numberOfContentItems().toString() };
      stepNavTracker.trackClick('pageElementInteraction', this.trackingAction(), trackingOptions);
    };

    this.trackingLabel = function () {
      const clickedNearbyToggle = this.target.closest('.js-step').querySelectorAll('.js-toggle-panel')[0];
      return `${clickedNearbyToggle.getAttribute('data-position')} - ${stepView.title} - ${this.locateClickElement()}: ${this.stepNavSize}${this.isOptional()}`;
    };

    // returns index of the clicked step in the overall number of steps
    this.stepIndex = function () { // eslint-disable-line no-unused-vars
      return this.$module.steps.index(stepView.element) + 1;
    };

    this.trackingAction = function () {
      return (stepView.isHidden() ? 'stepNavHidden' : 'stepNavShown');
    };

    this.locateClickElement = function () {
      if (this.clickedOnIcon()) {
        return `${this.iconType()} click`;
      } if (this.clickedOnHeading()) {
        return 'Heading click';
      }
      return 'Elsewhere click';
    };

    this.clickedOnIcon = function () {
      return this.target.classList.contains('js-toggle-link');
    };

    this.clickedOnHeading = function () {
      return this.target.classList.contains('js-step-title-text');
    };

    this.iconType = function () {
      return (stepView.isHidden() ? 'Minus' : 'Plus');
    };

    this.isOptional = function () {
      return (this.stepIsOptional ? ' ; optional' : '');
    };
  };

  Gemstepnav.prototype.ComponentLinkClick = function (event, stepNavTracker, linkPosition, size) {
    this.size = size;
    this.target = event.target;

    this.trackClick = function () {
      const trackingOptions = { label: `${this.target.getAttribute('href')} : ${this.size}` };
      const dimension28 = this.target.closest('.gem-c-step-nav__list').getAttribute('data-length');

      if (dimension28) {
        trackingOptions.dimension28 = dimension28;
      }

      stepNavTracker.trackClick('stepNavLinkClicked', linkPosition, trackingOptions);
    };
  };

  // A helper that sends a custom event request to Google Analytics if
  // the GOVUK module is setup
  Gemstepnav.prototype.StepNavTracker = function (uniqueId, totalSteps, totalLinks) {
    this.totalSteps = totalSteps;
    this.totalLinks = totalLinks;
    this.uniqueId = uniqueId;

    this.trackClick = function (category, action, options) {
      // dimension26 records the total number of expand/collapse steps in this step nav
      // dimension27 records the total number of links in this step nav
      // dimension28 records the number of links in the step that was shown/hidden (handled in click event)
      if (window.GOVUKFrontend.analytics && window.GOVUKFrontend.analytics.trackEvent) {
        options = options || {};
        options.dimension26 = options.dimension26 || this.totalSteps.toString();
        options.dimension27 = options.dimension27 || this.totalLinks.toString();
        options.dimension96 = options.dimension96 || this.uniqueId;
        window.GOVUKFrontend.analytics.trackEvent(category, action, options);
      }
    };
  };

  Modules.Gemstepnav = Gemstepnav;
}(window.GOVUKFrontend.Modules));
