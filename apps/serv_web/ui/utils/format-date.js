const formatter = new Intl.DateTimeFormat('en-US', {
  weekday: 'long',
  year: 'numeric',
  month: 'long',
  day: 'numeric',
  hour: 'numeric',
  minute: 'numeric'
});

export default function formatDate(dateString) {
  const date = new Date(dateString);

  return formatter.format(date);
}
