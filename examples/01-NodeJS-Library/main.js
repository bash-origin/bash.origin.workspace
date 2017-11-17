#!/usr/bin/env bash.origin.test via github.com/facebook/jest

const LIB = require("../..").LIB;


test('Test', function () {

    expect(LIB.LODASH.merge({
        foo: "bar"
    }, {
        name: "value"
    })).toEqual({
        foo: "bar",
        name: "value"
    });
});
