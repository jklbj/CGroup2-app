# CGroup2 App

Web application for CGroup2 system that allows groups following things:

* match their google calendars to find the overlapped free time quickly
* Join the groups what you want to do

Please also note the Web API that it uses: https://github.com/jklbj/CGroup2-api

## Install

Install this application by cloning the *relevant branch* and use bundler to install specified gems from `Gemfile.lock`:

```shell
bundle install
```

## Test

This web app does not contain any tests yet :(

## Execute

Launch the application using:

```shell
rake run:dev
```

The application expects the API application to also be running (see `config/app.yml` for specifying its URL)
