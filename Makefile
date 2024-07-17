.PHONY: start-omc start-car-imitator start-backends stop-backends

start-omc:
	@echo "Starting OMC (observable-motor-command) Backend..."
	cd Backends/observable-motor-command && npm install && npm run start &

start-car-imitator:
	@echo "Starting car-imitator Backend..."
	cd Backends/car-imitator && npm install && npm run start &

start-backends: start-omc start-car-imitator
	@echo "Both backend apps are started."

stop-backends:
	@echo "Stopping both backends..."
	Scripts/stop-node-servers.sh

update-otel-faro-config:
	@echo "Updating iOS OpenTelemetry configuration..."
	Scripts/update-ios-otel-config.sh
	Scripts/update-flutter-faro-config.sh