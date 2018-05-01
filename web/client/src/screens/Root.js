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
    request('http://localhost:9393/distributions', (error, response, body) => {
      let root = JSON.parse(body)

      let distributions = root.configure.distributions

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

        {this.state.distributions.map((d) => (
          <Distribution key={d} distribution={d} />
        ))}
      </div>
    )
  }
}

const Distribution = ({distribution}) => (
  <div>
    {distribution}
  </div>
)

export default Root
