import React, { Component } from 'react'
import { Link } from 'react-router-dom'
import * as UI from 'semantic-ui-react'
import classNames from 'classnames'
import PascalCase from 'pascalcase'
import request from 'request'

import './index.css'

const TitleCase = (str) => {
  return PascalCase(str).replace(/([a-z])([A-Z])/g, "$1 $2")
}

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

    let requestBody = {
      package: state.packageName,
      version: state.version.value,
      sourceDistribution: 'release',
      targetDistribution: state.distribution.name
    }

    const host = process.env['REACT_APP_SERVER_HOST']

    const uri = `http://${host}/copy-package`

    request.post({ url: uri, form: requestBody }, ((err, httpResponse) => {
      console.log(err)
    }))
  }

  remove() {
    console.log("Remove")
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
  state = {
    file: null,
    distribution: null
  }

  submit = (e) => {
    e.preventDefault()

    const form = e.target
    const actionURL = new URL(form.action)
    const action = actionURL.pathname.replace(/^\//, '')

    const host = process.env['REACT_APP_SERVER_HOST']

    const uri = `http://${host}/${action}`

    const { file, distribution } = this.state

    const fileReader = new window.FileReader()

    fileReader.onload = (e) => {
      let fileData = e.target.result

      request({
        method: 'POST',
        uri: uri,
        headers: { 'Content-Type': 'multipart/form-data' },
        multipart: {
          chunked: false,
          data: [
            {
              'Content-Disposition': 'form-data; name="distribution"',
              body: distribution
            },{
              'Content-Disposition': `form-data; name="file"; filename="${file.name}"`,
              'Content-Type': file.type,
              'Content-Length': file.size,
              body: fileData
            }
          ]
        }
      }, ((err, httpResponse) => {
        console.log(err)
        console.log(httpResponse)
      }))
    }

    fileReader.readAsArrayBuffer(file)
  }

  fileSelected = (e) => {
    const fieldName = e.target.name
    const file = e.target.files[0]

    const state = this.state

    state[fieldName] = file

    this.setState(state)
  }

  distributionSelected = (e) => {
    const fieldName = e.target.name
    const value = e.target.value

    const state = this.state

    state[fieldName] = value

    this.setState(state)
  }

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
          <UI.Form inverted action="/packages" size="small" onSubmit={this.submit}>
            <UI.Form.Group inline>
              <UI.Form.Field required onChange={this.fileSelected} label="Upload" name="file" control="input" type="file" />
              <UI.Form.Field required onChange={this.distributionSelected} label="Distribution" name="distribution" control="select">
                {distributions.map((distribution, index) => (
                  <option key={index} value={distribution.name}>
                    {TitleCase(distribution.name)}
                  </option>
                ))}
              </UI.Form.Field>
            </UI.Form.Group>

            <button type="submit">Submit</button>
          </UI.Form>
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
