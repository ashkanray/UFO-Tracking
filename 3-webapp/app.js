'use strict';
const http = require('http');
var assert = require('assert');
const express= require('express');
const app = express();
const mustache = require('mustache');
const filesystem = require('fs');
const url = require('url');
const port = Number(process.argv[2]);

const hbase = require('hbase')
var hclient = hbase({ host: process.argv[3], port: Number(process.argv[4])})


hclient.table('arohani_ufo_usa_state_year').scan(
	{
		filter: {
			type: "PrefixFilter",
			value: "TX"
		},
		maxVersions: 1
	},
	function (err, cells) {
		console.info(cells);
		console.info(groupByYear("TX", cells));
	})

function removePrefix(text, prefix) {
    if(text.indexOf(prefix) != 0) {
        throw "missing prefix"
    }
    return text.substr(prefix.length)
}

function ufo_sightings(totals) {
    console.info(totals);
    let sightings = totals["Total_Sightings"];

    return sightings; /* One decimal place */
}

function rowToMap(row) {
	var stats = {}
	row.forEach(function (item) {
		stats[item['column']] = Number(item['$'])
	});
	return stats;
}

function groupByYear(state_val, cells) {
	
    function yearTotalsToYearAverages(year, yearTotals) {
		let yearRow = { year : year };
		yearRow['sighting'] = ufo_sightings(yearTotals);
		
		return yearRow;
	}
	let result = []; // let is a replacement for var that fixes some technical issues
	let yearTotals; // Flights and delays for each year
	let lastYear = 0; // No year yet
	
    cells.forEach(function (cell) {
		let year = Number(removePrefix(cell['key'], state_val));
		if(lastYear !== year) {
			if(yearTotals) {
				result.push(yearTotalsToYearAverages(year, yearTotals))
			}
			yearTotals = {}
		}
		yearTotals[removePrefix(cell['column'], 'ufo:')] = Number(cell['$'])
		lastYear = year;
	})
	return result;
}


app.use(express.static('public'));
app.get('/sightings.html',function (req, res) {
    const state_val = req.query['state'];
    console.log(state_val);
	hclient.table('arohani_ufo_usa_state_year').scan(
		{
			filter: {
				type: "PrefixFilter",
				value: state_val
			},
			maxVersions: 1
		},
		function (err, cells) {
			let template = filesystem.readFileSync("result.mustache").toString();
			let input = { yearly_averages: groupByYear(state_val, cells)};
			let html = mustache.render(template,  { yearly_averages: groupByYear(state_val, cells)});
		res.send(html);
	})
});
	
app.listen(port);
