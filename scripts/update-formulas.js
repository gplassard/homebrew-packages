const { Octokit } = require("@octokit/rest");
const fs = require("fs");
const path = require("path");
const crypto = require("crypto");
const https = require("https");

const octokit = new Octokit({
    auth: process.env.GITHUB_TOKEN
});

async function getLatestRelease(owner, repo) {
    const { data } = await octokit.repos.getLatestRelease({
        owner,
        repo
    });
    return data;
}

function downloadFile(url) {
    return new Promise((resolve, reject) => {
        https.get(url, (res) => {
            if (res.statusCode === 302 || res.statusCode === 301) {
                return downloadFile(res.headers.location).then(resolve).catch(reject);
            }
            const chunks = [];
            res.on("data", (chunk) => chunks.push(chunk));
            res.on("end", () => resolve(Buffer.concat(chunks)));
            res.on("error", reject);
        }).on("error", reject);
    });
}

function calculateSHA256(buffer) {
    return crypto.createHash("sha256").update(buffer).digest("hex");
}

async function updateFormula(filePath) {
    console.log(`Checking ${filePath}...`);
    let content = fs.readFileSync(filePath, "utf8");

    const urlMatch = content.match(/url "(https:\/\/github\.com\/([^/]+)\/([^/]+)\/releases\/download\/[^"]+)"/);
    if (!urlMatch) {
        console.log(`No GitHub release URL found in ${filePath}`);
        return;
    }

    const [fullUrl, baseUrl, owner, repoWithMaybeSuffix] = urlMatch;
    const repo = repoWithMaybeSuffix.replace(/\/$/, "");
    
    const latestRelease = await getLatestRelease(owner, repo);
    const latestVersion = latestRelease.tag_name.replace(/^v/, "");

    // Check if it's a Cask or a Formula
    const isCask = content.includes('cask "');
    
    if (isCask) {
        const versionMatch = content.match(/version "([^"]+)"/);
        const currentVersion = versionMatch ? versionMatch[1] : null;

        if (currentVersion === latestVersion) {
            console.log(`${filePath} is already up to date (${latestVersion})`);
            return;
        }

        console.log(`Updating ${filePath} from ${currentVersion} to ${latestVersion}`);
        content = content.replace(/version "[^"]+"/, `version "${latestVersion}"`);

        // Update all sha256 in Cask
        const shaMatches = content.matchAll(/sha256 "([^"]+)"/g);
        const urlMatches = content.matchAll(/url "([^"]+)"/g);
        
        const urls = [...urlMatches].map(m => m[1]);
        for (const url of urls) {
            const resolvedUrl = url.replace("#{version}", latestVersion).replace("#{version}", latestVersion);
            console.log(`Downloading ${resolvedUrl} to calculate hash...`);
            const buffer = await downloadFile(resolvedUrl);
            const newHash = calculateSHA256(buffer);
            
            // This is a bit tricky if there are multiple hashes. 
            // We'll try to find the hash that follows the URL or is in the same block.
            // Simplified: replace hashes one by one in order of appearance? 
            // Or better, find the specific sha256 that belongs to this url block.
        }
        
        // Refined Cask hash update
        const lines = content.split('\n');
        for (let i = 0; i < lines.length; i++) {
            if (lines[i].includes('url "')) {
                const url = lines[i].match(/url "([^"]+)"/)[1].replace(/#\{version\}/g, latestVersion);
                console.log(`Downloading ${url}...`);
                const buffer = await downloadFile(url);
                const newHash = calculateSHA256(buffer);
                
                // Find next sha256
                for (let j = i + 1; j < lines.length; j++) {
                    if (lines[j].includes('sha256 "')) {
                        lines[j] = lines[j].replace(/sha256 "[^"]+"/, `sha256 "${newHash}"`);
                        break;
                    }
                }
            }
        }
        content = lines.join('\n');

    } else {
        const versionMatch = content.match(/releases\/download\/v([^/]+)\//) || content.match(/releases\/download\/([^/]+)\//);
        const currentVersion = versionMatch ? versionMatch[1] : null;

        if (currentVersion === latestVersion) {
            console.log(`${filePath} is already up to date (${latestVersion})`);
            return;
        }

        console.log(`Updating ${filePath} from ${currentVersion} to ${latestVersion}`);
        
        const newUrl = fullUrl.replace(currentVersion, latestVersion).replace(currentVersion, latestVersion);
        content = content.replace(fullUrl, `url "${newUrl}"`);
        
        const downloadUrl = newUrl;
        console.log(`Downloading ${downloadUrl}...`);
        const buffer = await downloadFile(downloadUrl);
        const newHash = calculateSHA256(buffer);
        
        content = content.replace(/sha256 "[^"]+"/, `sha256 "${newHash}"`);
    }

    fs.writeFileSync(filePath, content);
    console.log(`Successfully updated ${filePath}`);
}

async function main() {
    const args = process.argv.slice(2);
    const files = args;

    for (const file of files) {
        if (fs.existsSync(file)) {
            try {
                await updateFormula(file);
            } catch (error) {
                console.error(`Error updating ${file}:`, error.message);
            }
        } else {
            console.error(`File ${file} not found`);
        }
    }
}

main();
