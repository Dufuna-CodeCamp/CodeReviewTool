const core = require("@actions/core");
const fs = require('fs');

function getContent() {

    try {
        const filePath = core.getInput('path-to-log-file');

        fs.readFile(filePath, 'utf8', (error, data) => {
            console.log(data)
            core.setOutput("log-file-content", content)
        });
    
    } catch(error) {
        core.setFailed(error.message);
    }
}

getContent();