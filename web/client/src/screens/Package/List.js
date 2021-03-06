import React, { Component } from 'react'
import { Link } from 'react-router-dom'
import * as UI from 'semantic-ui-react'
import classNames from 'classnames'

import UploadPackage from '../../components/Package/Upload'

import './index.css'

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

class Package extends Component {
  getCurrent(pkg, distributions) {
    return pkg.versions.every((version) => {
      return distributions.every((distribution) => {
        let current = version.distributions.includes(distribution.name)

        return current
      })
    })
  }

  render() {
    let pkg = this.props.pkg
    let distributions = this.props.distributions

    let current = this.getCurrent(pkg, distributions)

    return (
      <UI.Table.Row className={classNames({ "current": current })}>
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
  }
}

class List extends Component {
  render() {
    const repository = this.props.repository

    const refreshRepository = this.props.refreshRepository

    const packages = repository.packages || []
    const distributions = repository.distributions || []

    return (
      <div>
        <UI.Header as="h1">
          Packages
        </UI.Header>

        <UI.Segment inverted>
          <UploadPackage inverted distributions={distributions} refreshRepository={refreshRepository} />
        </UI.Segment>

        <UI.Table compact id="package-list">
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
