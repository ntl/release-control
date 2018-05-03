import React, { Component } from 'react'
import { Link } from 'react-router-dom'
import * as UI from 'semantic-ui-react'
import classNames from 'classnames'

const rowClassNames = (current) => {
  return classNames(
    "current",
    { "not": !current }
  )
}

const DistributionCell = ({ component, pkg, version, recentVersions }) => {
  if(version) {
    return (
      <UI.Table.Cell>
        <Link to={"/packages/" + component + "/" + pkg + "?version=" + version}>
          {version}
        </Link>

        <span style={{ marginLeft: "10px" }}>
          {recentVersions.map((version) => (
            <sup key={version} style={{ marginRight: "5px" }}>
              <Link to={"/packages/" + component + "/" + pkg + "?version=" + version}>
                ({version})
              </Link>
            </sup>
          ))}
        </span>
      </UI.Table.Cell>
    )
  } else {
    return (
      <UI.Table.Cell>
        Not present
      </UI.Table.Cell>
    )
  }
}

const Package = ({ pkg, component }) => (
  <UI.Table.Row className={classNames("current", { "not": pkg.current })}>
    <UI.Table.Cell>
      { pkg.name }
    </UI.Table.Cell>

    {pkg.distributions.map((d) => (
      <DistributionCell
        key={d.name}
        pkg={pkg.name}
        component={component}
        version={d.version}
        recentVersions={d.recentVersions}
      />
    ))}
  </UI.Table.Row>
)

class List extends Component {
  state = {
    packages: []
  }

  componentDidMount() {
    this.getPackages()
  }

  getPackages() {
    let packages = [
      {
        name: "some-current-service",
        description: "Some current service description",
        current: true,
        distributions: [
          {
            name: "pre-release",
            version: "2.2.2",
            recentVersions: ["2.2.1", "2.2.0", "2.1.2"]
          },{
            name: "release",
            version: "2.2.2",
            recentVersions: ["2.2.1", "2.2.0", "2.1.2"]
          }
        ]
      },{
        name: "some-service",
        description: "Some service description",
        current: false,
        distributions: [
          {
            name: "pre-release",
            version: "1.1.1",
            recentVersions: ["1.1.0", "1.0.1", "1.0.0"]
          },{
            name: "release",
            version: "1.1.0",
            recentVersions: ["1.0.1", "1.0.0"]
          }
        ]
      },{
        name: "other-service",
        description: "Other service description",
        current: false,
        distributions: [
          {
            name: "pre-release",
            version: "0.1.1",
            recentVersions: ["0.1.0", "0.0.1"]
          },{
            name: "release"
          }
        ]
      }
    ]

    this.setPackages({ packages })
  }

  setPackages(packages) {
    this.setState(packages)
  }

  render() {
    const component = this.props.match.params.component
    const packages = this.state.packages

    return (
      <div>
        <UI.Header as="h1">
          Packages (Component: {component})
        </UI.Header>

        <UI.Table compact id="packages" className="package-list">
          <UI.Table.Header>
            <UI.Table.Row>
              <UI.Table.HeaderCell>
                Package
              </UI.Table.HeaderCell>
              <UI.Table.HeaderCell>
                Pre-Release
              </UI.Table.HeaderCell>
              <UI.Table.HeaderCell>
                Release
              </UI.Table.HeaderCell>
            </UI.Table.Row>
          </UI.Table.Header>

          <UI.Table.Body>
            {packages.map((pkg) => (
              <Package key={pkg.name} pkg={pkg} component={component} />
            ))}
          </UI.Table.Body>
        </UI.Table>
      </div>
    )
  }
}

export default List
