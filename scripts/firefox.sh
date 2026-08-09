#!/usr/bin/env bash
set -Eeuo pipefail
trap 'rc=$?; echo "ERROR: \"$BASH_COMMAND\" falló en la línea $LINENO (código de salida: $rc)" >&2; exit "$rc"' ERR

# Instalación de Firefox ESR en español (es-ES)

# Desinstalar
sudo apt purge firefox* -y
sudo apt autoremove -y
sudo rm --force --recursive /usr/lib/firefox-esr
sudo rm --force --recursive /usr/share/firefox-esr
rm --force --recursive ~/.mozilla/firefox
rm --force --recursive ~/.cache/mozilla/firefox

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
defaultPref("app.shield.optoutstudies.enabled", false);
defaultPref("app.normandy.enabled", false);
defaultPref("app.normandy.first_run", false);
defaultPref("app.normandy.last_seen_buildid", 0);
defaultPref("browser.aboutwelcome.enabled", false);
defaultPref("browser.newtabpage.activity-stream.feeds.discoverystreamfeed", false);
defaultPref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
defaultPref("browser.newtabpage.activity-stream.feeds.snippets", false);
defaultPref("browser.newtabpage.activity-stream.feeds.topsites", false);
defaultPref("browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.searchEngines", "DuckDuckGo");
defaultPref("browser.newtabpage.activity-stream.showSearch", true);
defaultPref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
defaultPref("browser.newtabpage.activity-stream.showWeather", false);
defaultPref("browser.ml.chat.enabled", false);
defaultPref("browser.ml.chat.enabledByDefault", false);
defaultPref("browser.ml.chatprovider.enabled", false);
defaultPref("browser.ml.enabled", false);
defaultPref("browser.ml.suggestions.enabled", false);
defaultPref("browser.ml.featureGate", false);
defaultPref("browser.pocket.enabled", false);
defaultPref("browser.rights.3.shown", true);
defaultPref("browser.search.defaultenginename", "DuckDuckGo");
defaultPref("browser.search.selectedEngine", "DuckDuckGo");
defaultPref("browser.tabs.crashReporting.sendReport", false);
defaultPref("browser.translations.neverTranslateLanguages", "en,en-US,en-GB");
defaultPref("layers.acceleration.force-enabled", true);
defaultPref("signon.rememberSignons", false);
defaultPref("toolkit.telemetry.enabled", false);
defaultPref("toolkit.telemetry.unified", false);
defaultPref("datareporting.healthreport.uploadEnabled", false);
defaultPref("datareporting.healthreport.service.enabled", false);
defaultPref("datareporting.policy.dataSubmissionEnabled", false);
EOF
sudo mkdir -p /usr/lib/firefox-esr/distribution
sudo tee "/usr/lib/firefox-esr/distribution/policies.json" > /dev/null << 'JSON'
{
  "policies": {
    "DisableTelemetry": true,
    "DisableAppUpdate": true,    
    "DisableFirefoxStudies": true,
    "OverrideFirstRunPage": "",
    "SearchEngines": {
      "Default": "DuckDuckGo"
    },
    "AppNormandy": {  "Enabled": false },
    "ExtensionSettings": {
      "uBlock0@raymondhill.net": {
        "installation_mode": "force_installed",
        "install_url": "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi"
      }
    },
    "SecurityDevices": { "System CA Trust": "/usr/lib/x86_64-linux-gnu/pkcs11/p11-kit-trust.so" },
    "AIControls": {
      "Default": { "Value": "blocked", "Locked": true },
      "Translations": { "Value": "blocked", "Locked": true },
      "PDFAltText": { "Value": "blocked", "Locked": true },
      "SmartTabGroups": { "Value": "blocked", "Locked": true },
      "LinkPreviewKeyPoints": { "Value": "blocked", "Locked": true },
      "SidebarChatbot": { "Value": "blocked", "Locked": true },
      "Chatbot": { "Value": "blocked", "Locked": true },
      "Summarization": { "Value": "blocked", "Locked": true },
      "WritingSuggestions": { "Value": "blocked", "Locked": true },
      "AutofillSuggestions": { "Value": "blocked", "Locked": true }      
    }
  }
}
JSON
