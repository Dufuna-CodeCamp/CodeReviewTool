# Review Tool

This tool is used to automate code review process using tests. Tests are written to tally with what is expected in a particular pull request, these tests are expected to be run locally by the individual making the pull request. The result of the tests pushed alongside the changes made in the project is then used to determine if the pull request is fit for approval. If it is *fit for approval*, the Github-action bot `approves` the pull request and if otherwise, `changes are requested` along with a message describing what went wrong. These messages might not appear in all instance.

## Demo

## Technologies Used

- Batchfile *`- for scripts related to Windows OS`*

- JS

- [mochajs](https://mochajs.org) *`- test framework used`*

- Shell

- Github Actions

## Want to contribute?

Here are some resources that might make contributing to this repository easier. You should do well to take your time going through them. OR check them out when you run into an issue 😉.

> My advice would be for you to take your time and get acquainted with these resources before you contribute.

- [Creating a JavaScript action](https://docs.github.com/en/actions/creating-actions/creating-a-javascript-action)

- [Github API docs](https://docs.github.com/en/rest/reference/pulls#list-pull-requests-files) *`-  for anything Pull Request related`*

- [Octokit docs](https://octokit.github.io/rest.js/v18#usage)

- [A-Z index of Windows CMD commands](https://ss64.com/nt/)

- [Writing workflows for Github actions](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions)

- [Font formatting on Windows Command Line](https://gist.githubusercontent.com/mlocati/fdabcaeb8071d5c75a2d51712db24011/raw/b710612d6320df7e146508094e84b92b34c77d48/win10colors.cmd)

## Technical Description
To use this tool:

- You can fork the repository and use as a base for your project 

`OR`

- You can add the `.github`, `.gitignore` and `tests` folder directly into your project.

Whichever options feels doable to you should work just fine.

## Using the tool *`- sample`*
Tests that will be run are located inside a subfolder in the `tests` folder. e.g. `issue1` folder contains tests that should be run before creating a pull request for issue 1.

### For Windows OS
- Run command prompt as administrator

- Navigate to the `tests` folder in the project directory

- Navigate to the current issue you're working on e.g. `issue1`

- Run the `test.bat` file

- After completion of the running of the file, test results are displayed on the command line. If the tests do not pass, errors are displayed to help you figure out where the issue might be from.

- Once all tests pass, you can push your changes and create a pull request.

### For Linux & Mac OS
- Open the terminal

- Navigate to the `tests` folder in the project directory

- Navigate to the current issue you're working on e.g. `issue1`

- Run the `test.sh` file

- After completion of the running of the file, test results are displayed on the command line. If the tests do not pass, errors are displayed to help you figure out where the issue might be from.

- Once all tests pass, you can push your changes and create a pull request.

## Authors
- Folashade Daniel - `@beccadaniel` *on Github*

## Acknowledgements
`Thanks Everyone!!!`