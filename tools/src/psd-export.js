const psd = require('psd');
const path = require('path');
const fs = require('fs');

async function exportPsd(fileName, assetsDirPath, outputDir) {
    if (!fileName.endsWith('.psd') || fileName.startsWith('_')) {
        return;
    }

    const psdPath = path.resolve(assetsDirPath, fileName);
    const psdFile = await psd.fromFile(psdPath);
    psdFile.parse();
    return psdFile.image.saveAsPng(path.resolve(outputDir, fileName.replace('.psd', '.png')));
}

async function main(assetsDir, outputDir) {
    const outputPath = path.resolve(__dirname, outputDir);
    fs.mkdirSync(outputPath, { recursive: true });
    const assetImagesPath = path.resolve(__dirname, assetsDir);
    const files = fs.readdirSync(assetImagesPath);

    for (const file of files) {
        await exportPsd(file, assetImagesPath, outputPath);
    }
}

const args = process.argv.slice(2);
const [assetsDir, outputDir] = args;

main(assetsDir, outputDir)
  .then(() => console.log("Done"))
  .catch((error) => console.error(error));
