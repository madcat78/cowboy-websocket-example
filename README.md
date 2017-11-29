# Cowboy Websocket Example

An Erlang OTP application as a websocket example using Cowboy

This application just shows some memory usage stats sending messages via websocket

(Example idea taken from https://github.com/websockets/ws/tree/master/examples/serverstats)

It uses Cowboy version 2 so Erlang OTP 19 or greater is required

## Build and run on Heroku

    $ heroku create APP_NAME
    $ heroku config:add BUILDPACK_URL="https://github.com/madcat78/heroku-buildpack-erlang.git" -a APP_NAME

Make a small change and commit

    $ echo OTP-20.1 > .preferred_otp_version
    $ git commit -m "Select 20.1 as preferred OTP version" -a
    $ git push heroku master

Open a browser tab to `https://APP_NAME.herokuapp.com` and review the log stream

    $ heroku logs --tail

Close your browser tab when you're done to stop your Heroku dyno from running forever

## Build and run on your machine

Edit the `apps/ws/priv/index.html` file commenting the Heroku config line and commenting out the standalone one

    var ws = new WebSocket('ws://' + host + ':8081/websocket');  // standalone config
    //var ws = new WebSocket('wss://' + host + '/websocket');  // heroku config

Then build and run

    $ rebar3 compile
    $ rebar3 shell

Open a browser tab to `http://localhost:8081`

If you want to change the listening port edit the `config/sys.config` and the `apps/ws/priv/index.html` files

By editing the `config/sys.config` file you can also change the interval of the messages that are sent via websocket (default is 50 milliseconds)
