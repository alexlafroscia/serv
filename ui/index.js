import Router from 'preact-router';
import { h, render } from 'preact';

import Files from './pages/files';
import File from './pages/file';

const Main = () => (
  <Router>
    <Files path="/ui" />
    <File path="/ui/:fileName" />
  </Router>
);

render(<Main />, document.getElementById('preact-router-anchor'));
