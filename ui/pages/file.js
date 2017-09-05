import { h, Component } from 'preact';
import { Link } from 'preact-router/match';

import FileUploader from '../components/file-uploader';
import ListItem from '../components/list-item';
import BreadCrumbs from '../components/breadcrumbs';

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
          <BreadCrumbs>
            <Link href="/ui">Files</Link>
            {fileName}
          </BreadCrumbs>

          {instances.map(instance => (
            <ListItem
              title={instance.id}
              linkHref={`/ui/${fileName}/${instance.id}`}
              fileHref={`/${fileName}?${instance.id}`}
            />
          ))}
        </div>
      </FileUploader>
    );
  }
}
