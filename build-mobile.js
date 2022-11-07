#!/usr/bin/env node

/* 
  MOBILE_PLATFORM = android | ios (default)
  MOBILE_RELEASE = release | dev | *empty* (no apk/app generation)
*/

const shelljs = require('shelljs');

const androidBuild = process.env.MOBILE_PLATFORM === 'android';
const build = process.env.MOBILE_RELEASE != '';
const releaseBuild = process.env.MOBILE_RELEASE === 'release';

process.stdout.write('Building for ');
process.stdout.write(androidBuild ? 'android' : 'ios');
process.stdout.write(releaseBuild ? ' in release' : ' NOT release');

process.stdout.write('\n\nCleaning old build');
shelljs.exec('npm run clean');

process.stdout.write('\n\nCleaning mobile build directory');
shelljs.rm('-rf', 'app/www/*');

process.stdout.write('\n\nMaking reason build');
shelljs.exec('npm run build');

if (androidBuild) {
  process.stdout.write('\n\nBuilding android version\n');
  shelljs.exec('cross-env NODE_ENV=production MOBILE_BUILD=true PUBLIC_PATH=/android_asset/www/ webpack --config webpack.prod.js');
} else {
  process.stdout.write('\n\nBuilding ios version\n');
  shelljs.exec('cross-env NODE_ENV=production MOBILE_BUILD=true webpack --config webpack.prod.js');  
}

process.stdout.write('\n\nCopying over new build');
shelljs.cp('-R', 'build/*', 'app/www');


if (build) {
  shelljs.cd('app/www');
  const releaseCommand = releaseBuild ? ' --release' : '';
  if (androidBuild) {
    process.stdout.write('\n\nCompiling Android.... Release? ' + releaseBuild + "\n");
    shelljs.exec('cordova build android' + releaseCommand);
  } else {
    process.stdout.write('\n\nCompiling ios.... Release? ' + releaseBuild + "\n");
    shelljs.exec('cordova build ios' + releaseCommand);
  }
}

process.stdout.write('\n\n **Process Complete**');





