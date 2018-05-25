import React, { Component } from 'react'
import * as UI from 'semantic-ui-react'

class Show extends Component {
  render() {
    const params = this.props.match.params

    let distribution = this.props.repository.distributions.find((d) => {
      return d.name === params.distribution
    })
    distribution = distribution || {}

    return (
      <div>
        <UI.Header as="h1">
          Distribution: {distribution.name}
        </UI.Header>

        <UI.Table compact id="package-version">
          <UI.Table.Body>
            <UI.Table.Row>
              <UI.Table.HeaderCell>
                Description
              </UI.Table.HeaderCell>
              <UI.Table.Cell>
                {distribution.description || 'N/A'}
              </UI.Table.Cell>
            </UI.Table.Row>

            <UI.Table.Row>
              <UI.Table.HeaderCell>
                Last Updated
              </UI.Table.HeaderCell>
              <UI.Table.Cell>
                {distribution.date || 'N/A'}
              </UI.Table.Cell>
            </UI.Table.Row>

            <UI.Table.Row>
              <UI.Table.HeaderCell>
                Origin
              </UI.Table.HeaderCell>
              <UI.Table.Cell>
                {distribution.origin || 'N/A'}
              </UI.Table.Cell>
            </UI.Table.Row>

            <UI.Table.Row>
              <UI.Table.HeaderCell>
                Label
              </UI.Table.HeaderCell>
              <UI.Table.Cell>
                {distribution.label || 'N/A'}
              </UI.Table.Cell>
            </UI.Table.Row>

            <UI.Table.Row>
              <UI.Table.HeaderCell>
                Version
              </UI.Table.HeaderCell>
              <UI.Table.Cell>
                {distribution.version || 'N/A'}
              </UI.Table.Cell>
            </UI.Table.Row>
          </UI.Table.Body>
        </UI.Table>
      </div>
    )
  }
}

export default Show
