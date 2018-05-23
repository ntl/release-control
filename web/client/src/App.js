import React, { Component } from 'react'
import './App.css'

import { BrowserRouter as Router, Route } from 'react-router-dom'

import * as UI from 'semantic-ui-react'
import request from 'request'

import Navigation from './components/Navigation'
import * as Screens from './screens'

class App extends Component {
  state = {
    repository: {
      distributions: [],
      packages: []
    }
  }

  getRepository() {
    let host = process.env['REACT_APP_SERVER_HOST']

    request(`http://${host}/repository`, (error, response, body) => {
      let repository = JSON.parse(body)

      this.setRepository(repository)
    })
  }

  setRepository(repository) {
    this.setState({ repository })
  }

  render() {
    const repository = this.state.repository

    return (
      <Router>
        <div>
          <Navigation />

          <UI.Container fluid style={{ padding: '30px 30px 30px 250px' }}>
            <Route exact path="/packages" component={Screens.Package.List} repository={repository} />
            <Route path="/packages/:package" component={Screens.Package.Show} repository={repository} />

            <Route exact path="/distributions" component={Screens.Distribution.List} repository={repository} />
            <Route path="/distributions/:distribution" component={Screens.Distribution.Show} repository={repository} />
          </UI.Container>
        </div>
      </Router>
    )
  }
}

export default App
