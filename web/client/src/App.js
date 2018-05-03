import React, { Component } from 'react'
import './App.css'

import { BrowserRouter as Router, Route } from 'react-router-dom'

import Navigation from './components/Navigation'

import * as Screens from './screens'

class App extends Component {
  render() {
    return (
      <Router>
        <div>
          <Navigation />

          <div style={{ marginLeft: "250px", minWidth: "550px", maxWidth: "1150px" }}>
            <Route exact path="/" component={Screens.Packages}>
              {/*
              <Route path="/packages/:package" component={Package} />
              */}
            </Route>
            <Route path="/distributions" component={Screens.Distributions} />
          </div>
        </div>
      </Router>
    )
  }
}

export default App
