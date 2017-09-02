import { h } from 'preact';
import { Link } from 'preact-router/match';

export default ({ linkHref = '#', fileHref, title }) => {
  return (
    <div
      style={{
        borderBottom: '1px solid lightgrey',
        display: 'flex',
        flexDirection: 'column',
        margin: '1em 0',
        padding: '1em 0'
      }}
    >
      <Link href={linkHref}>
        <strong>{title}</strong>
      </Link>

      {fileHref ? <a href={fileHref}>View File</a> : undefined}
    </div>
  );
};
