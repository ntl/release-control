import React from 'react'
import { NavLink } from 'react-router-dom'
import { Menu } from 'semantic-ui-react'

const Navigation = () => (
  <Menu inverted vertical>
    <Menu.Item as={NavLink} to="/packages/some-component">
      Some Component
    </Menu.Item>
    <Menu.Item as={NavLink} to="/packages/other-component">
      Other Component
    </Menu.Item>
  </Menu>
)

export default Navigation
