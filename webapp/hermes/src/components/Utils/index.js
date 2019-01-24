const datesBetween = (startDate, endDate) => {
    var currentDate = startDate;
    var stopDate = new Date()
    stopDate.setDate(endDate.getDate());
    var dates = [];
    while (currentDate <= stopDate)  {
	dates.push(currentDate);
	const nextDate = new Date();
	nextDate.setDate(currentDate.getDate() + 1);
	currentDate = nextDate;
    }
    return dates;
};

const formatDateTime = (datetime) => {
    const dateFormatter = require('dateformat')
    const formatString = "yyyy-MM-dd HH:mm";
    return dateFormatter(datetime, formatString)
};

export {datesBetween, formatDateTime};
