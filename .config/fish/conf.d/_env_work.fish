set -gx EA_ADMINISTRATION_PORT 5001
set -gx PDF_CONVERTER libreoffice
set -gx PUPPETEER_EXECUTABLE_PATH /opt/homebrew/bin/chromium
set -gx PUPPETEER_SKIP_CHROMIUM_DOWNLOAD false

set -gx OTEL_EXPORTER_OTLP_ENDPOINT http://localhost:4317
set -gx OTEL_EXPORTER_OTLP_PROTOCOL grpc
set -gx OTEL_SERVICE_NAME api_next
set -gx OTEL_TRACES_EXPORTER otlp
set -gx OTEL_SDK_DISABLED true
