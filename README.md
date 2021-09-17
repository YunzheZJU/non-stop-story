# Non-stop-story

![Test status](https://github.com/YunzheZJU/non-stop-story/workflows/Test/badge.svg)

[日本語](docs/README.ja.md) [中文](docs/README.zh_CN.md)

**v1.3 KARKINOS**

### Table of contents

1. [Introduction](#introduction)
1. [What is a 'worker'?](#what-is-a-worker)
1. [Ruby version](#ruby-version)
1. [System dependencies](#system-dependencies)
1. [Configuration](#configuration)
1. [Database initialization](#database-initialization)
1. [Test suite](#test-suite)
1. [Job queue services](#job-queue-services)
1. [Deployment instructions](#deployment-instructions)
1. [More](#more)

## <a id="introduction"></a>Introduction

Non-stop-story is a public API server project for VTuber live streams, which offers a stable and reliable data source. 

It gathers various live infos from 'worker's and manages the interaction with a persistent database for developers.

RESTful API is now available at [HOLO.DEV](https://holo.dev/):
```
/api/v1/lives/current
/api/v1/lives/scheduled
/api/v1/lives/ended
/api/v1/lives/open
/api/v1/lives/1
/api/v1/members
/api/v1/channels
/api/v1/platforms
/api/v1/rooms
/api/v1/hotnesses
```

GraphQL API is available at:
```
/graphql
```

You can also have a try the friendly GUI [here](https://holo.dev/graphql).

## What is a 'worker'?

Worker is another server which returns live infos according to the channelIDs passed through querystring.

Worker can be considered as an async and pure function.

There are various kinds of workers each of which is running for a specific platform.

There also exist workers for the same platform but are using different methods internally to fetch infos.

A Non-stop-story server/instance may combine different kinds of workers together to best fit its needs.

[Here](https://github.com/YunzheZJU/holo-schedule-workers) is a collection of sample workers.

## Ruby version

2.6.5

## System dependencies

DEVELOPMENT:
* Bundler, which allows you to execute rails commands without much efforts
* SQLite3, a lightweight database suitable for test and development

PRODUCTION
* Bundler
* MySQL/PostgreSQL, or any database that rails supports. Modify Gemfile if you are not using PostgreSQL
* Unicorn/Puma, acts as a web server
* NginX, recommended as a reverse proxy server

## Configuration

* `config/database.yml` stores database connection preferences.

* `config/worker.yml` stores the various workers' addresses you use.

* `config/email.yml` stores email configurations used in daily summary emails.

* `config/job.yml` stores the frequency of live detection.

* `config/credentials.yml.enc` stores encoded sensitive data such as admin username and password.
[Rails guides on credentials](https://guides.rubyonrails.org/security.html#custom-credentials).
**You must provide `username` and `password` under key `http_basic` before you deploy.**

## Database initialization

You can manually setup the database:

```bash
# Create database if it does not exist
bundle exec rails db:create
# Run migrations
bundle exec rails db:migrate
# Seed your database
bundle exec rails db:seed
```

or make use of `db:schema.rb`:

```bash
# This will create the database if it does not exist, load the schema, then seed it
bundle exec rails db:setup
```

## Test suite

Run 
```bash
bundle exec rails t
```

## Job queue services

No external queue tools is required.
The built-in job queue backend `Async` is enough.

## Deployment instructions

Read [this post](https://www.ralfebert.de/tutorials/rails-deployment/) for a basic understanding of how to deploy Rails.

## More

*TODO*
