import React, { Component } from 'react'
import * as UI from 'semantic-ui-react'

class ShowVersion extends Component {
  render() {
    const params = this.props.match.params

    const repository = this.props.repository

    let pkg = repository.packages.find((pkg) => {
      return pkg.name === params.packageName
    })

    let version = null
    if(pkg) {
      version = pkg.versions.find((version) => {
        return version.value === params.version
      })
    }
    version = version || {}

    return (
      <div>
        <UI.Header as="h1">
          Package: {params.packageName} ({params.version})
        </UI.Header>

        <UI.Table compact id="package-version">
          <UI.Table.Body>
            <UI.Table.Row>
              <UI.Table.HeaderCell>
                Description
              </UI.Table.HeaderCell>
              <UI.Table.Cell>
                {version.description || 'N/A'}
              </UI.Table.Cell>
            </UI.Table.Row>

            <UI.Table.Row>
              <UI.Table.HeaderCell>
                Section
              </UI.Table.HeaderCell>
              <UI.Table.Cell>
                {version.section || 'N/A'}
              </UI.Table.Cell>
            </UI.Table.Row>

            <UI.Table.Row>
              <UI.Table.HeaderCell>
                Depends
              </UI.Table.HeaderCell>
              <UI.Table.Cell>
                {version.depends || 'N/A'}
              </UI.Table.Cell>
            </UI.Table.Row>

            <UI.Table.Row>
              <UI.Table.HeaderCell>
                Maintainer
              </UI.Table.HeaderCell>
              <UI.Table.Cell>
                {version.maintainer || 'N/A'}
              </UI.Table.Cell>
            </UI.Table.Row>

            <UI.Table.Row>
              <UI.Table.HeaderCell>
                Homepage
              </UI.Table.HeaderCell>
              <UI.Table.Cell>
                {version.homepage || 'N/A'}
              </UI.Table.Cell>
            </UI.Table.Row>
          </UI.Table.Body>
        </UI.Table>
      </div>
    )
  }
}

export default ShowVersion
