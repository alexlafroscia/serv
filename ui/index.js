import Router from 'preact-router';
import { h, render } from 'preact';

import Files from './pages/files';
import File from './pages/file';
import Instance from './pages/instance';

const Main = () => (
  <Router>
    <Files path="/ui" />
    <File path="/ui/:fileName" />
    <Instance path="/ui/:fileName/:instanceId" />
  </Router>
);

render(<Main />, document.getElementById('preact-router-anchor'));
