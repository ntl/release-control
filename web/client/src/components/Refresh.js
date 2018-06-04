import React, { Component } from 'react'

import * as UI from 'semantic-ui-react'

class Refresh extends Component {
  render() {
    const lastSyncTime = this.props.lastSyncTime

    const getRepository = this.props.getRepository

    return (
      <UI.Segment inverted>
        Last synced: <small>{lastSyncTime}</small>

        <UI.Button content='Refresh' icon='refresh' labelPosition='left' onClick={getRepository} />
      </UI.Segment>
    )
  }
}

export default Refresh
