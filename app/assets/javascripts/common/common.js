const pageUtils = {

    /* Sort an un-ordered list */
    sortUnorderedList: ((listID) => {
        let list, i, switching, b, shouldSwitch;
        list = document.getElementById(listID);
        switching = true;
        /* Loop until no switching has been done: */
        while (switching) {
            // Start by saying: no switching is done:
            switching = false;
            b = list.getElementsByTagName("LI");
            // Loop through all list items:
            for (i = 0; i < (b.length - 1); i++) {
                // Start by saying there should be no switching:
                shouldSwitch = false;
                /* Check if the next item should
                switch place with the current item: */
                if (b[i].innerHTML.toLowerCase() > b[i + 1].innerHTML.toLowerCase()) {
                    /* If next item is alphabetically lower than current item,
                    mark as a switch and break the loop: */
                    shouldSwitch = true;
                    break;
                }
            }
            if (shouldSwitch) {
                /* If a switch has been marked, make the switch
                and mark the switch as done: */
                b[i].parentNode.insertBefore(b[i + 1], b[i]);
                switching = true;
            }
        }
    }),

    setCachedData: ((key, data) => {
        if (localStorage) {
            const dataString = JSON.stringify(data);
            localStorage.setItem(key, dataString);
        }
    }),

    getCachedData: ((key) => {
        if (localStorage) {
            return JSON.parse(localStorage.getItem(key)) || [];
        }
    }),

    sortByName: ((arr) => {
        return arr.sort((a, b) => {
            const nameA = a.name.toLowerCase(), nameB = b.name.toLowerCase()
            if (nameA < nameB) //sort string ascending
                return -1
            if (nameA > nameB)
                return 1
            return 0
        });
    }),

    getCodes: ((arr) => {
        let result = [];
        arr.forEach((value, index, array) => {
            result.push(value.code.replace('-','.'));
        });
        return result;
    })
};
