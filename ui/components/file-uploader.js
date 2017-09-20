import { h, Component } from 'preact';

import fetch from '../utils/fetch';

const BACKGROUND_HIGHLIGHT_COLOR = '#ADE1E5';

function stopEvent(event) {
  event.preventDefault();
  event.stopPropagation();
}

export default class extends Component {
  constructor() {
    super();

    this.state = {
      isReceiving: false,
      files: []
    };
  }

  onDragEnter(event) {
    stopEvent(event);

    this.setState({ isReceiving: true });
  }

  onDragLeave(event) {
    stopEvent(event);

    this.setState({ isReceiving: false });
  }

  onDrop(event) {
    stopEvent(event);

    const newFiles = Array.from(event.dataTransfer.files);

    this.setState({
      files: this.state.files.concat(newFiles),
      isReceiving: false
    });
  }

  uploadFiles(event) {
    stopEvent(event);

    return Promise.all(
      this.state.files.map(file => {
        const form = new FormData();
        form.append('file', file);

        return fetch('/upload', {
          method: 'POST',
          body: form
        });
      })
    ).then(() => {
      this.setState({ files: [] });
    });
  }

  removeFile(file) {
    const { files } = this.state;
    const fileIndex = files.indexOf(file);
    files.splice(fileIndex, 1);

    this.setState({
      files
    });
  }

  render({ children }, { files, isReceiving }) {
    const onDragEnter = this.onDragEnter.bind(this);
    const onDragLeave = this.onDragLeave.bind(this);
    const onDrop = this.onDrop.bind(this);
    const uploadFiles = this.uploadFiles.bind(this);
    const removeFile = file => {
      return event => {
        stopEvent(event);

        this.removeFile(file);
      };
    };

    return (
      <div
        onDragEnter={onDragEnter}
        onDragOver={onDragEnter}
        onDragLeave={onDragLeave}
        onDragEnd={onDragLeave}
        onDrop={onDrop}
        style={{
          backgroundColor: isReceiving ? BACKGROUND_HIGHLIGHT_COLOR : 'white',
          minHeight: '100vh'
        }}
      >
        {files.length ? (
          <div
            class="container"
            style={{
              alignItems: 'center',
              display: 'flex',
              margin: '1em auto'
            }}
          >
            <div style={{ flexGrow: 1, marginRight: '1em' }}>
              {files.map(file => {
                return (
                  <div style={{ display: 'flex' }}>
                    <strong style={{ flexGrow: 1 }}>{file.name}</strong>
                    <button
                      style={{
                        background: 'white',
                        border: 'none',
                        color: 'red',
                        fontSize: '0.8em',
                        margin: '0',
                        padding: '0'
                      }}
                      onClick={removeFile(file)}
                    >
                      Remove
                    </button>
                  </div>
                );
              })}
            </div>
            <button class="btn btn-primary" onClick={uploadFiles}>
              Upload
            </button>
          </div>
        ) : (
          undefined
        )}
        {children}
      </div>
    );
  }
}
