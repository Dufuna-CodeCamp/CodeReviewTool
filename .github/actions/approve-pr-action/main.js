const core = require("@actions/core");
const github = require("@actions/github");
const { GitHub } = require("@actions/github/lib/utils");

var status;
var token;
var octokitClient;


async function run() {
    try {
        status = core.getInput("status");
        token = core.getInput("repo-token");

        const pr = github.context.payload;

        if (!pr) {
            throw new Error("Event payload is missing `pull_request`");
        }

        const octokitClient = github.getOctokit(token);
        core.debug(`Checking review for pull request #${pr.number}`);

        if (status == 'PASS') {
            await octokitClient.pulls.createReview({
                owner: github.context.repo.owner,
                repo: github.context.repo.repo,
                pull_number: pr.number,
                event: "APPROVE"
            });
            core.debug(`Approved pull request #${pr.number}`);
        } else {
            await octokitClient.pulls.createReview({
                owner: github.context.repo.owner,
                repo: github.context.repo.repo,
                pull_number: pr.number,
                body: "This pr is not approved",
                event: "REQUEST_CHANGES"
            });
            core.debug(`Not approv`)
        }

    } catch(error) {
        core.setFailed(error.message);
    }
}

run();