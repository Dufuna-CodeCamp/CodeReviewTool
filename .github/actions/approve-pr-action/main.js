const core = require("@actions/core");
const github = require("@actions/github");
const { GitHub } = require("@actions/github/lib/utils");

async function run() {
    try {
        const status = core.getInput("status");
        const token = core.getInput("repo-token");

        const pr = github.context.payload;

        if (!pr) {
            throw new Error("Event payload is missing `pull_request`");
        }

        const client = github.getOctokit(token);
        core.debug(`Checking review for pull request #${pr.number}`);

        if (status == 'PASS') {
            await client.pulls.createReview({
                owner: github.context.repo.owner,
                repo: github.context.repo.repo,
                pull_number: pr.number,
                event: "APPROVE"
            });
            core.debug(`Approved pull request #${pr.number}`);
        } else {
            await client.pulls.createReview({
                owner: github.context.repo.owner,
                repo: github.context.repo.repo,
                pull_number: pr.number,
                event: "REQUEST_CHANGES"
            });
            core.debug(`Not approv`)
        }

    } catch(error) {
        core.setFailed(error.message);
    }
}

run();