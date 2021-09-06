Workato OPA Health Check Extension.

## Building extension

Steps to build an extension:

1. Install the latest Java 8 SDK
2. Use `./gradlew jar` command to bootstrap Gradle and build the project.
3. The output is in `build/libs`.

## Installing the extension to OPA

1. Add a new directory called `ext` under Workato agent install directory.
2. Copy the extension JAR file to `ext` directory. Pre-build jar: [workato-opa-healthcheck-connector-0.1.jar](build/libs/workato-opa-healthcheck-connector-0.1.jar)
3. Update the `config/config.yml` to add the `ext` file to class path.

```yml
server:
   classpath: /opt/opa/workato-agent/ext
```

4. Update the `conf/config.yml` to configure the new extension.

```yml
extensions:
   healthcheck:
      controllerClass: com.knyc.opa.HealthcheckExtension
```

## Custom SDK for the extension

The corresponding custom SDK can be found here in this repo as well.

Link: [opa-healthcheck-connector.rb](custom-sdk/opa-healthcheck-connector.rb)

Create a new Custom SDK in your Workato workspace and use it with the OPA extension.