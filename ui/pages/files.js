import { h, Component } from 'preact';
import FileList from '../components/file-list';

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
      <div>
        <h1>Files</h1>
        <FileList files={files} />
      </div>
    );
  }
}
