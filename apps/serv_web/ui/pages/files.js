import { h, Component } from 'preact';

import BreadCrumbs from '../components/breadcrumbs';
import FileUploader from '../components/file-uploader';
import ListItem from '../components/list-item';

import fetch from '../utils/fetch';

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
          <BreadCrumbs>Files</BreadCrumbs>

          {files.map(file => {
            const { attributes } = file;
            const fileName = `${attributes.name}.${attributes.extension}`;

            return (
              <ListItem
                title={fileName}
                linkHref={`/${file.id}`}
                fileHref={`/${fileName}`}
              />
            );
          })}
        </div>
      </FileUploader>
    );
  }
}
