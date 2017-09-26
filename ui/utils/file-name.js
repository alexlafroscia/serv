export default function fileName(file) {
  if (file && file.attributes) {
    return file.attributes.name + '.' + file.attributes.extension;
  }
}
