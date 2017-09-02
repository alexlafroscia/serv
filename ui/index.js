import Router from 'preact-router';
import { h, render } from 'preact';

import FileUploader from './components/file-uploader';
import Files from './pages/files';

const Main = () => (
  <FileUploader>
    <div class="container">
      <Router>
        <Files path="/ui" />
      </Router>
    </div>
  </FileUploader>
);

render(<Main />, document.getElementById('preact-router-anchor'));
