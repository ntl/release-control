import React, { Component } from 'react'

import request from 'request';

class Root extends Component {
  state = {
    distributions: []
  }

  componentDidMount() {
    this.getDistributions()
  }

  getDistributions() {
    request('http://192.168.1.103:9393/distributions', (error, response, body) => {
      let responseData = JSON.parse(body)

      let distributions = responseData.distributions

      this.setDistributions({ distributions })
    })
  }

  setDistributions(distributions) {
    this.setState(distributions)
  }

  render() {
    return (
      <div id="root">
        <h1>Distributions</h1>

        {this.state.distributions.map((distribution) => (
          <Distribution key={distribution.suite} distribution={distribution} />
        ))}
      </div>
    )
  }
}

const Distribution = ({distribution}) => (
  <div>
    {distribution.suite}
  </div>
)

export default Root
