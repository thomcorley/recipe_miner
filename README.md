# Recipe Miner

Give RecipeMiner a list of recipe websites and run `Miner.start` from the console to create a curated database of recipes.

Designed to provide an API back end to [recipe-miner-client](https://github.com/thomcorley/recipe-miner-client), but could be used as a generic recipe database for anything you like.

## How it works

The default parser is defined in the `RecipeFinder::JsonSchema` module which relies on the presence of standardised [Recipe Schema](https://schema.org/Recipe) in the HEAD of the recipe webpage. This is the metadata that allows search engines to provide summary recipe information inline in search results.

If a website doesn't implement the standard JSON schema for recipes, you can create a custom parsing class to obtain the recipe information from the HTML on the page and save it in the format required by RecipeMiner.

## Dependencies

* Ruby (>= 2.7.0)
* Rails (>= 6.0.0)
* Bundler

## Installation

1. Clone this repository
```
git clone git@github.com:thomcorley/recipe_miner.git
```

2. Install dependencies
```
bundle install
```

3. Start the job worker
```
bundle exec rake jobs:work
```

4. Open a Rails console in a new terminal
```
bundle exec rails console
```

5. Begin mining for recipes
```
Miner.start
```

Note: you can add/remove different recipe websites from the default list in **lib/website_directory.txt**.


