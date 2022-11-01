#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["JenkinsAssignment/JenkinsAssignment.csproj", "JenkinsAssignment/"]
RUN dotnet restore "JenkinsAssignment/JenkinsAssignment.csproj"
COPY . .
WORKDIR "/src/JenkinsAssignment"
RUN dotnet build "JenkinsAssignment.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "JenkinsAssignment.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "JenkinsAssignment.dll"]