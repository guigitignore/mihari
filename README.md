# mihari

[![Gem Version](https://badge.fury.io/rb/mihari.svg)](https://badge.fury.io/rb/mihari)
[![Ruby CI](https://github.com/ninoseki/mihari/actions/workflows/test.yml/badge.svg)](https://github.com/ninoseki/mihari/actions/workflows/test.yml)
[![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/ninoseki/mihari)](https://hub.docker.com/r/ninoseki/mihari)
[![Coverage Status](https://coveralls.io/repos/github/ninoseki/mihari/badge.svg?branch=master)](https://coveralls.io/github/ninoseki/mihari?branch=master)
[![CodeFactor](https://www.codefactor.io/repository/github/ninoseki/mihari/badge)](https://www.codefactor.io/repository/github/ninoseki/mihari)

![img](https://github.com/ninoseki/mihari/raw/master/images/logo.png)

Mihari is a framework for continuous OSINT based threat hunting.

## How it works

- Mihari makes a query against Shodan, Censys, VirusTotal, SecurityTrails, etc. and extracts artifacts (IP addresses, domains, URLs or hashes).
- Mihari checks whether a DB (SQLite3, PostgreSQL or MySQL) contains the artifacts or not.
  - If it doesn't contain the artifacts:
    - Mihari creates an alert on TheHive.
    - Mihari sends a notification to Slack.
    - Mihari creates an event on MISP.

Also, you can check the alerts on a built-in web app.

![img](https://github.com/ninoseki/mihari/raw/master/images/web_alerts.png)

## Supported services

Mihari supports the following services by default.

- [BinaryEdge](https://www.binaryedge.io/)
- [Censys](http://censys.io)
- [CIRCL passive DNS](https://www.circl.lu/services/passive-dns/) / [passive SSL](https://www.circl.lu/services/passive-ssl/)
- [crt.sh](https://crt.sh/)
- [DN Pedia](https://dnpedia.com/)
- [dnstwister](https://dnstwister.report/)
- [Onyphe](https://onyphe.io)
- [OTX](https://otx.alienvault.com/)
- [PassiveTotal](https://community.riskiq.com/)
- [Pulsedive](https://pulsedive.com/)
- [SecurityTrails](https://securitytrails.com/)
- [Shodan](https://shodan.io)
- [Spyse](https://spyse.com)
- [urlscan.io](https://urlscan.io)
- [VirusTotal](http://virustotal.com)
- [ZoomEye](https://zoomeye.org)

See [Usage](https://github.com/ninoseki/mihari/wiki/Usage) for more information.

## Docs

- [Requirements & Installation](https://github.com/ninoseki/mihari/wiki/Requirements-&-Installation)
- [Usage](https://github.com/ninoseki/mihari/wiki/Usage)
- [Configuration](https://github.com/ninoseki/mihari/wiki/Configuration)
- [Custom script](https://github.com/ninoseki/mihari/wiki/Custom-script)
- [Docker](https://github.com/ninoseki/mihari/wiki/Docker)

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
