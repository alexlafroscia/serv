import { h } from 'preact';

export default ({ children }) => {
  return (
    <div style={{ fontSize: '1.5em', margin: '1em 0' }}>
      {children.reduce((acc, child) => {
        if (acc.length !== 0) {
          acc.push(' › ');
        }

        acc.push(child);

        return acc;
      }, [])}
    </div>
  );
};
