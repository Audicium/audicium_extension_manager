## Features
This repo contains the extension package for the Audicium project 

## Creating a extension repo

To add a extension to the app

create a json file that contains the folowing data

```json
{
  'name': 'awesome repo',
  'repoUrl': 'github.com/...../repo.json',#ueses this url to update the repo
  'version': '0.0.1',
  'extensions': [
    # extensions
  ]
}
```
```json
# this is how extensions should be structured
{
  'metaPath': 'github.com/..../awesome_extension.json',
}
```

awesome_extension.json contains information about the extension 

```json
  'name': name,
  'icon': icon,
  'author': author,
  'version': version,
  'repoUrl': repoUrl,
  'scriptUrl': scriptUrl,
  'metaDataUrl': metaDataUrl,
  # optional: store any other headers required for getting other metaata from the site
  # e.g images
  'audioHeaders': {'referrer:awesomewebsite.com'},
  'headers': {'referrer:awesomewebsite.com'},
```

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Dev Utils 

```bash
dart run serious_python:main package ..\..\extension_server\src\ --mobile
```

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder.

```dart
const like = 'sample';
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
