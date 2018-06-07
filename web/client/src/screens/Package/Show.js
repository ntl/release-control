import React, { Component } from 'react'
import { Link } from 'react-router-dom'
import request from 'request'

import * as UI from 'semantic-ui-react'
import classNames from 'classnames'

import UploadPackage from '../../components/Package/Upload'

import './index.css'

class DistributionCell extends Component {
  state = {
    distribution: null,
    packageName: null,
    version: {
      distributions: []
    }
  }

  add = () => {
    let state = this.state

    let sourceDistribution = state.version.distributions.find((d) => {
      return d.name !== state.distribution.name
    })

    let requestBody = {
      package: state.packageName,
      version: state.version.value,
      sourceDistribution: sourceDistribution,
      targetDistribution: state.distribution.name
    }

    const host = process.env['REACT_APP_SERVER_HOST']

    const uri = `http://${host}/copy-package`

    request.post({ url: uri, form: requestBody }, ((err, httpResponse) => {
      //console.log(err)
    }))
  }

  remove = () => {
    let state = this.state

    let requestBody = {
      package: state.packageName,
      version: state.version.value,
      distribution: state.distribution.name
    }

    const host = process.env['REACT_APP_SERVER_HOST']

    const uri = `http://${host}/remove-package`

    request.post({ url: uri, form: requestBody }, ((err, httpResponse) => {
      //console.log(err)
    }))
  }

  componentWillMount() {
    this.setState({
      packageName: this.props.packageName,
      distribution: this.props.distribution,
      version: this.props.version
    })
  }

  render() {
    const distribution = this.state.distribution
    const version = this.state.version

    const added = version.distributions.includes(distribution.name)

    if(added) {
      return (
        <UI.Table.Cell>
          <UI.Button content='Remove' icon='minus circle' labelPosition='left' color='red' onClick={this.remove} />
        </UI.Table.Cell>
      )
    } else {
      return (
        <UI.Table.Cell>
          <UI.Button content='Add' icon='plus square' labelPosition='left' color='green' onClick={this.add} />
        </UI.Table.Cell>
      )
    }
  }
}

class Version extends Component {
  getCurrent(version, distributions) {
    return distributions.every((d) => {
      return version.distributions.includes(d.name)
    })
  }

  render() {
    const version = this.props.version
    const distributions = this.props.distributions
    const packageName = this.props.packageName

    let current = this.getCurrent(version, distributions)

    return (
      <UI.Table.Row className={classNames({ "current": current })}>
        <UI.Table.Cell>
          {version.value}
        </UI.Table.Cell>
        {distributions.map((distribution, index) => (
          <DistributionCell key={index} packageName={packageName} version={version} distribution={distribution} />
        ))}
        <UI.Table.Cell>
          <Link to={`/packages/${packageName}/${version.value}`}>
            View
          </Link>
        </UI.Table.Cell>
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

        <UI.Segment inverted>
          <UploadPackage inverted  distributions={distributions} />
        </UI.Segment>

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
              <UI.Table.HeaderCell>
              </UI.Table.HeaderCell>
            </UI.Table.Row>
          </UI.Table.Header>

          <UI.Table.Body>
            {versions.map((version, index) => (
              <Version
                key={index}
                version={version}
                distribution='pre-release'
                distributions={distributions}
                packageName={packageName}
              />
            ))}
          </UI.Table.Body>
        </UI.Table>

      </div>
    )
  }
}

export default Show
