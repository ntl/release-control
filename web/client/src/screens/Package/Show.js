import React, { Component } from 'react'
import * as UI from 'semantic-ui-react'
import classNames from 'classnames'

const Version = ({ version, distributions }) => (
  <UI.Table.Row className={classNames("current", { "not": !version.current })}>
    <UI.Table.Cell>
      {version.value}
    </UI.Table.Cell>
    {distributions.map((distribution, index) => (
      <UI.Table.Cell key={index}>
        {version.distributions.includes(distribution.name) ? 'Yes' : 'No'}
      </UI.Table.Cell>
    ))}
  </UI.Table.Row>
)

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

        <UI.Table compact id="package-releases" className="package-list">
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
