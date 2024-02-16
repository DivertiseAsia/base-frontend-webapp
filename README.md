# base-frontend-webapp

## About

This is a base project used for multiple projects with Divertise Asia. It serves as a good scaffold to work from. Please note this project is unmaintained and behind the current versions that exist for rescript and other libraries.

## Get Started

```sh
npm install
```

## Updating translations

Run the extract and update the relevant language file json

By default we use react-intl which is found here: https://formatjs.io/docs/intl

```sh
npm run extract
```

## Running the project

Note: if you `run server` it expects you to run against a local server, so don't forget to start it up

To run the rescript build (ensures compilation)

```sh
npm start
```

To run webpack to host the webapplication (compiles scss and runs compiled code)

```sh
npm run server
```

## Customize the project

Find and replace `cards-front` with your desired project name

## Note on other branches

They contain features that have not been able to be merged back to main. If you want to use them go ahead, but they have not been fully tested out.
