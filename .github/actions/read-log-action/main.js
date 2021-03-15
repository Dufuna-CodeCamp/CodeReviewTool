const core = require("@actions/core");
const github = require("@actions/github");
const fs = require('fs');

async function checkLogExistenceInPR({ owner, repo, path }) {
    try {
        token = core.getInput("repo-token");
        const octokitClient = github.getOctokit(token);

        await octokitClient.repos.getContents({
            method: 'HEAD',
            owner: owner,
            repo: repo,
            path: path
        })
        return true;

    } catch(error) {

        if (error.status === 404) {
            await octokitClient.pulls.createReview({
                owner: github.context.repo.owner,
                repo: github.context.repo.repo,
                pull_number: pr.number,
                body: "There is no log file present in this pull request. Please ensure that you run the tests locally.",
                event: "REQUEST_CHANGES"
            });
        }
        core.debug(`Not approv`)
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

checkLogExistenceInPR({ 
    owner: github.context.repo.owner, 
    repo: github.context.repo.repo,
    path: core.getInput('path-to-log-file')
}).then( doesExist => {
    if (doesExist) {
        getContent()
    } else {
        throw new Error("Build failed because no log file is present, changes are requested!");
    }
})