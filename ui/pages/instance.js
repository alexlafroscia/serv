import { h, Component } from 'preact';
import { Link } from 'preact-router/match';

import BreadCrumbs from '../components/breadcrumbs';
import FileUploader from '../components/file-uploader';

import fetch from '../utils/fetch';
import formatDate from '../utils/format-date';

export default class extends Component {
  constructor() {
    super();

    this.state = {
      file: {},
      instance: {}
    };
  }

  componentWillMount() {
    const { fileName, instanceId } = this.props;

    fetch(`/api/files/${fileName}?include=instances`)
      .then(res => res.json())
      .then(({ data, included = [] }) => {
        const { file } = data;
        const instance = included
          .filter(data => data.type === 'instance')
          .find(instance => instance.id === instanceId);

        this.setState({ file, instance });
      });
  }

  render({ fileName, instanceId }, { instance }) {
    return (
      <FileUploader>
        <div
          class="container"
          style={{
            display: 'flex',
            flexDirection: 'column',
            height: '100vh'
          }}
        >
          <BreadCrumbs>
            <Link href="/ui">Files</Link>
            <Link href={`/ui/${fileName}`}>{fileName}</Link>
            {instanceId}
          </BreadCrumbs>

          {instance.attributes ? (
            <div class="well">
              <div class="container-fluid">
                <div class="row">
                  <div
                    class="col-xs-12 col-sm-2"
                    style={{ fontWeight: 'bold' }}
                  >
                    Uploaded:
                  </div>
                  <div class="col-xs-12 col-sm-10">
                    {formatDate(instance.attributes['uploaded-at'])}
                  </div>
                </div>
              </div>
            </div>
          ) : (
            undefined
          )}

          <iframe
            style={{ flexGrow: '1', marginBottom: '1em', width: '100%' }}
            src={`/${fileName}?${instanceId}`}
          />
        </div>
      </FileUploader>
    );
  }
}
