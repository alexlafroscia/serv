import Router from 'preact-router';
import { h, render } from 'preact';

import EnsureAuthenticated from './components/ensure-authenticated';

import Files from './pages/files';
import File from './pages/file';
import Instance from './pages/instance';

const Main = () => (
  <EnsureAuthenticated>
    <Router>
      <Files path="/ui" />
      <File path="/ui/:fileId" />
      <Instance path="/ui/:fileId/:instanceId" />
    </Router>
  </EnsureAuthenticated>
);

render(<Main />, document.getElementById('preact-router-anchor'));
