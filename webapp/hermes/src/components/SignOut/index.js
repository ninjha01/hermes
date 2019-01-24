import React from 'react';
import { Link } from 'react-router-dom';

import { withFirebase } from '../Firebase';
import * as ROUTES from '../../constants/routes';

const SignOut = ({ firebase }) => (
	<Link to={ROUTES.LANDING} onClick={firebase.doSignOut}>Sign Out</Link>
);

export default withFirebase(SignOut);
