import React, { Component } from 'react'

import * as UI from 'semantic-ui-react'

import request from 'request'

class Refresh extends Component {
  render() {
    const lastSyncTime = this.props.lastSyncTime

    const setRepository = this.props.setRepository

    const refresh = () => {
      const host = process.env['REACT_APP_SERVER_HOST']

      const uri = `http://${host}/repository`

      request.get(uri, ((err, httpResponse, body) => {
        let repository = JSON.parse(body)

        setRepository(repository)
      }))
    }

    return (
      <UI.Segment inverted>
        Last synced: <small>{lastSyncTime}</small>

        <UI.Button content='Refresh' icon='refresh' labelPosition='left' onClick={refresh} />
      </UI.Segment>
    )
  }
}

export default Refresh
