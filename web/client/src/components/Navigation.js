import React from 'react'
import { NavLink } from 'react-router-dom'
import { Menu } from 'semantic-ui-react'
import Refresh from './Refresh'
import Distributions from './Navigation/Distributions'
import Packages from './Navigation/Packages'

const Navigation = ({ distributions, packages, setRepository }) => (
  <Menu inverted vertical className="left fixed">
    <Menu.Item header as="h3">
      Release Control
    </Menu.Item>

    <Menu.Item>
      Distributions
    </Menu.Item>

    <Distributions distributions={distributions} />

    <Menu.Item exact as={NavLink} to="/packages">
      Packages
    </Menu.Item>

    <Packages packages={packages} />

    <Refresh lastSyncTime='2000-01-01T00:00:00.000Z' setRepository={setRepository} />
  </Menu>
)

export default Navigation
