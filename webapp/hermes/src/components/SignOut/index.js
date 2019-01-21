import React from 'react';

import { withFirebase } from '../Firebase';

const SignOutButton = ({ firebase }) => (
  <input value="Sign Out" type="button" onClick={firebase.doSignOut} />
);

export default withFirebase(SignOutButton);
