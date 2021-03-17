const common = {

  destructurePostCode(pc) {
    const input = (`${pc}`).trim().toUpperCase();
    const regEx = /^(([A-Z][A-Z]{0,1})([0-9][A-Z0-9]{0,1})) {0,}(([0-9])([A-Z]{2}))$/i;
    const matches = input.match(regEx);

    let result = { valid: false, input };
    if (matches !== null) {
      result = {
        valid: true,
        fullPostcode: `${matches[1]} ${matches[4]}`,
        postcodeArea: matches[2],
        outCode: matches[1],
        postcodeDistrict: matches[1],
        inCode: matches[4],
        postcodeSector: matches[5],
        unitPostcode: matches[6],
        formattedInput() {
          return this.fullPostcode;
        },
      };
    }

    return result;
  },

  getCachedData(key) {
    if (localStorage) return JSON.parse(localStorage.getItem(key)) || [];
  },

  calcCharsLeft(value, maxChars) {
    return maxChars - value.length;
  },
};
