import { h, Component } from 'preact';
import { Link } from 'preact-router/match';

import config from '../config';
import FileUploader from '../components/file-uploader';
import ListItem from '../components/list-item';
import BreadCrumbs from '../components/breadcrumbs';
import Tag from '../components/tag';

import fetch from '../utils/fetch';
import fileName from '../utils/file-name';
import formatDate from '../utils/format-date';

export default class extends Component {
  constructor() {
    super();

    this.state = {
      file: undefined,
      instances: [],
      tags: undefined
    };
  }

  componentWillMount() {
    this.fetchData();
  }

  fetchData() {
    const { fileId } = this.props;

    fetch(`/api/files/${fileId}?include=instances,tags`)
      .then(res => res.json())
      .then(({ data, included = [] }) => {
        const tagMap = included
          .filter(inc => inc.type === 'tags')
          .reduce((acc, tag) => {
            const instanceId = tag.relationships.instance.data.id;

            if (!acc[instanceId]) {
              acc[instanceId] = [];
            }

            acc[instanceId].push(tag);

            return acc;
          }, {});

        this.setState({
          file: data,
          instances: included.filter(data => data.type === 'instances'),
          tags: tagMap
        });
      });
  }

  updateTag(instance) {
    return event => {
      const tagJson = event.dataTransfer.getData('serv/tag');
      if (!tagJson) {
        return;
      }

      const tag = JSON.parse(tagJson);
      if (tag.relationships.instance.data.id === instance.id) {
        return;
      }

      fetch(`/api/tags/${tag.id}/relationships/instance`, {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          data: {
            type: 'instances',
            id: instance.id
          }
        })
      }).then(res => {
        if (res.ok) {
          this.fetchData();
        }
      });
    };
  }

  render(_, { file, instances, tags }) {
    const name = fileName(file);

    return (
      <FileUploader>
        <div class="container">
          <BreadCrumbs>
            <Link href="/">Files</Link>
            {name}
          </BreadCrumbs>

          {instances.map(instance => (
            <div onDrop={this.updateTag(instance)}>
              <ListItem
                title={instance.attributes.hash}
                detailText={formatDate(instance.attributes['created-at'])}
                linkHref={`/${file.id}/${instance.id}`}
                fileHref={`http://${config.fileHost}/${name}?${instance
                  .attributes.hash}`}
              >
                {tags[instance.id] ? (
                  <div>
                    Tags:
                    {tags[instance.id].map(tag => (
                      <Tag tag={tag} draggable={true} />
                    ))}
                  </div>
                ) : (
                  undefined
                )}
              </ListItem>
            </div>
          ))}
        </div>
      </FileUploader>
    );
  }
}
