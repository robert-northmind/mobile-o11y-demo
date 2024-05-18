# Monitor your mobile apps using Grafana

This is a demo project showing how you can monitor your mobile apps using Grafana.

This is still a work in progress. This is the first very early version.
Currently only iOS is supported. Soon Flutter will come.

## Setup

### 0. Prerequisites

You need to have Xcode installed.  
This project was built and tested using Xcode 15.3

You also need node and npm for the fake backends.

### 1. Setup Grafana Cloud

Go to [Grafana.com](https://grafana.com) and set up a new account.
Then go to your account overview and tap the `Configure` button on the OpenTelemetry-tile.

<div align="center">
  <img src="https://github.com/robert-northmind/mobile-o11y-demo/blob/main/Docs/Resources/otel-config-entry-1.png?raw=true" width="500">
</div>

There you need to find these 3 things

1. Endpoint for sending OTLP signals
1. Instance ID
1. Password / API Token

If you don't have a token yet, then you first need to tap the `Generate now` button in the token section.

<div align="center">
  <img src="https://github.com/robert-northmind/mobile-o11y-demo/blob/main/Docs/Resources/otel-config-info-1.png?raw=true" width="500">
</div>

### 2. Configure OpenTelemetry in the Xcode project

Now you can open the Xcode project by opening this file: [iOS-MobileO11yDemo.xcodeproj](/iOS-MobileO11yDemo/iOS-MobileO11yDemo.xcodeproj).  
The first thing you will need to do is to enter your Grafana-Cloud-OpenTelemetry config into the [OTelConfig](/iOS-MobileO11yDemo/iOS-MobileO11yDemo/OpenTelemetry/OTelConfig.swift)

Open that file and fill in the `token`, `instanceId` and `endpointUrl`.  
Optionally you can also change the other config names in there, like the service name. But that is not needed to get this example working.

That's all you need to do.

### 3. Configure OpenTelemetry in the fake backend apps

Create a new file at the root of this project called `.ENV`. And in this file put this content:

```
OTEL_EXPORTER_OTLP_ENDPOINT="{YOUR-OTEL-ENDPOINT}"
OTEL_EXPORTER_OTLP_HEADERS="{YOUR-OTEL-HEADERS}"
```

You can find these values in the same location where you got the auth data for the iOS setup.

### 4. Start the fake backends

You can run them locally. Start them by running this from the project root:

```sh
make start-backends
```

### 5. Start up the iOS app

Now you can build and run the iOS app. It is probably easiest to run it on the iOS Simulator (if you want to run it on a real device, then you will need to set up provisioning and signing. This is outside the scope of this example).
