#!/bin/bash

rake db:setup
rackup -o 0.0.0.0  -p $PORT
