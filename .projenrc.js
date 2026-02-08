const { BaseProject } = require('@gplassard/projen-extensions');

const project = new BaseProject({
    name: 'homebrew-packages',
    datadog: {
        softwareCompositionAnalysis: false,
        staticAnalysis: false,
    }
});
project.synth();