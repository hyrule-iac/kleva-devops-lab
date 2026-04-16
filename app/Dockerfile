# Multi-stage Dockerfile for building and running a .NET application
	# This Dockerfile uses two stages: the first stage builds the application using the .NET SDK image, 
	# The second stage runs the application using the ASP.NET Core runtime image. 
	# This approach helps to keep the final image smaller by only including the necessary runtime components.

#Stage1
# Use the .NET SDK image to build the application
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src
COPY . .
RUN dotnet publish -c Release -o /app/publish

#Stage2
# Use the ASP.NET Core runtime image to run the application
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS runtime
WORKDIR /app
# Copy the published application from the build stage to the runtime image
COPY --from=build /app/publish .
ENV ASPNETCORE_URLS=http://+:80
EXPOSE 80
ENTRYPOINT ["dotnet", "kleva-app.dll"]