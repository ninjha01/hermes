import React, {Component} from 'react';

import 'react-dates/initialize';
import { DateRangePicker } from 'react-dates';
import 'react-dates/lib/css/_datepicker.css';

class Calendar extends Component {
    constructor(props) {
	super(props);
	this.state = {
	    startDate: null,
	    stardDateID: "startDate",
	    endDate: null,
	    endDateID: "endDate",
	    focusedInput: null
	};
    }

    
    render() {
	return (<DateRangePicker
		startDate={this.state.startDate}
		startDateId="start_date"
		endDate={this.state.endDate}
		endDateId="end_date"
		onDatesChange={({startDate, endDate}) => {
		    this.setState({ startDate, endDate });
		    this.props.onChange({startDate, endDate})}}
		focusedInput={this.state.focusedInput}
		onFocusChange={focusedInput => this.setState({ focusedInput })}
		minimumNights={0}
		/>
	       );
    }
}

export default Calendar;
