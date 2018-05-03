import React, { Component } from 'react'
import * as UI from 'semantic-ui-react'
import classNames from 'classnames'

const Release = ({ release }) => (
  <UI.Table.Row className={classNames("current", { "not": !release.current })}>
    <UI.Table.Cell>
      {release.version}
    </UI.Table.Cell>
    <UI.Table.Cell>
      {release.distributions.includes("pre-release") ? 'Yes' : 'No'}
    </UI.Table.Cell>
    <UI.Table.Cell>
      {release.distributions.includes("release") ? 'Yes' : 'No'}
    </UI.Table.Cell>
  </UI.Table.Row>
)

class Show extends Component {
  state = {
    pkg: {
      releases: []
    }
  }

  componentDidMount() {
    this.getPackage()
  }

  getPackage() {
    const name = this.props.match.params.package

    let pkg = {
      name: name,
      description: "Some description",
      releases: [
        {
          version: "1.1.1",
          distributions: ["pre-release"],
          current: false
        },{
          version: "1.1.0",
          distributions: ["pre-release"],
          current: false
        },{
          version: "1.0.1",
          distributions: ["pre-release", "release"],
          current: true
        },{
          version: "1.0.0",
          distributions: ["pre-release", "release"],
          current: true
        },{
          version: "1.0.0.pre1",
          distributions: ["pre-release", "release"],
          current: true
        },{
          version: "0.9.0",
          distributions: ["pre-release", "release"],
          current: true
        }
      ]
    }

    this.setPackage(pkg)
  }

  setPackage(pkg) {
    this.setState({ pkg })
  }

  render() {
    const pkg = this.state.pkg

    const component = this.props.match.params.component

    return (
      <div>
        <UI.Header as="h1">
          Package: {pkg.name} ({component})
        </UI.Header>

        <UI.Table compact id="package-releases" className="package-list">
          <UI.Table.Header>
            <UI.Table.Row>
              <UI.Table.HeaderCell>
                Version
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
            {pkg.releases.map((release) => (
              <Release key={release.version} release={release} />
            ))}
          </UI.Table.Body>
        </UI.Table>

      </div>
    )
  }
}

export default Show
