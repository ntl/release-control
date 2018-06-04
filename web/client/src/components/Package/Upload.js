import React, { Component } from 'react'

import * as UI from 'semantic-ui-react'

import PascalCase from 'pascalcase'
import request from 'request'

const TitleCase = (str) => {
  return PascalCase(str).replace(/([a-z])([A-Z])/g, "$1 $2")
}

class ErrorMessage extends Component {
  render() {
    const text = this.props.text

    if(!text) {
      return null
    } else {
      return (
        <UI.Message negative>
          <UI.Message.Header>
            Package upload failed
          </UI.Message.Header>

          {text}
        </UI.Message>
      )
    }
  }
}

class UploadPackage extends Component {
  state = {
    distribution: null,
    distributions: []
  }

  componentWillMount = () => {
    let distribution = null

    if(this.props.selectedDistribution) {
      distribution = this.props.selectedDistribution.name
    }

    this.setState({
      distribution: distribution,
      distributions: this.props.distributions
    })
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
        if(err) {
          console.log(err)
          this.setState({ errorMessage: "Generic upload failure" })
          return
        }

        console.log(httpResponse)
      }))
    }

    fileReader.readAsArrayBuffer(file)
  }

  fileSelected = (e) => {
    const fieldName = e.target.name
    const file = e.target.files[0]

    const nextState = {}

    nextState[fieldName] = file

    this.setState(nextState)
  }

  distributionSelected = (e) => {
    const distribution = e.target.value

    this.setState({ distribution })
  }

  render() {
    const distribution = this.state.distribution

    const distributions = this.state.distributions

    const errorMessage = this.state.errorMessage

    return (
      <UI.Form action="/packages" size="small" onSubmit={this.submit}>
        <ErrorMessage text={errorMessage} />

        <UI.Form.Group inline>
          <UI.Form.Field
           required
           onChange={this.fileSelected}
           label="Upload"
           name="file"
           control="input"
           type="file" />

          <UI.Form.Field
           required
           onChange={this.distributionSelected}
           defaultValue={distribution}
           label="Distribution"
           name="distribution"
           control="select" >
            {distributions.map((distribution, index) => (
              <option key={index} value={distribution.name}>
               {TitleCase(distribution.name)}
              </option>
            ))}
          </UI.Form.Field>
        </UI.Form.Group>

        <button type="submit">Submit</button>
      </UI.Form>
    )
  }
}

export default UploadPackage
