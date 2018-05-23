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

  componentDidMount() {
    this.getRepository()
  }

  getRepository() {
    let host = process.env['REACT_APP_SERVER_HOST']

    request(`http://${host}/controls/repository`, (error, response, body) => {
      let repository = JSON.parse(body)

      this.setRepository(repository)
    })
  }

  setRepository(repository) {
    this.setState({ repository })
  }

  renderScreen = (componentName) => {
    let repository = this.state.repository

    return (props) => {
      return React.createElement(
        componentName,
        { repository: repository, ...props }
      )
    }
  }

  render() {
    return (
      <Router>
        <div>
          <Navigation />

          <UI.Container fluid id="screen">
            <Route exact path="/packages" component={this.renderScreen(Screens.Package.List)} />
            <Route path="/packages/:packageName" component={this.renderScreen(Screens.Package.Show)} />

            <Route exact path="/distributions" component={this.renderScreen(Screens.Distribution.List)} />
            <Route path="/distributions/:distribution" component={this.renderScreen(Screens.Distribution.Show)} />
          </UI.Container>
        </div>
      </Router>
    )
  }
}

export default App
