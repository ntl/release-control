import React from 'react'

const Show = ({ match }) => (
  <div>
    <h1>Distribution: {match.params.distribution}</h1>
  </div>
)

export default Show
