import React, { Component } from 'react'
import './App.css'

import { BrowserRouter as Router, Route, Link } from 'react-router-dom'

import Root from './screens/Root'

class App extends Component {
  render() {
    return (
      <Router>
        <Route exact path="/" component={Root} />
      </Router>
    )
  }
}

export default App
