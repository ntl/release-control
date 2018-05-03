import React from 'react'
import { NavLink } from 'react-router-dom'
import { Menu } from 'semantic-ui-react'

const Navigation = () => (
  <Menu inverted vertical>
    <Menu.Item as={NavLink} to="/distributions/pre-release">
      Pre-Release
    </Menu.Item>
    <Menu.Item as={NavLink} to="/distributions/release">
      Release
    </Menu.Item>
  </Menu>
)

export default Navigation
