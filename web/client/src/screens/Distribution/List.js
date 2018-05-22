import React, { Component } from 'react'
import * as UI from 'semantic-ui-react'

import request from 'request'

const Distribution = ({distribution}) => (
  <div>
    {distribution.suite}
  </div>
)

class List extends Component {
  state = {
    distributions: []
  }

  componentDidMount() {
    this.getDistributions()
  }

  getDistributions() {
    let host = process.env['REACT_APP_SERVER_HOST']

    request(`http://${host}/repository`, (error, response, body) => {
      let responseData = JSON.parse(body)

      let distributions = responseData.distributions

      this.setDistributions({ distributions })
    })
  }

  setDistributions(distributions) {
    this.setState(distributions)
  }

  render() {
    const distributions = this.state.distributions

    return (
      <div>
        <UI.Header as="h1">
          Distributions
        </UI.Header>

        {distributions.map((distribution) => (
          <Distribution key={distribution.suite} distribution={distribution} />
        ))}
      </div>
    )
  }
}

export default List
