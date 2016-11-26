# Github Search

## Description

Available on the [App Store](https://itunes.apple.com/us/app/omako-repo-search/id1178868631)

![Github Search demo](/images/github-search-demo-1.gif)

iOS app that searches Github repositories by:

* Repository name
* Username
* Language
* Minimum star count

## Features

* Minimal use of third party libraries.
    * `AlamoFire` and `AFNetworking` used for making network requests and remote image fetching, respectively.
    * Custom notification for **Loading** and **Canceled** modals.
* Utilizes auto-layout
* Saves filter settings to user preferences.
* Infinite scroll on repository list.
* When a user selects a repository, a `SFSafariViewController` is presented to display the repository Github page.
* Search bar allows searching by repostiory name.
    * First searches the repository list in memory.
    * Submitting the search makes a request to the Github API and reloads the repository list with the results.
    * Custom tool tip for search bar.
* Dynamic settings `UITableView`.
    * Expands and collapses language filters via a language filter toggle.

## Specifications

|Name|Value|
|----|-----|
|**Language**|Swift 3|
|**iOS version**|9.3|
