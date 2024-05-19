# Monitor your mobile apps using Grafana

This is a demo project showing how you can monitor your mobile apps using Grafana.

This is still a work in progress. This is the first very early version.
Currently only iOS is supported. Soon Flutter will come.

The project also contains a simple backend which the mobile apps can communicate with.

## Setup

### 0. Prerequisites

To run the iOS app you need to have Xcode installed.  
This project was built and tested using Xcode 15.3

You also need node and npm for the simple backends.

### 1. Create a .env file

Make a copy of the [.env-example](.env-example) file and name the new file `.env` and place it at the root of this project.  
NOTE: Do not commit this new file. Since it will contain your private otel config data.

### 2. Setup Grafana Cloud

Go to [Grafana.com](https://grafana.com) and set up a new account.
Then go to your account overview and tap the `Configure` button on the OpenTelemetry-tile.

<div align="center">
  <img src="https://github.com/robert-northmind/mobile-o11y-demo/blob/main/Docs/Resources/otel-config-entry-1.png?raw=true" width="500">
</div>

There you need to find the section called `Environment Variables`.
From there you need to copy the configuration and past it into the `.env` file.

If you don't have a token yet, then you first need to tap the `Generate now` button in the token section.

### 3. Start the fake backends

You can run them locally. Start them by running this command from the project root:

```sh
make start-backends
```

By default they will run at `http://localhost:3000` and `http://localhost:3001`.  
If you change this, then you will need to update all your mobile apps to call the new url.

### 4. Start up the iOS app

Now you can build and run the iOS app. It is probably easiest to run it on the iOS Simulator (if you want to run it on a real device, then you will need to set up provisioning and signing. This is outside the scope of this example).
