#!/bin/bash

rm gc*.love
zip gc.zip * -r -x *.love *.zip
mv gc.zip "gc-$(date).love"
