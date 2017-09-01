import { h } from 'preact';
import FileListItem from './file-list-item';

export default function(props) {
  return <div>{props.files.map(file => <FileListItem file={file} />)}</div>;
}
