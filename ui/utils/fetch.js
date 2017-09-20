export default function wrappedFetch(url, options = {}) {
  options = Object.assign({}, options, {
    headers: Object.assign(
      {},
      {
        'serv-password': sessionStorage.getItem('password')
      },
      options.headers
    )
  });

  return fetch(url, options);
}
