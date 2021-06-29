FROM mcr.microsoft.com/dotnet/aspnet:5.0

COPY bin/Release/net5.0/publish/ App/

WORKDIR /App

#ENV ASPNETCORE_URLS="https://+:5001;http://+:5000"
ENV ASPNETCORE_URLS="http://+:5000"

# https://devblogs.microsoft.com/aspnet/forwarded-headers-middleware-updates-in-net-core-3-0-preview-6/
ENV ASPNETCORE_FORWARDEDHEADERS_ENABLED=true

ENTRYPOINT ["dotnet", "WebApp-OpenIDConnect-DotNet.dll"]

