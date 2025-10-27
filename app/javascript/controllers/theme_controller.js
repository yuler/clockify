import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="theme"
export default class extends Controller {
  static targets = ["icon", "label"]

  connect() {
    // Load theme preference from localStorage or default to system
    this.themePreference = localStorage.getItem("themePreference") || "system"
    this.applyTheme()
    
    // Listen for system theme changes
    this.mediaQuery = window.matchMedia('(prefers-color-scheme: dark)')
    this.mediaQuery.addEventListener('change', () => {
      if (this.themePreference === "system") {
        this.applyTheme()
      }
    })
  }

  disconnect() {
    if (this.mediaQuery) {
      this.mediaQuery.removeEventListener('change', this.applyTheme)
    }
  }

  setTheme(event) {
    this.themePreference = event.params.theme
    localStorage.setItem("themePreference", this.themePreference)
    this.applyTheme()
  }

  applyTheme() {
    let actualTheme
    
    if (this.themePreference === "system") {
      // Detect system theme
      actualTheme = this.mediaQuery?.matches ? "dark" : "light"
    } else {
      actualTheme = this.themePreference
    }
    
    document.documentElement.setAttribute("data-theme", actualTheme)
    this.updateIcon(actualTheme)
    this.updateLabel()
  }

  updateIcon(actualTheme) {
    if (!this.hasIconTarget) return
    
    const icons = {
      light: '<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z"></path></svg>',
      dark: '<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z"></path></svg>',
      system: '<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.75 17L9 20l-1 1h8l-1-1-.75-3M3 13h18M5 17h14a2 2 0 002-2V5a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"></path></svg>'
    }
    
    this.iconTarget.innerHTML = icons[this.themePreference] || icons.system
  }

  updateLabel() {
    if (!this.hasLabelTarget) return
    
    // This will be updated by the data-theme-target="label" in the HTML
    const labels = {
      light: this.labelTarget.dataset.lightLabel,
      dark: this.labelTarget.dataset.darkLabel,
      system: this.labelTarget.dataset.systemLabel
    }
    
    this.labelTarget.textContent = labels[this.themePreference] || labels.system
  }
}

