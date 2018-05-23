import React, { Component } from 'react'
import { Link } from 'react-router-dom'
import * as UI from 'semantic-ui-react'
import classNames from 'classnames'

const DistributionCell = ({ packageName, distribution, versions }) => {
  let recentVersions = []

  versions.forEach((version) => {
    if(version.distributions.includes(distribution)) {
      if(recentVersions.length < 3) {
        recentVersions.push(version.value)
      }
    }
  })

  return (
    <UI.Table.Cell>
      {recentVersions.map((version, index) => (
      <span className="version" key={index}>
        {version}
      </span>
      ))}
    </UI.Table.Cell>
  )
}

const Package = ({ pkg, distributions }) => (
  <UI.Table.Row className={classNames("current", { "not": pkg.current })}>
    <UI.Table.Cell>
      <Link to={`/packages/${pkg.name}`}>
        {pkg.name}
      </Link>
    </UI.Table.Cell>

    {distributions.map((distribution, index) => (
      <DistributionCell
        key={index}
        packageName={pkg.name}
        distribution={distribution.name}
        versions={pkg.versions}
      />
    ))}
  </UI.Table.Row>
)

class List extends Component {
  render() {
    const repository = this.props.repository

    const packages = repository.packages || []
    const distributions = repository.distributions || []

    return (
      <div>
        <UI.Header as="h1">
          Packages
        </UI.Header>

        <UI.Table compact id="packages" className="package-list">
          <UI.Table.Header>
            <UI.Table.Row>
              <UI.Table.HeaderCell>
                Package
              </UI.Table.HeaderCell>
              {distributions.map((distribution, index) => (
                <UI.Table.HeaderCell key={index}>
                  {distribution.name}
                </UI.Table.HeaderCell>
              ))}
            </UI.Table.Row>
          </UI.Table.Header>

          <UI.Table.Body>
            {packages.map((pkg) => (
              <Package key={pkg.name} pkg={pkg} distributions={distributions} />
            ))}
          </UI.Table.Body>
        </UI.Table>
      </div>
    )
  }
}

export default List
