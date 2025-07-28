// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap"

// Import FontAwesome core
import { library, dom } from '@fortawesome/fontawesome-svg-core'

// Import all solid icons
import * as solidIcons from '@fortawesome/free-solid-svg-icons'
// Import all regular icons
import * as regularIcons from '@fortawesome/free-regular-svg-icons'

// Add all solid icons to the library
const solidIconList = Object.keys(solidIcons)
  .filter(key => key.startsWith('fa'))
  .map(key => solidIcons[key])

// Add all regular icons to the library
const regularIconList = Object.keys(regularIcons)
  .filter(key => key.startsWith('fa'))
  .map(key => regularIcons[key])

library.add(...solidIconList, ...regularIconList)

// Tell FontAwesome to watch the DOM and add the SVGs when it detects icon markup
dom.watch()
