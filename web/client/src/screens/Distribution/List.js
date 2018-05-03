import React, { Component } from 'react'

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
    request('http://127.0.0.1:9393/distributions', (error, response, body) => {
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
        <h1>Distributions</h1>

        {distributions.map((distribution) => (
          <Distribution key={distribution.suite} distribution={distribution} />
        ))}
      </div>
    )
  }
}

export default List
