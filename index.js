'use strict';

/* ────────╮
 │ cordial🍋 Version specific lib router
 ╰─────────┴─────────────────────────────────────────────────────────────────── */
/* eslint import/no-dynamic-require:0 */
module.exports = require(`${ __dirname }/lib/index-${ process.version.split('.').shift() }`);