import React, { Component } from 'react'
import * as UI from 'semantic-ui-react'
import classNames from 'classnames'

import './index.css'

class Version extends Component {
  getCurrent(version, distributions) {
    return distributions.every((d) => {
      return version.distributions.includes(d.name)
    })
  }

  render() {
    const version = this.props.version
    const distributions = this.props.distributions

    let current = this.getCurrent(version, distributions)

    return (
      <UI.Table.Row className={classNames({ "current": current })}>
        <UI.Table.Cell>
          {version.value}
        </UI.Table.Cell>
        {distributions.map((distribution, index) => (
          <UI.Table.Cell key={index}>
            {version.distributions.includes(distribution.name) ? '✔' : 'Add'}
          </UI.Table.Cell>
        ))}
      </UI.Table.Row>
    )
  }
}

class Show extends Component {
  render() {
    const repository = this.props.repository

    const packageName = this.props.match.params.packageName

    const packages = repository.packages || []
    const distributions = repository.distributions || []

    let pkg = packages.find((pkg) => {
      return pkg.name === packageName
    })

    let versions = pkg ? pkg.versions : []

    return (
      <div>
        <UI.Header as="h1">
          Package: {packageName}
        </UI.Header>

        <UI.Table compact id="package">
          <UI.Table.Header>
            <UI.Table.Row>
              <UI.Table.HeaderCell>
                Version
              </UI.Table.HeaderCell>
              {distributions.map((distribution, index) => (
                <UI.Table.HeaderCell key={index}>
                  {distribution.name}
                </UI.Table.HeaderCell>
              ))}
            </UI.Table.Row>
          </UI.Table.Header>

          <UI.Table.Body>
            {versions.map((version, index) => (
              <Version key={index} version={version} distributions={distributions} />
            ))}
          </UI.Table.Body>
        </UI.Table>

      </div>
    )
  }
}

export default Show
