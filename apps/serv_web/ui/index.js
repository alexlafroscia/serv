import Router from 'preact-router';
import { h, render } from 'preact';

import EnsureAuthenticated from './components/ensure-authenticated';

import Files from './pages/files';
import File from './pages/file';
import Instance from './pages/instance';

const Main = () => (
  <EnsureAuthenticated>
    <Router>
      <Files path="/" />
      <File path="/:fileId" />
      <Instance path="/:fileId/:instanceId" />
    </Router>
  </EnsureAuthenticated>
);

render(<Main />, document.getElementById('preact-router-anchor'));
