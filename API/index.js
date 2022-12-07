const DBURL = '';

const mongoose = require('mongoose');
const express = require('express');

mongoose.connect(DBURL, {useNewUrlParser: true, useUnifiedTopology: true});

const DB = mongoose.connection;

DB.model('Billing', new mongoose.Schema(
  {
    ownerId: {type: mongoose.SchemaTypes.ObjectId, required: true, ref: 'Owner'},
    hoursStayed: {type: Number, required: true, default: 0},
    hourRate: {type: Number, required: true, default: 20},
    amountOwed: {type: Number, required: true, default: 0}
  }
));

DB.model('Owner', new mongoose.Schema(
  {
    ownerFirstName: {type: String, required: true},
    ownerLastName: {type: String, required: true},
    ownerAddress: {type: String, required: true},
    ownerPhone: {type: string, required: true},
    ownerEmail: {type: string, required: true},
    ownerPet: [
      {type: mongoose.Schema.ObjectId, ref: 'Pet'}
    ]
  }
));

DB.model('Pet', new mongoose.Schema(
  {
    petName: {type: String, required: true},
    petType: {type: String, required: true}
  }
));
