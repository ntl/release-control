import React from 'react'
import * as UI from 'semantic-ui-react'

const Show = ({ match }) => (
  <div>
    <UI.Header as="h1">
      Package: {match.params.package}
    </UI.Header>
  </div>
)

export default Show
