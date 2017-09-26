import { Component, h } from 'preact';

export default class Tag extends Component {
  setupDragEvent(event) {
    const tagJson = JSON.stringify(this.props.tag);

    event.dataTransfer.setData('serv/tag', tagJson);
  }

  render({ tag, draggable = false }) {
    const onDragStart = this.setupDragEvent.bind(this);

    return (
      <span
        draggable={draggable}
        onDragStart={onDragStart}
        class="label label-primary"
        style={{ marginLeft: '4px', display: 'inline-block' }}
      >
        {tag.attributes.label}
      </span>
    );
  }
}
