import { h, Component } from 'preact';
import { Link } from 'preact-router/match';

import FileUploader from '../components/file-uploader';
import ListItem from '../components/list-item';
import BreadCrumbs from '../components/breadcrumbs';

import fetch from '../utils/fetch';
import fileName from '../utils/file-name';
import formatDate from '../utils/format-date';

export default class extends Component {
  constructor() {
    super();

    this.state = {
      file: {},
      instances: []
    };
  }

  componentWillMount() {
    const { fileId } = this.props;

    fetch(`/api/files/${fileId}?include=instances,tags`)
      .then(res => res.json())
      .then(({ data, included = [] }) => {
        this.setState({
          file: data,
          instances: included.filter(data => data.type === 'instances')
        });
      });
  }

  render(_, { file, instances }) {
    const name = fileName(file);

    return (
      <FileUploader>
        <div class="container">
          <BreadCrumbs>
            <Link href="/ui">Files</Link>
            {name}
          </BreadCrumbs>

          {instances.map(instance => (
            <ListItem
              title={instance.attributes.hash}
              detailText={formatDate(instance.attributes['created-at'])}
              linkHref={`/ui/${file.id}/${instance.id}`}
              fileHref={`/${name}?${instance.attributes.hash}`}
            />
          ))}
        </div>
      </FileUploader>
    );
  }
}
