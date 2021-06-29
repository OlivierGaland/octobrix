FROM octoprint/octoprint:latest

ENV PIP_USER false

RUN apt-get update && apt-get install -y \
    libpq-dev

# Install plugins
RUN pip install \
    "https://github.com/kantlivelong/OctoPrint-PSUControl/archive/master.zip" \
    "https://github.com/eyal0/OctoPrint-PrintTimeGenius/archive/master.zip" \
    "https://github.com/OllisGit/OctoPrint-DisplayLayerProgress/releases/latest/download/master.zip" \
    "https://github.com/j7126/OctoPrint-Dashboard/archive/master.zip" \
    "https://github.com/OllisGit/OctoPrint-FilamentManager/archive/master.zip" \
    psycopg2

RUN pip install \
    "https://github.com/SimplyPrint/OctoPrint-Creality2xTemperatureReportingFix/archive/master.zip"
