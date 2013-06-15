# Getting Started

Clone the repo:

        git clone ssh://git/export/git/alm-mobile.git

If you need to install node, run:

        brew update
        brew install node

To install required node modules, run:

        npm install

Then install the Grunt Command Line and Nodemon programs:

        npm install -g grunt-cli nodemon

If you need to add the npm bin directory to your PATH for grunt, run or add this to the bottom of your ~/.zshrc file:

        export PATH=$PATH:`npm config get prefix`/bin

To compile and build the application, run:

        grunt && grunt watch

In a separate terminal window, to run the application (and reload when files are changed), run:

        npm start

## Setting up Apache virtual hosts

Edit /etc/apache2/httpd.conf to enable the virtual hosts file. Uncomment out the second line:

        # Virtual hosts
        Include /private/etc/apache2/extra/httpd-vhosts.conf

Edit /etc/apache2/extra/httpd-vhosts.conf with the following, swapping out _[hostname]_ for your machine's actual hostname.
Edit your /etc/hosts file and add alm.f4tech.com at the end of the 127.0.0.1 line:

        <VirtualHost *:80>
            ServerAdmin [email]
            ServerName [hostname]
            ServerAlias [hostname]
            ProxyPass / http://[hostname]:3000/
            ProxyPassReverse / http://[hostname]:3000/
            ErrorLog "/private/var/log/apache2/[hostname]-error_log"
            CustomLog "/private/var/log/apache2/[hostname]-access_log" common
        </VirtualHost>

        <VirtualHost *:80>
            ServerAdmin [email]
            ServerName alm.f4tech.com
            ServerAlias alm.f4tech.com
            ProxyPass / http://alm.f4tech.com:7001/
            ProxyPassReverse / http://alm.f4tech.com:7001/
            ErrorLog "/private/var/log/apache2/[alm.f4tech.com]-error_log"
            CustomLog "/private/var/log/apache2/[alm.f4tech.com]-access_log" common
        </VirtualHost>

## Server Configuration

You will need to create a config.json file to configure the ALM url. You should copy from config.json.example as a template. If you're running ALM locally, you should set its value to http://alm.f4tech.com:7001/slm

## Customize Bootstrap Stylesheets

All Bootstrap stylesheet files can be found separated into:

    vendor/styles/bootstrap

They're in original [LESS](http://lesscss.org/) format in order to be easily customized, and compiled together with the app build. The proper way to override any bootstrap styles or variables is to modify:

    client/styles/_bootstrap.less

**Do not directly modify any files in vendor/styles/bootstrap. The changes will be overwritten as we upgrade that library.**

## Exclude Bootstrap jQuery plugins

jQuery plugins used by Bootstrap are all listed (in the right order) inside the Gruntfile.coffee file. Comment the ones you want to exclude from the build with a #. (Pay attention to dependencies!)

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