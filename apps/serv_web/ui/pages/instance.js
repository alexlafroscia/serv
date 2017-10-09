import { h, Component } from 'preact';
import { Link } from 'preact-router/match';

import BreadCrumbs from '../components/breadcrumbs';
import FileUploader from '../components/file-uploader';

import fetch from '../utils/fetch';
import fileName from '../utils/file-name';
import formatDate from '../utils/format-date';

export default class extends Component {
  constructor() {
    super();

    this.state = {
      file: undefined,
      instance: undefined
    };
  }

  componentWillMount() {
    const { fileId, instanceId } = this.props;

    fetch(`/api/files/${fileId}?include=instances`)
      .then(res => res.json())
      .then(({ data, included = [] }) => {
        this.setState({
          file: data,
          instance: included
            .filter(data => data.type === 'instances')
            .find(data => data.id == instanceId)
        });
      });
  }

  render({ fileId }, { file, instance }) {
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
          {file && instance ? (
            <BreadCrumbs>
              <Link href="/">Files</Link>
              <Link href={`/${fileId}`}>{fileName(file)}</Link>
              {instance.attributes.hash}
            </BreadCrumbs>
          ) : (
            undefined
          )}

          {file && instance ? (
            <div
              style={{
                display: 'flex',
                flexDirection: 'column',
                flexGrow: '1'
              }}
            >
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
                      {formatDate(instance.attributes['created-at'])}
                    </div>
                  </div>
                </div>
              </div>

              <iframe
                style={{ flexGrow: '1', marginBottom: '1em', width: '100%' }}
                src={`/${fileName(file)}?${instance.attributes.hash}`}
              />
            </div>
          ) : (
            undefined
          )}
        </div>
      </FileUploader>
    );
  }
}
