{
  title: 'OPA Healthcheck',
  secure_tunnel: true,

  connection: {
    fields: [{ name: 'profile', hint: 'OPA Healthcheck Profile' }],
    authorization: { type: 'none'}
  },

  test: lambda do |connection|
    get("http://localhost/ext/#{connection['profile']}/ping").headers('X-Workato-Connector': 'enforce')
  end,

  actions: {

    ping: {
      title: 'Ping OPA Server',
      description: 'Ping the OPA Server to confirm its running',
      output_fields:lambda do |object_definitions|
        object_definitions['ping']
      end,

      execute: lambda do |connection|
        get("http://localhost/ext/#{connection['profile']}/ping").headers('X-Workato-Connector': 'enforce')
      end
    },

    
    getMemory: {
      title: 'Get OPA JVM Memory Info',
      description: 'Get the JVM memory usage (in mb) where OPA is running',
      output_fields:lambda do |object_definitions|
        object_definitions['memoryInfo']
      end,

      execute: lambda do |connection|
        get("http://localhost/ext/#{connection['profile']}/memory").headers('X-Workato-Connector': 'enforce')
      end
    },
    
    getCPUs: {
      title: 'Get OPA server\'s CPU Info',
      description: 'Get the CPU details where OPA is running. Note: For the JVM and System CPU load, a value of 0 means that all CPUs were idle during the recent period of time observed',
      output_fields:lambda do |object_definitions|
        object_definitions['cpus']
      end,

      execute: lambda do |connection|
        get("http://localhost/ext/#{connection['profile']}/cpus").headers('X-Workato-Connector': 'enforce')
      end
    },
    
    getThreads: {

      title: 'Get OPA JVM Threads Info',
      description: 'Get the JVM threads details where OPA is running',
      output_fields: lambda do |object_definitions|
        object_definitions['threadInfoList']
      end,

      execute: lambda do |connection|
        get("http://localhost/ext/#{connection['profile']}/threads").headers('X-Workato-Connector': 'enforce')
      end
    }
    
  },
  
  object_definitions:{

    ping:{
      fields: lambda do
        [
          {
            "control_type": "text",
            "label": "Message",
            "type": "string",
            "name": "message"
          },
          {
            "control_type": "text",
            "label": "Current time",
            "render_input": "date_time_conversion",
            "parse_output": "date_time_conversion",
            "type": "date_time",
            "name": "currentTime"
          }
        ]
      end,
    },
    
    cpus:{
      fields: lambda do
        [
          {
            "control_type": "number",
            "label": "CPUs",
            "parse_output": "integer_conversion",
            "type": "number",
            "name": "cpus"
          },
          {
            "control_type": "number",
            "label": "JVM CPU Load",
            "parse_output": "float_conversion",
            "type": "number",
            "name": "jvmCPULoad"
          },
          {
            "control_type": "number",
            "label": "System CPU Load",
            "parse_output": "float_conversion",
            "type": "number",
            "name": "systemCPULoad"
          }
        ]
      end,
    },
    
    
    memoryInfo:{
      fields: lambda do
        [
          {
            "control_type": "number",
            "label": "Used memory",
            "parse_output": "integer_conversion",
            "type": "number",
            "name": "usedMemory"
          },
          {
            "control_type": "number",
            "label": "Total memory",
            "parse_output": "integer_conversion",
            "type": "number",
            "name": "totalMemory"
          },
          {
            "control_type": "number",
            "label": "Free memory",
            "parse_output": "integer_conversion",
            "type": "number",
            "name": "freeMemory"
          },
          {
            "control_type": "number",
            "label": "Max memory",
            "parse_output": "integer_conversion",
            "type": "number",
            "name": "maxMemory"
          }
        ]
      end,
    },
    
    threadInfoList: {
      fields: lambda do
        [
            {
            "name": "threadInfoList",
            "type": "array",
            "of": "object",
            "label": "Thread info list",
            "properties": [
                {
                "control_type": "number",
                "label": "Thread ID",
                "parse_output": "float_conversion",
                "type": "number",
                "name": "threadID"
                },
                {
                "control_type": "number",
                "label": "Cpu time",
                "parse_output": "float_conversion",
                "type": "number",
                "name": "cpuTime"
                },
                {
                "control_type": "text",
                "label": "Thread state",
                "type": "string",
                "name": "threadState"
                },
                {
                "control_type": "text",
                "label": "Thread name",
                "type": "string",
                "name": "threadName"
                }
            ]
            }
        ]
      end
    }
  }
}