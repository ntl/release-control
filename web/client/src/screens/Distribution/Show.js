import React from 'react'
import * as UI from 'semantic-ui-react'

const Show = ({ match }) => (
  <div>
    <UI.Header as="h1">
      Distribution: {match.params.distribution}
    </UI.Header>
  </div>
)

export default Show
