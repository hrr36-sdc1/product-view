const helpers = require('./helpers');

console.time('datagen');

const N = 1000000;
const n = process.env.ID;
helpers.generateProductFile(N, n, process.env.ID);

console.timeEnd('datagen');
