#!/usr/bin/env bash
set -Eeuo pipefail
trap 'echo "ERROR: \"$BASH_COMMAND\" falló en la línea $LINENO"' ERR

# Instalación de Firefox ESR en español (es-ES)

# Desinstalar
sudo apt purge firefox* -y
sudo rm --recursive /usr/lib/firefox-esr
sudo rm --recursive /usr/share/firefox-esr
rm --recursive ~/.mozilla/firefox
rm --recursive ~/.cache/mozilla/firefox

# Instalar
sudo apt install firefox-esr-l10n-es-es -y

# Configurar
sudo mkdir -p /usr/lib/firefox-esr/defaults/pref
sudo tee "/usr/lib/firefox-esr/defaults/pref/local-settings.js" > /dev/null << 'EOF'
pref("general.config.filename", "firefox.cfg");
pref("general.config.obscure_value", 0);
EOF
sudo tee "/usr/lib/firefox-esr/firefox.cfg" > /dev/null << 'EOF'
// Mi configuración de Firefox
defaultPref("browser.aboutwelcome.enabled", false);
defaultPref("browser.newtabpage.activity-stream.feeds.discoverystreamfeed", false);
defaultPref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
defaultPref("browser.newtabpage.activity-stream.feeds.snippets", false);
defaultPref("browser.newtabpage.activity-stream.feeds.topsites", false);
defaultPref("browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.searchEngines", "DuckDuckGo");
defaultPref("browser.newtabpage.activity-stream.showSearch", true);
defaultPref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
defaultPref("browser.newtabpage.activity-stream.showWeather", false);
defaultPref("browser.pocket.enabled", false);
defaultPref("browser.rights.3.shown", true);
defaultPref("browser.search.defaultenginename", "DuckDuckGo");
defaultPref("browser.search.selectedEngine", "DuckDuckGo");
defaultPref("browser.tabs.crashReporting.sendReport", false);
defaultPref("browser.translations.neverTranslateLanguages", "en,en-US,en-GB");
defaultPref("datareporting.healthreport.uploadEnabled", false);
defaultPref("layers.acceleration.force-enabled", true);
defaultPref("signon.rememberSignons", false);
defaultPref("toolkit.telemetry.enabled", false);
EOF
sudo mkdir -p /usr/lib/firefox-esr/distribution
sudo tee "/usr/lib/firefox-esr/distribution/policies.json" > /dev/null << 'JSON'
{
  "policies": {
    "DisableAppUpdate": true,
    "DisableFirefoxStudies": true,
    "OverrideFirstRunPage": "",
    "SearchEngines": {
      "Default": "DuckDuckGo"
    },
    "ExtensionSettings": {
      "uBlock0@raymondhill.net": {
        "installation_mode": "force_installed",
        "install_url": "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi"
      }
    }
  }
}
JSON
