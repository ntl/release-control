const URI = (path) => {
  let host = process.env['REACT_APP_SERVER_HOST']

  if(path[0] !== '/') {
    path = `/${path}`
  }

  if(host == null) {
    host = window.location.host
  }

  return `http://${host}${path}`
}

export default URI
