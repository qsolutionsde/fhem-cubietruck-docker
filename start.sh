#!/bin/bash
cd /opt/fhem
perl fhem.pl fhem.cfg 2>&1 | tee log/fhem.log
