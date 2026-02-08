const { BaseProject, WorkflowActionsX } = require('@gplassard/projen-extensions');
const { GitHub } = require('projen/lib/github');

const ALL_FORMULAS = [
    'aws-credentials-switcher.rb',
    'jaw.rb',
    'pretty-logs.rb',
    'ssm-env.rb',
    // 'Casks/woof.rb' // updated by goreleaser
];

const project = new BaseProject({
    name: 'homebrew-packages',
    deps: [
        'octokit',
        '@octokit/rest'
    ]
});

project.addTask('upgrade-formula', {
    exec: 'node scripts/update-formulas.js',
});

const github = GitHub.of(project);
const upgradeWorkflow = github.addWorkflow('upgrade-formula');
upgradeWorkflow.on({
    schedule: [{ cron: '0 0 * * *' }],
    workflowDispatch: {
        inputs: {
            formulas: {
                description: 'Comma separated list of formulas to update (e.g. jaw.rb,Casks/woof.rb). Leave empty to update all.',
                required: false,
                default: '',
            }
        }
    },
});

upgradeWorkflow.addJob('upgrade', {
    runsOn: ['ubuntu-latest'],
    permissions: {
        contents: 'write',
        pullRequests: 'write',
    },
    steps: [
        WorkflowActionsX.checkout(),
        {
            name: 'Upgrade formulas',
            env: {
                GITHUB_TOKEN: '${{ secrets.GITHUB_TOKEN }}',
            },
            run: `
FORMULAS="\${{ github.event.inputs.formulas }}"
if [ -z "$FORMULAS" ]; then
  npx projen upgrade-formula ${ALL_FORMULAS.join(' ')}
else
  npx projen upgrade-formula $(echo $FORMULAS | tr ',' ' ')
fi`,
        },
        {
            name: 'Create Pull Request',
            uses: 'peter-evans/create-pull-request@v6',
            with: {
                token: '${{ secrets.GITHUB_TOKEN }}',
                commit_message: 'chore: upgrade homebrew formulas',
                title: 'chore: upgrade homebrew formulas',
                body: 'This PR upgrades the homebrew formulas to their latest versions.',
                branch: 'chore/upgrade-formulas',
            },
        },
    ],
});

project.synth();