import React from 'react'
import { NavLink } from 'react-router-dom'
import { Menu } from 'semantic-ui-react'

const Navigation = () => (
  <Menu inverted vertical>
    <Menu.Item as={NavLink} to="/distributions/some-distribution">
      Some Distribution
    </Menu.Item>
    <Menu.Item as={NavLink} to="/distributions/other-distribution">
      Other Distribution
    </Menu.Item>
  </Menu>
)

export default Navigation
