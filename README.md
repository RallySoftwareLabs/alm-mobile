# Getting Started

Clone the repo:

        git clone ssh://git/export/git/alm-mobile.git

To install required node modules, run:

        npm install

If you need to add the npm bin directory to your PATH for cake and brunch, run:

        export PATH=$PATH:`npm bin`

To compile CoffeeScript, build and run the application, run:

        cake build && brunch build && brunch watch

## Setting up Apache virtual hosts

Edit /etc/apache2/httpd.conf to enable the virtual hosts file. Uncomment out the second line:

        # Virtual hosts
        Include /private/etc/apache2/extra/httpd-vhosts.conf

Edit /etc/apache2/extra/httpd-vhosts.conf with the following, swapping out _[hostname]_ for your machine's actual hostname:

        <VirtualHost *:80>
            ServerAdmin mparrish@rallydev.com
            ServerName [hostname]
            ServerAlias [hostname]
            ProxyPass / http://localhost:3000/
            ProxyPassReverse / http://localhost:3000/
            ErrorLog "/private/var/log/apache2/[hostname]-error_log"
            CustomLog "/private/var/log/apache2/[hostname]-access_log" common
        </VirtualHost>

## Server ENV Variables

You will need to set the following environment variables where you run the server

* `ALM_MOBILE_ALM_WS_BASE_URL`=http://[hostname].f4tech.com:7001/slm
* `ALM_MOBILE_ZUUL_BASE_URL`=http://[dbname from ~/.m2/settings.xml].zuul1.f4tech.com:3000

## Rally ALM Feature Toggles

Rally ALM will need the following features toggled on:

* Enable WSAPI 2.0 - DO NOT toggle on globally - remove toggle instead

## Run the server

        brunch w

# Brunch with Eggs and Bacon

![](https://a248.e.akamai.net/camo.github.com/1c7212d12d1b170a4247587d46fa1c8a234538d0/687474703a2f2f662e636c2e6c792f6974656d732f3150343031313356326a336830563375305433532f363837343734373033613266326636643635366336353739363136633265363636633738363432653639373432663638376136363633356633353331333232653661373036372e6a706567)

My favorite brunch, fat and tasty!

[Twitter Bootstrap](http://twitter.github.com/bootstrap/) Javascript skeleton for [Brunch.io](http://brunch.io) with support for [SASS](http://sass-lang.com/), [LESS](http://lesscss.org/) and [Handlebars](http://handlebarsjs.com/). Also includes [Backbone.Mediator](https://github.com/chalbert/Backbone-Mediator) for Pub/Sub patterns.

## Getting started

Make sure to have [Brunch.io](http://brunch.io) installed.

Create your project using Eggs and Bacon with:

    brunch new <your-project-name> -s github://nezoomie/brunch-eggs-and-bacon

Or simply copy the repository on your hard drive and rename it.

## Customize Bootstrap Stylesheets

All Bootstrap stylesheet files can be found separated into:

    vendor/styles/bootstrap

They're in original [LESS](http://lesscss.org/) format in order to be easily customized, and compiled together with the app build.

## Exclude Bootstrap jQuery plugins

jQuery plugins used by Bootstrap are all listed (in the right order) inside the config.coffee file. Comment the ones you want to exclude from the build with a #. (Pay attention to dependencies!)

# Testing

## Android Emulator

Full documentation can be found at the [Android Developer](http://developer.android.com/index.html) site.

Download and unzip the [Android SDK](http://developer.android.com/sdk/index.html) in order to set up your Android Virtual Device (AVD)

From the unzipped SDK directory get the config ID

    sdk/tools/android list target

Create an AVD with the target id from an image

    android create avd -n <avd_name> -t <config id>

Run the AVD with the emulator tool with graphics acceleration for increased responsiveness

    emulator -avd my_avd -gpu on

Download the [WebDriver for Android](http://code.google.com/p/selenium/downloads/list)

Get the serial ID for your emulator

    platform-tools/adb devices

Install the Android WebDriver to your emulator

    platform-tools/adb -s <serialId> -e install -r android-server.apk

Start the Android WebDriver on your emulator

    platform-tools/adb -s <serialId> shell am start -a android.intent.action.MAIN -n org.openqa.selenium.android.app/.MainActivity

Set up port forwarding for TCP connections from your hostmachine to your emulator

    platform-tools/adb -s <serialId> forward tcp:8080 tcp:8080

## Conventions

All CoffeeScript should be indented with 2 spaces (soft tabs)