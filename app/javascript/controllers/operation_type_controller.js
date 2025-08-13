import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["categorySelect", "typeSelect"]
  static values = { options: Object }

  connect() {
    // Snapshot all options (value -> text) from the type select
    this.allOptions = Array.from(this.typeSelectTarget.options)
      .filter(o => o.value !== "")
      .map(o => ({ value: o.value, text: o.text }))
    this.update()
  }

  update() {
  const category = this.categorySelectTarget.value
  const config = this.optionsValue || {}
  const allowed = Array.isArray(config[category]) ? config[category] : []
  const current = this.typeSelectTarget.value

    // Rebuild options: keep a blank first
    this.typeSelectTarget.innerHTML = ""
    const blank = document.createElement("option")
    blank.value = ""
    blank.text = ""
    this.typeSelectTarget.appendChild(blank)

  // If no allowed list provided, keep all options (no filtering)
  const list = allowed.length > 0 ? allowed : this.allOptions.map(o => o.value)
  const allowedOptions = this.allOptions.filter(o => list.includes(o.value))
    allowedOptions.forEach(({ value, text }) => {
      const opt = document.createElement("option")
      opt.value = value
      opt.text = text
      this.typeSelectTarget.appendChild(opt)
    })

    // Restore selection if still allowed
  if (list.includes(current)) {
      this.typeSelectTarget.value = current
    }
  }
}