const core = require("@actions/core");
const github = require("@actions/github");
const fs = require('fs');

token = core.getInput("repo-token");
const octokitClient = github.getOctokit(token);

async function checkLogExistenceInPR({ owner, repo, pull_number, path }) {
    try {

        var fileList = await octokitClient.pulls.listFiles({
            owner: owner,
            repo: repo,
            pull_number: pull_number
        })

        for (var i = 0; i < fileList.length; i++) {
            if (fileList[i].filename === 'logfile.json') {
                return true;
            }
        }
        return false
    } catch(error) {
        core.setFailed(error.message);
        return false;
    }
}

function getContent() {

    try {
        const filePath = core.getInput('path-to-log-file');

        fs.readFile(filePath, 'utf8', (error, data) => {
            core.setOutput("log-file-content", data)
        });
    
    } catch(error) {
        core.setFailed(error.message);
    }
}

function callCheck() {
    checkLogExistenceInPR({ 
        owner: github.context.repo.owner, 
        repo: github.context.repo.repo,
        path: core.getInput('path-to-log-file')
    }).then( async doesExist => {
        try {
            if (doesExist) {
                getContent()
            } else {
                throw new Error("Build failed because no log file is present, changes are requested!");
            }
        }  catch(error) {
            await octokitClient.pulls.createReview({
                owner: github.context.repo.owner,
                repo: github.context.repo.repo,
                pull_number: pr.number,
                body: "There is no log file present in this pull request. Please ensure that you run the tests locally.",
                event: "REQUEST_CHANGES"
            });
            core.setFailed(error.message);
        }
            
    })
}

callCheck();
