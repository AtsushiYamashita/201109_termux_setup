//Denoとはなにか - 実際につかってみる - Qiita
//: https://qiita.com/azukiazusa/items/8238c0c68ed525377883


import { serve } from "https://deno.land/std@0.67.0/http/server.ts";

// std@0.67.0 | Deno: https://deno.land/std@0.67.0/fs
// import {  readFileStrSync } from "https://deno.land/std/fs@0.67.0/mod.ts";
// readFileStrSync("../script/setup.sh", { encoding: "utf8" });
const folder = "script";
const fp = [
  "/setup.sh",
  "/variables.sh"
];
const fn =  fp.map(e=>e);

const s = serve({ port: 8000 });
console.log("http://localhost:8000/");
for await (const req of s) {
  console.log("\n\n");
  console.log(Object.keys(req));
  console.log(req.url);
  const res = fn.filter(e=>e === req.url);
  console.log(folder+res[0]);
  if(res.length < 1){
    req.respond({ body: "none" });
    continue;
  }
  const ret = await Deno.readTextFile(folder+res[0]);
  req.respond({ body:ret  });
}

// JSON.stringify(req)
