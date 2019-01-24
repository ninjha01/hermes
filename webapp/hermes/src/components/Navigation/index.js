import React from 'react';
import { Link } from 'react-router-dom';

import SignOut from '../SignOut';
import * as ROUTES from '../../constants/routes';

import { AuthUserContext } from '../Session';

const Navigation = () => (
	<div className="nav">
	<AuthUserContext.Consumer>
	{authUser =>
         authUser ? <NavigationAuth /> : <NavigationNonAuth />
	}
    </AuthUserContext.Consumer>
	</div>
);

const NavigationAuth = () => (
	<ul>
	<li>
	<Link to={ROUTES.LANDING}>Landing</Link>
	</li>
	<li>
	<Link to={ROUTES.HOME}>Home</Link>
	</li>
	<li>
	<Link to={ROUTES.ACCOUNT}>Account</Link>
	</li>
	<li>
	<Link to={ROUTES.EXERCISES}>Exercises</Link>
	</li>
	<li>
	<Link to={ROUTES.USERS}>Users</Link>
	</li>
	<li>
	<Link to={ROUTES.ASSIGN}>Assign</Link>
	</li>
	<li>
	<Link to={ROUTES.ASSESMENTS}>Assesments</Link>
	</li>
	<li>
	<SignOut />
	</li>
	</ul>
);

const NavigationNonAuth = () => (
	<ul>
	<li>
	<Link to={ROUTES.LANDING}>Landing</Link>
	</li>
	<li>
	<Link to={ROUTES.SIGN_IN}>Sign In</Link>
	</li>
	</ul>
);

export default Navigation;
