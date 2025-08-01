import { Application } from "@hotwired/stimulus"
import '../packs/filter_slider'

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
