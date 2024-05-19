import * as logsAPI from "@opentelemetry/api-logs";
import { Resource } from "@opentelemetry/resources";
import {
  SEMRESATTRS_SERVICE_NAME,
  SEMRESATTRS_SERVICE_VERSION,
} from "@opentelemetry/semantic-conventions";
import {
  LoggerProvider,
  SimpleLogRecordProcessor,
} from "@opentelemetry/sdk-logs";
import { OTLPLogExporter } from "@opentelemetry/exporter-logs-otlp-http";
import dotenv from "dotenv";

dotenv.config();

const resourceThis = new Resource({
  [SEMRESATTRS_SERVICE_NAME]: process.env.OTEL_SERVICE_NAME,
  [SEMRESATTRS_SERVICE_VERSION]: process.env.OTEL_SERVICE_VERSION,
});
const resource = Resource.default().merge(resourceThis);

const loggerProvider = new LoggerProvider({
  resource,
});

loggerProvider.addLogRecordProcessor(
  new SimpleLogRecordProcessor(
    new OTLPLogExporter({
      keepAlive: true,
    })
  )
);

const loggerOtel = loggerProvider.getLogger("default");

function log(message, severityNumber, attributes = {}) {
  console.log(message);

  attributes["log.type"] = "LogRecord";
  attributes["deployment_environment"] = "production";
  attributes["level"] = logsAPI.SeverityNumber[severityNumber];

  loggerOtel.emit({
    severityNumber: severityNumber,
    severityText: logsAPI.SeverityNumber[severityNumber],
    body: message,
    attributes: attributes,
  });
}

export { log, logsAPI };
