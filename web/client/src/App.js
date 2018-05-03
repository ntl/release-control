import React, { Component } from 'react'
import './App.css'

import { BrowserRouter as Router, Route } from 'react-router-dom'

import * as UI from 'semantic-ui-react'

import Navigation from './components/Navigation'

import * as Screens from './screens'

class App extends Component {
  render() {
    return (
      <Router>
        <div>
          <Navigation />

          <UI.Container fluid style={{ padding: '30px 30px 30px 250px' }}>
            <Route exact path="/packages" component={Screens.Package.Index} />
            <Route path="/packages/:package" component={Screens.Package.Show} />

            <Route exact path="/distributions" component={Screens.Distribution.Index} />
            <Route path="/distributions/:distribution" component={Screens.Distribution.Show} />
          </UI.Container>
        </div>
      </Router>
    )
  }
}

export default App
