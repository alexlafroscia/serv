import { h } from 'preact';
import { Link } from 'preact-router/match';

export default ({ linkHref = '#', fileHref, title, detailText }) => {
  return (
    <div
      style={{
        borderBottom: '1px solid lightgrey',
        display: 'flex',
        margin: '1em 0',
        padding: '1em 0'
      }}
    >
      <div style={{ display: 'flex', flexDirection: 'column', flexGrow: '1' }}>
        <Link href={linkHref}>
          <strong>{title}</strong>
        </Link>

        {detailText ? (
          <div style={{ color: 'grey' }}>{detailText}</div>
        ) : (
          undefined
        )}
      </div>

      {fileHref ? <a href={fileHref}>View File</a> : undefined}
    </div>
  );
};
