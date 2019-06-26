
# Create Dockerfile



```
FROM mcr.microsoft.com/dotnet/core/aspnet:2.2 AS base

ENV CORECLR_ENABLE_PROFILING=1 \
CORECLR_PROFILER={36032161-FFC0-4B61-B559-F6C5D41BAE5A} \
CORECLR_NEWRELIC_HOME=/usr/local/newrelic-netcore20-agent \
CORECLR_PROFILER_PATH=/usr/local/newrelic-netcore20-agent/libNewRelicProfiler.so
ARG agent_version="8.15.455.0"

RUN curl https://download.newrelic.com/dot_net_agent/latest_release/newrelic-netcore20-agent_${agent_version}_amd64.deb -o newrelic-netcore20-agent_${agent_version}_amd64.deb \
    && dpkg -i newrelic-netcore20-agent_${agent_version}_amd64.deb \
    && rm newrelic-netcore20-agent_${agent_version}_amd64.deb
    
COPY MagicOnion.Instrumentation.xml /usr/local/newrelic-netcore20-agent/extensions/
COPY newrelic.config /usr/local/newrelic-netcore20-agent/

WORKDIR /app
EXPOSE 12345

FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS publish
WORKDIR /src
COPY . .
RUN dotnet publish MagicOnion.Server/MagicOnion.Server.csproj -c Release -o /app

FROM base As final
WORKDIR /app
COPY --from=publish /app /app
ENTRYPOINT [ "dotnet", "MagicOnion.Server.dll" ]
```

