// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap"

import "./chart/finance_chart"

import { library, dom } from '@fortawesome/fontawesome-svg-core'
import * as solidIcons from '@fortawesome/free-solid-svg-icons'
import * as regularIcons from '@fortawesome/free-regular-svg-icons'

// Add all icons to the library
const solidIconList = Object.keys(solidIcons)
  .filter(key => key.startsWith('fa'))
  .map(key => solidIcons[key])
const regularIconList = Object.keys(regularIcons)
  .filter(key => key.startsWith('fa'))
  .map(key => regularIcons[key])
library.add(...solidIconList, ...regularIconList)
// Tell FontAwesome to watch the DOM and add the SVGs when it detects icon markup
dom.watch()
