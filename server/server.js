import { serve } from "https://deno.land/std@0.67.0/http/server.ts";

// std@0.67.0 | Deno: https://deno.land/std@0.67.0/fs
// import {  readFileStrSync } from "https://deno.land/std/fs@0.67.0/mod.ts";
// readFileStrSync("../script/setup.sh", { encoding: "utf8" });
const fp = [
  "script/setup.sh"
];
const text = await Deno.readTextFile(fp[0]);

const s = serve({ port: 8000 });
console.log("http://localhost:8000/");
for await (const req of s) {
  req.respond({ body: "test" });
  
}

// JSON.stringify(req)
