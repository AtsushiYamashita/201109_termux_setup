//Denoとはなにか - 実際につかってみる - Qiita
//: https://qiita.com/azukiazusa/items/8238c0c68ed525377883

// https://deno.land/std@0.74.0
import {
  // walk,
  walkSync
} from "https://deno.land/std@0.74.0/fs/mod.ts";

import {
  serve
} from "https://deno.land/std@0.67.0/http/server.ts";

// std@0.67.0 | Deno: https://deno.land/std@0.67.0/fs
// import {  readFileStrSync } from "https://deno.land/std/fs@0.67.0/mod.ts";
// readFileStrSync("../script/setup.sh", { encoding: "utf8" });
const FOLDER = "script";
const fp = [];
for (const entry of walkSync(FOLDER + "/")) {
  fp.push("/" + entry.name)
}

const s = serve({ port: 8000 });

const list = fp
  .map(e => e)
  .map(e => `<a href="${e}">${FOLDER + e}</a>`)
  .join("<br>");

console.log("http://localhost:8000/");
for await (const req of s) {
  console.log("Req received\n");
  const res = fp.filter(e => e === req.url);
  // console.log(Object.entries(req));
  // console.log("req", req._body);
  // console.log("referer is", req.headers.referer);
  if (res.length < 1) {
    req.respond({ body: list });
    continue;
  }
  console.log(FOLDER + res[0]);
  const ret = await Deno.readTextFile(FOLDER + res[0]);
  req.respond({ body: ret });
}

// JSON.stringify(req)
