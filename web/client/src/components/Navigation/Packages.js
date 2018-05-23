import React from 'react'
import { NavLink } from 'react-router-dom'
import { Menu } from 'semantic-ui-react'

const Navigation = ({ packages }) => (
  <Menu inverted vertical>
    {packages.map((packageName, index) => (
      <Menu.Item key={index} as={NavLink} to={`/packages/${packageName}`}>
        {packageName}
      </Menu.Item>
    ))}
  </Menu>
)

export default Navigation
