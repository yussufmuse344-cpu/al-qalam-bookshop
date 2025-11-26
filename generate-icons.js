import fs from "fs";
import path from "path";
import sharp from "sharp";
import { fileURLToPath } from "url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const svgPath = path.join(__dirname, "public", "icon.svg");
const outputDir = path.join(__dirname, "public");

async function generateIcons() {
  const svgBuffer = fs.readFileSync(svgPath);

  // Generate different sizes
  const sizes = [
    { size: 512, name: "icon-512.png" },
    { size: 192, name: "icon-192.png" },
    { size: 180, name: "apple-touch-icon.png" },
    { size: 32, name: "favicon-32x32.png" },
    { size: 16, name: "favicon-16x16.png" },
  ];

  console.log("🎨 Generating app icons...\n");

  for (const { size, name } of sizes) {
    try {
      await sharp(svgBuffer)
        .resize(size, size)
        .png()
        .toFile(path.join(outputDir, name));
      console.log(`✅ Generated ${name} (${size}x${size})`);
    } catch (error) {
      console.error(`❌ Error generating ${name}:`, error.message);
    }
  }

  // Also create icon.png (main icon)
  try {
    await sharp(svgBuffer)
      .resize(512, 512)
      .png()
      .toFile(path.join(outputDir, "icon.png"));
    console.log(`✅ Generated icon.png (512x512)`);
  } catch (error) {
    console.error(`❌ Error generating icon.png:`, error.message);
  }

  console.log("\n✨ Icon generation complete!");
  console.log("\n📱 To update Android icons, run: npm run assets:generate");
}

generateIcons().catch(console.error);
