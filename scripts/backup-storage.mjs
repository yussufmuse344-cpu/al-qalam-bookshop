import { createClient } from "@supabase/supabase-js";
import { mkdir, writeFile } from "node:fs/promises";
import { dirname, join } from "node:path";

const SUPABASE_URL = process.env.SUPABASE_URL;
const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!SUPABASE_URL || !SUPABASE_SERVICE_ROLE_KEY) {
  console.error("Missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY.");
  process.exit(1);
}

const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, {
  auth: { persistSession: false },
});

async function ensureDir(p) {
  await mkdir(p, { recursive: true });
}

async function backup() {
  console.log("Listing storage buckets...");
  const { data: buckets, error: bucketErr } =
    await supabase.storage.listBuckets();
  if (bucketErr) {
    console.error("Failed to list buckets:", bucketErr.message || bucketErr);
    process.exit(1);
  }

  if (!buckets || buckets.length === 0) {
    console.log("No storage buckets found.");
    return;
  }

  for (const bucket of buckets) {
    console.log(`Backing up bucket: ${bucket.name}`);
    await backupBucket(bucket.name);
  }
}

async function backupBucket(bucket) {
  const baseDir = join("backups", "storage", bucket);
  await ensureDir(baseDir);
  await listAndDownload(bucket, "", baseDir);
}

async function listAndDownload(bucket, prefix, outDir) {
  const limit = 1000;
  let offset = 0;

  // Loop through pages for this prefix
  while (true) {
    const { data: items, error } = await supabase.storage
      .from(bucket)
      .list(prefix, {
        limit,
        offset,
        sortBy: { column: "name", order: "asc" },
      });

    if (error) {
      console.error(
        `List failed for bucket=${bucket}, prefix='${prefix}':`,
        error.message || error
      );
      throw error;
    }

    if (!items || items.length === 0) break;

    for (const item of items) {
      // Folders in list() typically have no id
      const isFolder = !item.id;
      const pathPart = prefix ? `${prefix}/${item.name}` : item.name;

      if (isFolder) {
        const folderDir = join(outDir, item.name);
        await ensureDir(folderDir);
        await listAndDownload(bucket, pathPart, folderDir);
      } else {
        console.log(`Downloading ${bucket}/${pathPart}`);
        const { data: fileData, error: downloadErr } = await supabase.storage
          .from(bucket)
          .download(pathPart);
        if (downloadErr) {
          console.error(
            `Download failed for ${bucket}/${pathPart}:`,
            downloadErr.message || downloadErr
          );
          throw downloadErr;
        }
        const buf = Buffer.from(await fileData.arrayBuffer());
        const target = join(outDir, item.name);
        await ensureDir(dirname(target));
        await writeFile(target, buf);
      }
    }

    if (items.length < limit) break;
    offset += items.length;
  }
}

backup().catch((e) => {
  console.error("Storage backup failed:", e);
  process.exit(1);
});
