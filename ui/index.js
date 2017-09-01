import Router from 'preact-router';
import { h, render } from 'preact';

import Files from './pages/files';

const Main = () => (
  <Router>
    <Files path="/ui" />
  </Router>
);

render(<Main />, document.getElementById('preact-router-anchor'));
