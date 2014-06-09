This is a fork of https://github.com/RallySoftwareLabs/alm-mobile with some new views that we hope to sell someday. 

This site is currently running at https://m.rallydev.com.

## How can I contribute?

We welcome pull requests, so if you would like the site to behave differently or would like to see additional functionality, you can make the code change yourself and [submit a pull request](https://help.github.com/articles/creating-a-pull-request). 

## Ready to hack? Here's how.

Clone the repo.

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
- **mode**: Which mode do you want to run the site in? The only currently acceptable value is "board"

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

## Mocha

The JavaScript tests are written in mocha. A typical developer experience for building tests is to run: ```grunt test:server``` in one terminal, ```grunt && grunt watch``` in another and to open any browser to http://localhost:8900/