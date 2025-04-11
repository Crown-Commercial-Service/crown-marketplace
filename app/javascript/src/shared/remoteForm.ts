import { post } from '@rails/request.js'

type ResponseJSON = {
  html: string,
  error_message_html?: string
}

type PostProcessResultFunction = (responseJSON: ResponseJSON) => void

const createNestedObject = (base: {[key: string]: object | string | undefined}, names: string[], finalValue: string): void => {
  const lastIndex = names.length - 1

  names.forEach((name, index) => {
    const value = index === lastIndex ? finalValue : {}

    base = base[ name ] = base[ name ] = base[ name ] || value
  })
}


class RemoteFormHandler {
  updateId: string
  postProcessResultFunction?: PostProcessResultFunction
  $form: JQuery<HTMLFormElement>
  $submitButton: JQuery<HTMLInputElement>
  $input: JQuery<HTMLInputElement>
  $hiddenInputs: JQuery<HTMLInputElement>
  url: string
  inputName: string

  constructor (updateId: string, postProcessResultFunction?: PostProcessResultFunction) {
    this.updateId = updateId
    this.postProcessResultFunction = postProcessResultFunction
    this.$form = $('form[data-remote="true"]')
    this.$input = this.$form.find('input[type="search"]')
    this.$hiddenInputs = this.$form.find('input[type="hidden"]')
    this.$submitButton = this.$form.find('input[type="submit"]')
    this.url = this.$form.attr('action') as string
    this.inputName = this.$input.attr('name') as string
  }

  init() {
    this.$form.on('submit', async (event) => {
      event.preventDefault()

      this.$submitButton.attr('disabled', 'disabled')
      this.$submitButton.attr('aria-disabled', 'true')

      await this.handleRemoteForm()

      this.$submitButton.removeAttr('disabled')
      this.$submitButton.removeAttr('aria-disabled')
    })
  }

  private handleRemoteForm = async () => {
    const data = this.getNestedInputData()

    this.$hiddenInputs.each((_index, element) => {
      const $element = $(element)

      data[$element.attr('name') as string] = $element.val()
    })

    try {
      const response = await post(
        this.url,
        {
          body: JSON.stringify(data),
          contentType: 'application/json',
          responseKind: 'json',
        }
      )

      if (response.ok) {
        const responseJSON: ResponseJSON = await response.json

        this.processResult(responseJSON)
      }
    } finally {
      // Do nothing if failure
    }
  }

  private getNestedInputData = () => {
    const data: {[key: string]: object | string | undefined} = {}
    const inputNames = this.inputName.replace(']', '').split('[')

    createNestedObject(data, inputNames, this.$input.val() as string)

    return data
  }

  private processResult = (responseJSON: ResponseJSON) => {
    $(`#${this.updateId}`).html(responseJSON.html)

    if (this.postProcessResultFunction !== undefined) {
      this.postProcessResultFunction(responseJSON)
    }
  }
}

export { RemoteFormHandler, PostProcessResultFunction }
