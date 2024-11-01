# Stage 1: Build the .NET application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /webapi

# Copy the .csproj file from the webapi directory
COPY webapi/webapi.csproj ./
RUN dotnet restore

# Copy the entire application source code
COPY webapi/. ./
RUN dotnet publish -c Release -o /webapi/out

# Stage 2: Create a lightweight runtime image for the app
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /webapi

# Copy the build output from the previous stage
COPY --from=build /webapi/out ./

# Set the entry point to run the application
ENTRYPOINT ["dotnet", "webapi.dll"]
