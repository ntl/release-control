import React, { Component } from 'react'
import './App.css'

import { BrowserRouter as Router, Route } from 'react-router-dom'

import * as UI from 'semantic-ui-react'
import request from 'request'

import Navigation from './components/Navigation'
import * as Screens from './screens'

import URI from './Server/URI'

class App extends Component {
  state = {
    repository: {
      distributions: [],
      packages: []
    }
  }

  componentDidMount() {
    this.refreshRepository()
  }

  refreshRepository = () => {
    const uri = URI('/repository')

    request(uri, (error, response, body) => {
      const repository = JSON.parse(body)

      const lastRefreshTimeRaw = new Date()

      const lastRefreshTime = lastRefreshTimeRaw.toLocaleString()

      this.setRepository(repository, lastRefreshTime)
    })
  }

  setRepository = (repository, lastRefreshTime) => {
    this.setState({ repository, lastRefreshTime })
  }

  renderScreen = (componentName, refreshRepository) => {
    let repository = this.state.repository

    return (props) => {
      return React.createElement(
        componentName,
        {
          repository: repository,
          refreshRepository: refreshRepository,
          ...props
        }
      )
    }
  }

  render() {
    const repository = this.state.repository

    const distributionNames = repository.distributions.map((distribution) => {
      return distribution.name
    })

    const packageNames = repository.packages.map((pkg) => {
      return pkg.name
    })

    const refreshRepository = this.refreshRepository

    const lastRefreshTime = this.state.lastRefreshTime

    return (
      <Router>
        <div>
          <Navigation
           distributions={distributionNames}
           packages={packageNames}
           refreshRepository={refreshRepository}
           lastRefreshTime={lastRefreshTime}
          />

          <UI.Container fluid id="screen">
            <Route exact path="/packages" component={this.renderScreen(Screens.Package.List, refreshRepository)} />
            <Route exact path="/packages/:packageName" component={this.renderScreen(Screens.Package.Show, refreshRepository)} />
            <Route exact path="/packages/:packageName/:version" component={this.renderScreen(Screens.Package.ShowVersion)} />

            <Route path="/distributions/:distribution" component={this.renderScreen(Screens.Distribution.Show)} />
          </UI.Container>
        </div>
      </Router>
    )
  }
}

export default App
