import { h, Component } from 'preact';

import FileUploader from '../components/file-uploader';
import ListItem from '../components/list-item';

export default class extends Component {
  constructor() {
    super();

    this.state = {
      files: []
    };
  }

  componentWillMount() {
    fetch('/api/files')
      .then(res => res.json())
      .then(({ data: files }) => {
        this.setState({ files });
      });
  }

  render() {
    const { files } = this.state;

    return (
      <FileUploader>
        <div class="container">
          <h1>Files</h1>

          {files.map(({ attributes }) => {
            const fileName = `${attributes.name}.${attributes.extension}`;

            return (
              <ListItem
                title={fileName}
                linkHref={`/ui/${fileName}`}
                fileHref={`/${fileName}`}
              />
            );
          })}
        </div>
      </FileUploader>
    );
  }
}
