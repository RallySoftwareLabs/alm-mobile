![Rally Labs](client/assets/img/rally-labs-logo-trans.png)

Development of the mobile Rally Software ALM platform is a project of Rally Innovation Labs. For more info, visit http://labs.rallydev.com.

Use of this mobile application is on an as-is, as-available basis and it not subject to Rally’s Service Level Agreement. Support of this mobile application, evolution of this application and even ongoing existence of this Rally Labs mobile application is not guaranteed.

ALM Mobile [![Stories in Ready](https://badge.waffle.io/RallySoftwareLabs/alm-mobile.png?label=ready)](http://waffle.io/RallySoftwareLabs/alm-mobile)
=========

This site is currently running at https://m.rallydev.com.

## How can I contribute?

We welcome pull requests, so if you would like the site to behave differently or would like to see additional functionality, you can make the code change yourself and [submit a pull request](https://help.github.com/articles/creating-a-pull-request). If you'd simply like to file a defect or feature request, you can [submit a GitHub issue](https://github.com/RallySoftwareLabs/alm-mobile/issues).

## Ready to hack? Here's how.

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

## Application Configuration

You will need to create a config.json file to configure the ALM url. You should copy from config.json.example as a template.

#### Properties

- **almWebServiceBaseUrl**: You should change this value if you want to point to a different Rally ALM Server URL
- **appName**: You should change this value so that it is a unique name that represents your application and who your are.
- **mode**: Which mode do you want to run the site in? Acceptable values are "board" and "wall"

## Customizing Bootstrap Stylesheets

All Bootstrap stylesheet files can be found separated into:

    vendor/styles/bootstrap

They're in original [LESS](http://lesscss.org/) format in order to be easily customized, and compiled together with the app build. The proper way to override any bootstrap styles or variables is to modify:

    client/styles/_bootstrap.less

**Do not directly modify any files in vendor/styles/bootstrap. The changes will be overwritten as we upgrade that library.**

# Deploying to S3

The application can easily be deployed to an Amazon S3 Bucket and served up as a static website. This is accomplished via the [grunt-s3](https://github.com/pifantastic/grunt-s3) NPM module. In order to deploy the site, you need to create and configure a __grunt-aws.json__ file in the root directory of this repo. The __grunt-aws.json.example__ files is given as a skeleton to start from. All you need to do is supply your S3 Access Key Id, Secret Access Key and the name of the Bucket to deploy to. Once that is done, you can run the

        grunt

command to package up the application. To deploy it, run

        grunt s3

Your bucket should be configured for Website Hosting. Here's a link to AWS Documentation to [Configure a Bucket for Website Hosting](http://docs.aws.amazon.com/AmazonS3/latest/dev/HowDoIWebsiteConfiguration.html). You'll want to set both the Index document and Error document to be "index.html".

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

## Launching alm-mobile in the Windows Phone 8 Emulator

Start up [Visual Studio Express 2012 for Windows Phone](http://www.microsoft.com/visualstudio/eng/downloads), and create a new Visual C# Windows Phone App project. Name it anything you want and save it anywhere you want. Once the project has loaded, press F5 or the debug button to start the emulator. It will launch the skeleton app, just press the Windows button on the phone to return to the OS then launch Internet Explorer. You will need to load the site using your IP address instead of localhost, as the emulator has its own IP address.  
  
To use your computer's keyboard inside the emulator:

* **On a standard Windows keyboard:** `page up` see [this page](http://msdn.microsoft.com/en-us/library/windowsphone/develop/ff754352\(v=vs.105\).aspx) for details
* **On a fullsize Mac keyboard:** `fn-page down` works for me, although the magic combo seems to vary a lot for people across the web. `fn-escape` has been reported to work as well.

## Conventions

* All CoffeeScript should be indented with 2 spaces (soft tabs).
* All JavaScript files should be indented with 4 spaces (soft tabs).
