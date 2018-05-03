import React from 'react'
import { NavLink } from 'react-router-dom'
import { Menu } from 'semantic-ui-react'
import { Route } from 'react-router-dom'
import Distributions from './Navigation/Distributions'

const Navigation = () => (
  <Menu inverted vertical className="left fixed">
    <Menu.Item header as="h3">
      Release Control
    </Menu.Item>

    <Menu.Item as={NavLink} to="/distributions">
      Distributions
    </Menu.Item>

    <Route path="/distributions" component={Distributions} />

    <Menu.Item as={NavLink} to="/packages">
      Packages
    </Menu.Item>
  </Menu>
)

export default Navigation
