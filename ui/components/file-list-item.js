import { h } from 'preact';

export default ({ file }) => {
  const { name, extension } = file.attributes;

  return (
    <div>
      <strong>
        {name}.{extension}
      </strong>

      <hr />
    </div>
  );
};
