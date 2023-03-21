enum ContactDetailType {
  TextInput,
  RadioInput
}

interface ContactDetailOption {
  name: string
  $element: JQuery<HTMLInputElement>
  type: ContactDetailType
}

abstract class ContactDetail {
  protected detailName: string
  protected $element: JQuery<HTMLInputElement>

  constructor (detailName: string, $element: JQuery<HTMLInputElement>) {
    this.detailName = detailName
    this.$element = $element
  }

  removeDetail = (): void => {
    window.sessionStorage.removeItem(this.detailName)
  }
}

class TextInputContactDetail extends ContactDetail {
  storeDetail = (): void => {
    window.sessionStorage[this.detailName] = this.$element.val()
  }

  fillInDetail = (): void => {
    this.$element.val(window.sessionStorage[this.detailName])
  }
}

class RadioInputContactDetail extends ContactDetail {
  storeDetail = (): void => {
    window.sessionStorage[this.detailName] = this.$element.is(':checked')
  }

  fillInDetail = (): void => {
    this.$element.prop('checked', (window.sessionStorage[this.detailName] === 'true'))
  }
}

class ContactDetails {
  private id: string
  private readonly contactDetails: Array<TextInputContactDetail | RadioInputContactDetail>

  constructor (id: string, contactDetails: ContactDetailOption[]) {
    this.id = id
    this.contactDetails = contactDetails.map((contactDetailOption): TextInputContactDetail | RadioInputContactDetail => {
      if (contactDetailOption.type === ContactDetailType.RadioInput) {
        return new RadioInputContactDetail(contactDetailOption.name, contactDetailOption.$element)
      } else {
        return new TextInputContactDetail(contactDetailOption.name, contactDetailOption.$element)
      }
    })
  }

  storeDetails = (): void => {
    this.contactDetails.forEach(contactDetail => { contactDetail.storeDetail() })

    window.sessionStorage[this.id] = true
  }

  fillInDetails = (): void => {
    this.contactDetails.forEach(contactDetail => { contactDetail.fillInDetail() })
  }

  removeDetails = (): void => {
    this.contactDetails.forEach(contactDetail => { contactDetail.removeDetail() })

    window.sessionStorage.removeItem(this.id)
  }
}

const initDetailsStorage = (
  id: string,
  contactDetailsOptions: ContactDetailOption[],
  $contactDetailsForm: JQuery<HTMLFormElement>,
  $contactDetailsAddressForm: JQuery<HTMLFormElement>
): void => {
  if (typeof (Storage) !== 'undefined') {
    const contactDetails = new ContactDetails(id, contactDetailsOptions)

    if ($contactDetailsForm.length && window.sessionStorage[id]) contactDetails.fillInDetails()

    if ($contactDetailsForm.length) {
      $('#cant-find-address-link').on('click', () => { contactDetails.storeDetails() })

      $('input[type="submit"]').on('click', () => { contactDetails.removeDetails() })
    } else if (!$contactDetailsAddressForm.length) {
      contactDetails.removeDetails()
    }
  }
}

export { ContactDetailType, type ContactDetailOption }
export default initDetailsStorage
