import React, { Component } from 'react'
// import { Link } from 'react-router-dom'
import * as UI from 'semantic-ui-react'
import classNames from 'classnames'
import request from 'request'

const DistributionCell = ({ distribution, versions }) => {
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
      {recentVersions.map((version) => (
        <span className="version" key={version}>{version}</span>
      ))}
    </UI.Table.Cell>
  )
}

const Package = ({ pkg, distributions }) => (
  <UI.Table.Row className={classNames("current", { "not": pkg.current })}>
    <UI.Table.Cell>
      {pkg.name}
    </UI.Table.Cell>

    {distributions.map((distribution) => (
      <DistributionCell
        key={distribution}
        distribution={distribution}
        versions={pkg.versions}
      />
    ))}
  </UI.Table.Row>
)

class List extends Component {
  state = {
    distributions: [],
    packages: []
  }

  componentDidMount() {
    this.getPackages()
  }

  getPackages() {
    let host = process.env['REACT_APP_SERVER_HOST']

    request(`http://${host}/controls/repository`, (error, response, body) => {
      let responseData = JSON.parse(body)

      let distributions = responseData.distributions.map((d) => {
        return d.name
      })

      let packages = responseData.packages

      this.setDistributions(distributions)
      this.setPackages(packages)
    })
  }

  setDistributions(distributions) {
    this.setState({ distributions })
  }

  setPackages(packages) {
    this.setState({ packages })
  }

  render() {
    const packages = this.state.packages
    const distributions = this.state.distributions

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
              {distributions.map((distribution) => (
                <UI.Table.HeaderCell key={distribution}>
                  {distribution}
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
