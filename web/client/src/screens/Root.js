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
    request('http://localhost:9393', (error, response, body) => {
      let distributions = JSON.parse(body)

      this.setDistributions({ distributions })
    })
  }

  setDistributions(distributions) {
    this.setState(distributions)
  }

  render() {
    return (
      <div>
        <h1>Distributions</h1>

        {this.state.distributions.map((d) => (
          <Distribution distribution={d} />
        ))}
      </div>
    )
  }
}

const Distribution = ({distribution}) => (
  <div>
    {distribution.name}
  </div>
)

export default Root
