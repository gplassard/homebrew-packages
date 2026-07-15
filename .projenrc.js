const { BaseProject, WorkflowActionsX, githubAction } = require('@gplassard/projen-extensions');
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
        packages: 'read'
    },
    steps: [
        WorkflowActionsX.checkout(),
        WorkflowActionsX.generateGithubToken({
            permissions: { contents: 'write', pullRequests: 'write' }
        }),
        WorkflowActionsX.setupPnpm({}),
        WorkflowActionsX.setupNode({}),
        {
            run: 'npm view @gplassard/projen-extensions --registry=https://npm.pkg.github.com',
            env: { NODE_AUTH_TOKEN: '${{ secrets.GITHUB_TOKEN }}' },
        },
        {
            run: 'curl -i -H "Authorization: Bearer $NODE_AUTH_TOKEN" https://npm.pkg.github.com/@gplassard%2Fprojen-extensions',
            env: { NODE_AUTH_TOKEN: '${{ secrets.GITHUB_TOKEN }}' },
        },
        WorkflowActionsX.installDependencies({}),
        {
            name: 'Upgrade formulas',
            env: {
                GITHUB_TOKEN: '${{ steps.generate_token.outputs.token }}',
            },
            run: `
FORMULAS="\${{ github.event.inputs.formulas }}"
if [ -z "$FORMULAS" ]; then
  node scripts/update-formulas.js ${ALL_FORMULAS.join(' ')}
else
  node scripts/update-formulas.js $(echo $FORMULAS | tr ',' ' ')
fi`,
        },
        {
            name: 'Create Pull Request',
            uses: githubAction('peter-evans/create-pull-request'),
            with: {
                token: '${{ steps.generate_token.outputs.token }}',
                'commit-message': 'chore: upgrade homebrew formulas',
                title: 'chore(upgrade): upgrade homebrew formulas',
                body: 'This PR upgrades the homebrew formulas to their latest versions.',
                branch: 'chore/upgrade-formulas',
            },
        },
    ],
});

project.synth();
