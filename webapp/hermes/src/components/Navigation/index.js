import React from 'react';
import { Link } from 'react-router-dom';

import * as ROUTES from '../../constants/routes';

const Navigation = () => (
  <div>
    <ul>
      <li>
        <Link to={ROUTES.USERS}>Users</Link>
      </li>
      <li>
        <Link to={ROUTES.EXERCISES}>Exercises</Link>
      </li>
      <li>
        <Link to={ROUTES.ASSESMENTS}>Assesments</Link>
      </li>
    </ul>
  </div>
);

export default Navigation;
