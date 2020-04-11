#!/bin/bash

ctags -R src env tests --languages=python,c++,c,javascript --exclude=env/lib/site-packages/werkzeug/debug 1> tags.out 2> tags.err &

