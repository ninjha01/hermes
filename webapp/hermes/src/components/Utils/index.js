const datesBetween = (startDate, stopDate) => {
    var dateArray = [];
    var currentDate = startDate;
    while (currentDate <= stopDate) {
        dateArray.push(new Date(currentDate));
        currentDate = currentDate.addDays(1);
    }
    return dateArray;
};

Date.prototype.addDays = function(days) {
    var date = new Date(this.valueOf());
    date.setDate(date.getDate() + days);
    return date;
};

const formatDateTime = (datetime) => {
    const dateFormatter = require('dateformat')
    const formatString = "yyyy-mm-dd HH:mm";
    console.log(datetime)
    console.log(dateFormatter(datetime, formatString))

    return dateFormatter(datetime, formatString)
};

export {datesBetween, formatDateTime};
