import React from 'react'
import { NavLink } from 'react-router-dom'
import { Menu } from 'semantic-ui-react'

const Navigation = ({ distributions }) => (
  <Menu inverted vertical>
    {distributions.map((distribution, index) => (
      <Menu.Item as={NavLink} to={`/distributions/${distribution}`}>
        {distribution}
      </Menu.Item>
    ))}
  </Menu>
)

export default Navigation
