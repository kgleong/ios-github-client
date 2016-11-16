# Github Search

This is a work in progress.

## Description

![Github Search demo](/images/github-search-demo-1.gif)

iOS app that searches Github repositories by:

* repository name
* language
* minimum star count

## Features

* Utilizes auto-layout
* Custom notification for **Loading** and **Canceled** modals.
* Saves filter settings to user preferences.
* Infinite scroll on repository list.
* Search bar allows searching by repostiory name.
    * First searches the repository list in memory.
    * Submitting the search makes a request to the Github API and reloads the repository list with the results.
* Dynamic settings `UITableView`.
    * Expands and collapses language filters via a language filter toggle.

## Specifications

|Name|Value|
|----|-----|
|**Language**|Swift 3|
|**iOS version**|9.3|
