import { h, Component } from 'preact';

import FileUploader from '../components/file-uploader';
import ListItem from '../components/list-item';

export default class extends Component {
  constructor() {
    super();

    this.state = {
      file: {},
      instances: []
    };
  }

  componentWillMount() {
    const { fileName } = this.props;

    fetch(`/api/files/${fileName}?include=instances`)
      .then(res => res.json())
      .then(({ data, included = [] }) => {
        const { file } = data;
        const instances = included.filter(data => data.type === 'instance');

        this.setState({ file, instances });
      });
  }

  render({ fileName }, { instances }) {
    return (
      <FileUploader>
        <div class="container">
          <h1>{fileName}</h1>

          {instances.map(instance => (
            <ListItem fileHref={`/${fileName}`} title={instance.id} />
          ))}
        </div>
      </FileUploader>
    );
  }
}
