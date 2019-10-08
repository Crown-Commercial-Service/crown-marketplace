const contractDateUtils = {

    dateAdd: function (date, type, amount) {
        let y = date.getFullYear(),
            m = date.getMonth(),
            d = date.getDate();

        if (type === 'y') {
            y = y + amount;
        }

        if (type === 'm') {
            m += amount;
        }

        if (type === 'w') {
            d += (amount * 7);
        }

        if (type === 'd') {
            d = d + amount;
        }

        return new Date(y, m, d);
    },

    calcContractDates: function (contractStartDate, initialContractLengthYears, mobilisationPeriod) {
        let result = {};
        let contractEndDate = contractDateUtils.contractEndDate(contractStartDate, initialContractLengthYears);
        let mobilisationEndDate = contractDateUtils.mobilisationEndDate(contractStartDate);
        let mobilisationStartDate = contractDateUtils.mobilisationStartDate(mobilisationEndDate, mobilisationPeriod);

        result['Contract-Start-Date'] = contractStartDate.toISOString().slice(0, 10);
        result['Contract-End-Date'] = contractEndDate.toISOString().slice(0, 10);
        result['Contract-Mob-Start'] = mobilisationStartDate.toISOString().slice(0, 10);
        result['Contract-Mob-End'] = mobilisationEndDate.toISOString().slice(0, 10);
        return result;
    },

    contractEndDate: function (contractStartDate, initialCallOffPeriod) {
        let contractEndDate = contractDateUtils.dateAdd(contractStartDate, 'y', initialCallOffPeriod);
        contractEndDate = contractDateUtils.dateAdd(contractEndDate, 'd', -1);
        return contractEndDate;
    },

    mobilisationStartDate: function (mobEndDate, leadTimeWeeks) {
        let startDate = contractDateUtils.dateAdd(mobEndDate, 'w', -leadTimeWeeks);
        return startDate;
    },

    mobilisationEndDate: function (contractStartDate) {
        let endDate = contractDateUtils.dateAdd(contractStartDate, 'd', -1);
        return endDate;
    }
};
