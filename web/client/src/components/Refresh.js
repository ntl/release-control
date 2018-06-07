import React, { Component } from 'react'

import * as UI from 'semantic-ui-react'

class Refresh extends Component {
  render() {
    const lastRefreshTime = this.props.lastRefreshTime

    const refreshRepository = this.props.refreshRepository

    return (
      <UI.Segment inverted>
        Last refreshed: <br />
        <small>{lastRefreshTime}</small>

        <UI.Button
         content='Refresh'
         icon='refresh'
         labelPosition='left'
         onClick={refreshRepository}
        />
      </UI.Segment>
    )
  }
}

export default Refresh
