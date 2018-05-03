import React from 'react'
import { NavLink } from 'react-router-dom'
import { Menu } from 'semantic-ui-react'

const Navigation = () => (
  <Menu inverted vertical>
    <Menu.Item as={NavLink} to="/packages/services">
      Services
    </Menu.Item>
    <Menu.Item as={NavLink} to="/packages/view-data">
      View Data
    </Menu.Item>
    <Menu.Item as={NavLink} to="/packages/frontend">
      Front-end
    </Menu.Item>
    <Menu.Item as={NavLink} to="/packages/operations">
      Operations
    </Menu.Item>
  </Menu>
)

export default Navigation
