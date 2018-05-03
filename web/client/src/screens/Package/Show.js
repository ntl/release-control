import React from 'react'

const Show = ({ match }) => (
  <div>
    <h1>Package: {match.params.package}</h1>
  </div>
)

export default Show
